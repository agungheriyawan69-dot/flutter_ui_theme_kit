# 🔐 Biometric Fingerprint Theme

Tema login & dashboard berbasis keamanan sidik jari dengan flow enrollment 3-tahap (Verifikasi Lama → Enroll Baru → Validasi Baru). Mendukung Dark/Light Mode real-time via global state.

## 📂 Struktur File
- `theme_provider.dart` - Global state manager (ValueNotifier) untuk Dark/Light mode
- `login_biometric.dart` - Login screen dengan animasi scan fingerprint + fallback password
- `register_biometric.dart` - Registration flow: Scan Enrollment → Form Data Akun
- `dashboard_biometric.dart` - Dashboard responsive (2/3 kolom) + Profile Card + Activity List
- `view_profile_biometric.dart` - Halaman profil lengkap (foto, status, metode login)
- `edit_profile_biometric.dart` - Form edit nama & email
- `change_password_biometric.dart` - Form ganti password (lama/baru/konfirmasi)
- `biometric_settings_biometric.dart` - Manajemen sidik jari (list terdaftar, enroll baru 3-step, hapus data)
- `about_app_biometric.dart` - Halaman tentang aplikasi

## 🚀 Cara Pakai
1. Copy seluruh isi folder `biometric/` ke project Flutter kamu
2. Pastikan tidak ada dependensi eksternal (pure Flutter SDK)
3. Jalankan dari entry point manapun:
   ```dart
   import 'templates/biometric/login_biometric.dart';
   
   void main() => runApp(
     MaterialApp(home: LoginScreenBiometric(isDarkMode: true))
   );
\

⚙️ Fitur Utama

    3-Step Biometric Enrollment: Verifikasi jari lama → Rekam jari baru → Validasi ulang (sama seperti ganti password)
    Real-time Theme Toggle: Tekan ikon ☀️/ di AppBar manapun, semua screen langsung berubah tanpa restart
    Responsive Grid: Dashboard otomatis 3 kolom di desktop, 2 kolom di mobile
    Max Width Constraint: Konten tidak pernah melebar tak terkendali di layar besar (max 800px)
    Linear Widget Tree: Semua UI dipecah jadi method private (_build...), tidak ada nesting berlebihan

🔑 Demo Credential

    Username: admin
    Password: admin

🎨 Customization

    Warna accent: Cari Colors.cyan di setiap file, ganti sesuai brand
    Background gelap: Color(0xFF0F172A) 
    Background terang: Colors.grey[50]
    Max width konten: Ubah BoxConstraints(maxWidth: 800) di dashboard

⚠️ Catatan Penting

    Jangan hapus theme_provider.dart — ini jantung dari sistem theme global
    Flow enroll biometrik HARUS 3 step, jangan dipotong jadi 2 step demi keamanan UX
    Semua navigasi pakai Navigator.push kecuali logout (pakai pushAndRemoveUntil)



File ini sudah mencakup:
- ✅ Struktur file lengkap
- ✅ Cara pakai copy-paste friendly
- ✅ Penjelasan fitur utama termasuk 3-step enrollment
- ✅ Demo credential
- ✅ Panduan customization warna & layout
- ✅ Peringatan penting soal arsitektur
