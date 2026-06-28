
```markdown
# 🌌 Neon Cyberpunk Theme Kit

Tema dashboard futuristik bergaya Cyberpunk/Sci-Fi dengan performa tinggi, navigasi lengkap, dan sistem partikel interaktif berbasis **GPU Raymarching Shader**. Dirancang khusus untuk Flutter Web & Mobile dengan pendekatan "Zero-Dependency Visuals".

## ✨ Fitur Utama

-   **GPU-Accelerated Particles**: Efek meteor/partikel cursor menggunakan **Custom GLSL Fragment Shader** (`neon_liquid.frag`) dengan teknik *Space Folding* & *Raymarching*. Bukan animasi CPU biasa, melainkan rendering matematis real-time di GPU.
-   **Full Navigation Suite**: Dashboard, Profile, Settings, dan Analytics screen dengan routing yang saling terhubung sempurna via `pushReplacement`.
-   **Adaptive Theming**: Toggle Dark/Light mode instan dengan palet warna adaptif (Cyan/Gold untuk Dark, Red/Navy untuk Light).
-   **Loading Transitions**: Efek "System Initializing" dinamis setiap kali ganti menu atau logout.
-   **Native Custom Painters**: Grafik Network Traffic, Circular Gauges, dan Sparkline Charts dibuat native tanpa library chart berat.
-   **Self-Contained Files**: Setiap screen menyertakan widget pendukungnya sendiri, siap dipindah ke project lain tanpa error missing class.

## 📦 Dependencies Eksternal

Tema ini **ULTRA-MINIMAL DEPENDENCY**. Hampir semua visual dibuat native menggunakan Flutter SDK + GLSL Shader. Berikut dependency yang digunakan:

| Package | Versi | Fungsi | Catatan Penting |
| :--- | :--- | :--- | :--- |
| `flutter` | >=3.19.0 | Core Framework + Shaders | Wajib support Null Safety & Runtime Effects |
| `cupertino_icons` | ^1.0.8 | Icon Font | Bawaan Flutter |

> ⚠️ **CATATAN PENTING:**  
> - Semua efek visual (partikel, gauge, chart) dibuat menggunakan **CustomPainter native & GLSL Shaders**.  
> - **TIDAK ADA** dependency chart library seperti `fl_chart`, `syncfusion`, atau particle engine seperti `particles_flutter`.  
> - Shader dikompilasi langsung oleh Flutter Engine (`flutter/runtime_effect.glsl`), memastikan performa maksimal dan bundle size tetap kecil.

## 🗂️ Struktur File

```text
neon_cyberpunk/
├── analytics_neon_cyber.dart    # Screen monitoring jaringan & threat logs
├── dashboard_neon_cyber.dart    # Screen utama dengan stat cards & tabel
├── login_neon_cyber.dart        # Halaman autentikasi
├── profile_neon_cyber.dart      # Kartu identitas user & status keamanan
├── register_neon_cyber.dart     # Form registrasi dengan validasi real-time
├── settings_neon_cyber.dart     # Pengaturan profil, password & 2FA
├── theme_provider.dart          # ValueListenable untuk toggle tema
└── README.md                    # Dokumentasi ini

shaders/
└── neon_liquid.frag             # GLSL Raymarching Shader untuk partikel meteor
```

## 🚀 Cara Integrasi ke Project Lain

1.  **Copy Folder**: Salin folder `neon_cyberpunk` DAN folder `shaders` ke dalam project kamu.
2.  **Update pubspec.yaml**: Pastikan bagian shaders terdaftar agar bisa dikompilasi:
    ```yaml
    flutter:
      shaders:
        - shaders/neon_liquid.frag
    ```
3.  **Setup Theme Provider**: Wrap `MaterialApp` dengan `ValueListenableBuilder` atau gunakan `NeonCyberpunkTheme.theme` sesuai implementasi di `theme_provider.dart`.
4.  **Import Screen**: Panggil screen yang diinginkan, contoh:
    ```dart
    import 'package:flutter_ui_theme_kit/templates/neon_cyberpunk/dashboard_neon_cyber.dart';
    
    // Di dalam Widget tree
    const DashboardNeonCyber(),
    ```

## ⚡ Optimasi Performa (Technical Notes)

Bagi developer yang ingin mempelajari arsitektur performanya:

-   **GPU Raymarching**: Partikel tidak dihitung per-frame di CPU/Dart. Perhitungan posisi, rotasi, dan glow dilakukan sepenuhnya di GPU via fragment shader. Ini membebaskan main thread Flutter dari beban animasi.
-   **Space Folding Technique**: Menggunakan `fract()` dan `floor()` di shader untuk mereplikasi ribuan objek meteor tanpa loop array yang berat. Hanya 1 SDF (Signed Distance Function) yang dievaluasi berulang kali di ruang terlipat.
-   **Early Exit Optimization**: Loop raymarching memiliki kondisi `if(t > 20.0 || col.r > 2.0) break;` untuk menghentikan perhitungan pixel yang sudah jenuh atau terlalu jauh, menjaga FPS tetap stabil.
-   **Static Chart Painting**: `SparklinePainter` menggunakan `shouldRepaint: false` karena datanya statis. Hanya digambar sekali saat widget mount.
-   **Isolasi Render Loop**: UI updates (navigasi, toggle tema) tidak mengganggu render loop shader. Keduanya berjalan di pipeline terpisah.

## 🎨 Palet Warna

### Dark Mode
-   Primary Neon: `#00F3FF` (Cyan)
-   Secondary Neon: `#FFD700` (Gold)
-   Background: `#050505` (Deep Black)
-   Surface: `#0B0E14` (Dark Blue-Grey)

### Light Mode
-   Primary Accent: `#8B0000` (Dark Red)
-   Secondary Accent: `#1A1A1A` (Charcoal)
-   Background: `#F0F2F5` (Light Grey)
-   Surface: `#E8EAED` (White-Grey)

## 📝 Lisensi & Kontribusi

Kode ini bersifat open-source untuk tujuan edukasi dan portofolio. Silakan modifikasi dan gunakan dalam project pribadi maupun komersial. Jika menemukan bug atau punya ide optimasi shader, silakan fork dan submit PR!

---
*Dibuat dengan ❤️, GLSL, dan banyak kopi oleh Kenzao*
```
