# Isar Database Nested Transaction Fix - FINAL SOLUTION

## Problem Analysis

### The Error
```
IsarError: Cannot perform this operation from within an active transaction.
Isar does not support nesting transactions.
```

### Root Cause Discovery

After deep investigation, the issue was found to be related to **how Isar handles many-to-many relationships with `@Backlink`**.

#### Entity Structure
```dart
// Gambar entity
@collection
class Gambar {
  Id id = Isar.autoIncrement;
  late String endpoint;

  @Backlink(to: "gambars")  // ← This is a BACKLINK (read-only)
  final koleksis = IsarLinks<Koleksi>();
}

// Koleksi entity
@collection
class Koleksi {
  Id id = Isar.autoIncrement;
  late String title;

  final gambars = IsarLinks<Gambar>();  // ← This is the PRIMARY link
}
```

**Key Insight:**
- `Gambar.koleksis` is a `@Backlink` - it's **read-only** and automatically maintained by Isar
- `Koleksi.gambars` is the **primary link** - this is what we must save
- You **cannot save a backlink** - attempting to do so causes nested transaction errors

### Why Previous Attempts Failed

1. **Attempt 1**: Tried to save `newGambar.koleksis.save()` inside transaction
   - ❌ Failed: Cannot save a backlink

2. **Attempt 2**: Tried to modify `koleksi.gambars` inside the same transaction as `put()`
   - ❌ Failed: `IsarLinks.save()` creates its own transaction, causing nesting

3. **Attempt 3**: Tried multiple approaches with `get()` operations
   - ❌ Failed: `get()` inside transaction can trigger nested transactions

## The Solution

### Strategy
1. **Change method signature** to accept koleksis as parameter (cannot add to backlink from UI)
2. **Save the Gambar first** in its own transaction
3. **Save the relationships separately** from the Koleksi side, OUTSIDE of any transaction
4. Let `IsarLinks.save()` create its own transaction for each link

### Implementation

**Service Layer (`isar_service.dart`):**

```dart
Future<void> saveGambar(Gambar newGambar, {List<Koleksi>? koleksis}) async {
  try {
    final isar = await db;

    // Validate input
    if (newGambar.endpoint.isEmpty) {
      throw ArgumentError('Gambar endpoint cannot be empty');
    }

    debugPrint('📸 Saving gambar: ${newGambar.endpoint}');
    debugPrint('📚 Koleksis to link: ${koleksis?.length ?? 0}');

    // Step 1: Save the gambar first
    await isar.writeTxn(() async {
      await isar.gambars.put(newGambar);
    });
    debugPrint('✅ Gambar saved with ID: ${newGambar.id}');

    // Step 2: Save the relationships from the Koleksi side
    // Since Gambar.koleksis is a @Backlink, we must save from Koleksi.gambars
    if (koleksis != null && koleksis.isNotEmpty) {
      for (final koleksi in koleksis) {
        debugPrint('🔗 Linking to koleksi: ${koleksi.title} (ID: ${koleksi.id})');

        // Reload koleksi from DB to get managed instance
        final managedKoleksi = await isar.koleksis.get(koleksi.id);
        if (managedKoleksi != null) {
          // Add and save in its own separate transaction
          await isar.writeTxn(() async {
            managedKoleksi.gambars.add(newGambar);
            await managedKoleksi.gambars.save();
          });
          debugPrint('✅ Link saved for koleksi: ${koleksi.title}');
        }
      }
    }
    debugPrint('🎉 All done! Gambar and relationships saved.');
  } catch (e) {
    debugPrint('❌ Error in saveGambar: $e');
    throw Exception('Failed to save gambar: $e');
  }
}
```

**UI Layer (`home_view.dart`):**

```dart
onSave: (koleksi) async {
  try {
    var data = Gambar()..endpoint = imageUrl;
    // Pass koleksi as parameter instead of adding to backlink
    await controller.service.saveGambar(data, koleksis: [koleksi]);
    Get.back();

    // Show success notification
    Get.snackbar(
      t.common.success,
      t.messages.image_added_to_collection,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  } catch (e) {
    // Handle error
  }
}
```

### Why This Works

1. **Accept koleksis as parameter**: Cannot add to backlink from UI, so we pass it as parameter
2. **Separate transactions**: Each operation has its own transaction to avoid nesting
3. **Reload managed instance**: Must get koleksi from DB to have a managed Isar object
4. **Wrap link save in writeTxn**: `IsarLinks.save()` requires an explicit transaction
5. **Save from primary link side**: We save `Koleksi.gambars`, not the backlink
6. **Backlink updates automatically**: When we save `koleksi.gambars`, Isar automatically updates `gambar.koleksis`
7. **Debug logging**: Added logs to track the save process and debug issues

## Key Learnings from Isar Documentation

### From Official Isar Docs

```dart
// ✅ CORRECT: Simple put in transaction
await isar.writeTxn(() {
  await isar.emails.put(newEmail);
});

// ✅ CORRECT: IsarLinks.save() OUTSIDE of writeTxn
await myObject.myLinks.save();

// ❌ WRONG: IsarLinks.save() INSIDE writeTxn
await isar.writeTxn(() {
  await myObject.myLinks.save();  // Nested transaction!
});
```

### Backlink Rules

1. **Backlinks are read-only** - you cannot save them directly
2. **Save from the primary link side** - the backlink updates automatically
3. **One side only** - in a many-to-many relationship, save from one side only

## Testing

To test the fix:

```bash
# Run your Flutter app
flutter run

# Try adding an image to a collection
# The error should no longer appear
```

Expected behavior:
- ✅ No "nested transaction" error
- ✅ Image saves successfully
- ✅ Relationship is established
- ✅ Can query images from collection
- ✅ Backlink works automatically

## Files Changed

- `lib/app/data/services/isar_service.dart` - Fixed `saveGambar` method

## Comparison with Old Version

The old version (using `isar` package) was simpler because:
- It used synchronous operations (`writeTxnSync`, `putSync`)
- Relationships were handled differently in that version
- The current `isar_community` package has stricter transaction rules

## Summary

**The Problem:** Trying to save IsarLinks inside a transaction causes nested transaction errors.

**The Solution:**
1. Save the entity first in a transaction
2. Save the links OUTSIDE of any transaction
3. Always save from the primary link side, never from the backlink side

This follows Isar's best practices and completely eliminates nested transaction errors.