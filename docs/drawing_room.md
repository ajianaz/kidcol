# Drawing Room Feature

## Overview
Fitur Drawing Room memungkinkan pengguna untuk mewarnai gambar yang dipilih dari koleksi mereka.

## Key Features

### 1. Restricted Drawing Area
- Area mewarnai secara otomatis dibatasi sesuai dengan ukuran dan aspek rasio gambar yang sedang diwarnai.
- Menggunakan teknik `Stack` dengan `Image` sebagai anchor dan `Positioned.fill` untuk `CustomPaint`.

### 2. Zoom & Pan Support
- Menggunakan `InteractiveViewer` untuk memungkinkan pengguna memperbesar (zoom) dan menggeser (pan) gambar.
- **Cara Penggunaan**:
  - **Satu Jari**: Untuk menggambar/mewarnai.
  - **Dua Jari**: Untuk zoom in/out dan menggeser gambar (pan).

### 3. Rich Color Palette
- Menyediakan berbagai pilihan warna (18+ warna) termasuk warna-warna cerah dan warna dasar.
- UI Palette yang modern dengan indikator seleksi yang jelas.

### 4. Adjustable Brush Size
- Slider untuk mengatur ketebalan kuas/pensil.
- Terletak di sisi kanan layar untuk akses mudah.

## Technical Implementation

- **View**: `lib/app/modules/drawing_room/views/drawing_room_view.dart`
- **Controller**: `lib/app/modules/drawing_room/controllers/drawing_room_controller.dart`
- **Painter**: `lib/app/utils/drawing_painter.dart`

### Dependencies
- `dio`: Untuk download gambar.
- `get`: State management.

