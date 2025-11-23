# App Theme & Design System

Sistem tema terpusat untuk konsistensi UI di seluruh aplikasi Kids Coloring Zone.

## 📁 File Structure

```
lib/app/utils/
├── app_theme.dart      # Tema utama & warna
├── app_dialogs.dart    # Dialog & snackbar helpers
└── colors.dart         # Backward compatibility
```

## 🎨 Color Palette

### Primary Colors
- **Primary**: `#546de5` (Cornflower Blue) - Warna utama aplikasi
- **Secondary**: `#3dc1d3` (Blue Curacao) - Warna sekunder
- **Accent**: `#ff6b81` (Pastel Red) - Warna aksen

### Semantic Colors
- **Success**: `#26de81` (Green)
- **Warning**: `#feca57` (Yellow)
- **Error**: `#ff6348` (Red)
- **Info**: `#4bcffa` (Light Blue)

### Neutral Colors
- Grey scale dari 50-900
- Text colors (primary, secondary, tertiary)
- Border & shadow colors

## 🚀 Usage

### 1. Menggunakan Warna

```dart
import 'package:kidcol/app/utils/app_theme.dart';

// Gunakan AppColors
Container(
  color: AppColors.primary,
  child: Text(
    'Hello',
    style: TextStyle(color: AppColors.textOnPrimary),
  ),
)

// Gradient
Container(
  decoration: BoxDecoration(
    gradient: AppColors.primaryGradient,
  ),
)
```

### 2. Menggunakan Dialog

```dart
import 'package:kidcol/app/utils/app_dialogs.dart';

// Success Dialog
AppDialogs.showSuccess(
  title: 'Success',
  message: 'Operation completed successfully',
);

// Error Dialog
AppDialogs.showError(
  title: 'Error',
  message: 'Something went wrong',
);

// Confirmation Dialog
AppDialogs.showConfirmation(
  title: 'Confirm Action',
  message: 'Are you sure?',
  icon: Icons.warning,
  onConfirm: () {
    // Do something
  },
);

// Delete Confirmation with Preview
AppDialogs.showDeleteConfirmation(
  title: 'Delete Image',
  message: 'This action cannot be undone',
  preview: Image.network('...'),
  onConfirm: () {
    // Delete action
  },
);
```

### 3. Menggunakan Snackbar

```dart
import 'package:kidcol/app/utils/app_dialogs.dart';

// Success Snackbar
AppSnackbars.showSuccess('Image saved successfully');

// Error Snackbar
AppSnackbars.showError('Failed to save image');

// Info Snackbar
AppSnackbars.showInfo('Processing...');

// Warning Snackbar
AppSnackbars.showWarning('Low storage space');
```

## 🎯 Theme Configuration

Theme sudah diterapkan di `main.dart`:

```dart
GetMaterialApp(
  theme: AppTheme.lightTheme,
  // ...
)
```

## 📝 Component Theming

Semua komponen Material sudah di-theme secara otomatis:

- **AppBar**: White background, centered title
- **ElevatedButton**: Primary color, rounded corners
- **TextButton**: Primary text color
- **Card**: Elevated with shadow
- **Dialog**: Rounded corners, consistent padding
- **BottomSheet**: Rounded top corners
- **Snackbar**: Floating with rounded corners
- **TextField**: Filled style with border

## 🔄 Migration dari Kode Lama

Kode lama masih kompatibel:

```dart
// Old (masih berfungsi tapi deprecated)
const cornFlower = Color(0xff546de5);
const blueCuracao = Color(0xff3dc1d3);

// New (recommended)
AppColors.primary
AppColors.secondary
```

## ✨ Benefits

1. **Konsistensi**: Semua UI menggunakan warna yang sama
2. **Maintainability**: Ubah warna di satu tempat, apply ke semua
3. **Accessibility**: Kontras warna yang baik
4. **Scalability**: Mudah menambah warna baru
5. **Type Safety**: Compile-time checking

## 🎨 Customization

Untuk mengubah warna aplikasi, edit `AppColors` di `app_theme.dart`:

```dart
class AppColors {
  static const Color primary = Color(0xff546de5); // Ubah di sini
  // ...
}
```

## 📚 Best Practices

1. **Selalu gunakan `AppColors`** instead of hardcoded colors
2. **Gunakan helper dialogs** (`AppDialogs`, `AppSnackbars`) untuk konsistensi
3. **Ikuti Material Design 3** guidelines
4. **Test dengan berbagai ukuran layar** (mobile, tablet, desktop)
5. **Pastikan kontras warna** untuk accessibility

## 🔧 Files Changed

- ✅ `lib/app/utils/app_theme.dart` - Sistem tema lengkap
- ✅ `lib/app/utils/app_dialogs.dart` - Dialog & snackbar helpers
- ✅ `lib/app/utils/colors.dart` - Backward compatibility
- ✅ `lib/main.dart` - Apply theme
- ✅ `lib/app/modules/home/views/home_view.dart` - Gunakan AppSnackbars
- ✅ `lib/app/modules/koleksi_gambar/views/koleksi_gambar_view.dart` - Gunakan AppDialogs

## 🎉 Result

Sekarang aplikasi memiliki:
- ✅ Warna yang konsisten di seluruh aplikasi
- ✅ Dialog dengan styling yang seragam
- ✅ Snackbar dengan tema yang sama
- ✅ Easy to maintain & customize
- ✅ Professional & polished UI
