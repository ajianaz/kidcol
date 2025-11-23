# App Theme & Design System

Sistem tema terpusat untuk konsistensi UI di seluruh aplikasi Kids Coloring Zone dengan dukungan **Light & Dark Mode**.

## 📁 File Structure

```
lib/app/
├── utils/
│   ├── app_theme.dart      # Tema utama & warna (light + dark)
│   ├── app_dialogs.dart    # Dialog & snackbar helpers
│   └── colors.dart         # Backward compatibility
└── controllers/
    └── theme_controller.dart  # Theme mode controller
```

## 🌓 Dark Mode Support

Aplikasi sekarang mendukung **Light & Dark Mode** dengan:
- ✅ Toggle di halaman Profile/Settings
- ✅ Persistent storage (mengingat pilihan user)
- ✅ Smooth transition antar mode
- ✅ Semua komponen ter-theme dengan baik


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

### 4. Menggunakan Dark Mode

```dart
import 'package:kidcol/app/controllers/theme_controller.dart';

// Get theme controller
final themeController = Get.find<ThemeController>();

// Toggle theme
themeController.toggleTheme();

// Set specific theme
themeController.setThemeMode(ThemeMode.dark);
themeController.setThemeMode(ThemeMode.light);

// Check current theme
if (themeController.isDarkMode) {
  // Dark mode is active
}

// Use in widget with Obx
Obx(() => Icon(
  themeController.isDarkMode ? Icons.dark_mode : Icons.light_mode,
))
```

**User Interface:**
- Buka halaman **Profile/Settings** dari navigation bar
- Toggle switch **Dark Mode** untuk mengubah tema
- Pilihan akan tersimpan otomatis dan diterapkan saat app dibuka kembali

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

- ✅ `lib/app/utils/app_theme.dart` - Sistem tema lengkap (light + dark)
- ✅ `lib/app/utils/app_dialogs.dart` - Dialog & snackbar helpers
- ✅ `lib/app/utils/colors.dart` - Backward compatibility
- ✅ `lib/app/controllers/theme_controller.dart` - Theme mode controller
- ✅ `lib/main.dart` - Apply theme & initialize controller
- ✅ `lib/app/modules/profile/views/profile_view.dart` - Dark mode toggle
- ✅ `lib/app/modules/home/views/home_view.dart` - Gunakan AppSnackbars
- ✅ `lib/app/modules/koleksi_gambar/views/koleksi_gambar_view.dart` - Gunakan AppDialogs
- ✅ `lib/app/modules/koleksi_gambar/controllers/koleksi_gambar_controller.dart` - Gunakan AppDialogs
- ✅ `lib/app/modules/koleksi/views/koleksi_view.dart` - Dark mode support & clean up hardcoded colors
- ✅ `lib/app/widgets/dialogs/add_koleksi.dart` - Dark mode support & use AppSnackbars

## 🎉 Result

Sekarang aplikasi memiliki:
- ✅ **Light & Dark Mode** dengan toggle di settings
- ✅ **Persistent theme** - mengingat pilihan user
- ✅ Warna yang konsisten di seluruh aplikasi (Home, Profile, Collection)
- ✅ Dialog dengan styling yang seragam
- ✅ Snackbar dengan tema yang sama
- ✅ Smooth theme transitions
- ✅ Easy to maintain & customize
- ✅ Professional & polished UI
- ✅ Better accessibility dengan dark mode
