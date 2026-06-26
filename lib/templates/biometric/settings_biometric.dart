import 'package:flutter/material.dart';
import 'abbout_app_biometric.dart';
import 'biometric_settings_biometric.dart';
import 'change_password_biometric.dart';
import 'edit_profile_biometric.dart';
import 'theme_provider.dart';

// ==========================================
// TEMPLATE: BIOMETRIC SETTINGS (DUAL MODE + LINEAR)
// AUTHOR: Kenzao
// FITUR: Toggle Tema Global, List Options, Self-Contained
// ==========================================

class SettingsScreenBiometric extends StatelessWidget {
  final bool isDarkMode;
  const SettingsScreenBiometric({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: BiometricTheme.theme,
      builder: (context, currentIsDark, _) {
        final bgColor = currentIsDark ? const Color(0xFF0F172A) : Colors.grey[50];
        final textColor = currentIsDark ? Colors.white : Colors.black87;
        final subTextColor = currentIsDark ? Colors.white60 : Colors.black54;
        final cardBg = currentIsDark ? Colors.white.withOpacity(0.05) : Colors.white;
        final borderColor = currentIsDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent, elevation: 0,
            title: Text("Pengaturan", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: Icon(currentIsDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: subTextColor),
                onPressed: () => BiometricTheme.toggle(),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tampilan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(height: 16),

                      // THEME TOGGLE CARD
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
                        child: Row(
                          children: [
                            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.cyan.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.palette_outlined, color: Colors.cyan, size: 24)),
                            const SizedBox(width: 16),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Mode Gelap", style: TextStyle(color: textColor, fontWeight: FontWeight.w600)), Text("Ubah tema aplikasi secara global", style: TextStyle(color: subTextColor, fontSize: 12))])),
                            Switch.adaptive(
                              value: currentIsDark,
                              onChanged: (_) => BiometricTheme.toggle(),
                              activeColor: Colors.cyan,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                      Text("Akun & Keamanan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(height: 16),

                      _buildSettingItem(Icons.person_outline, "Edit Profil", "Ubah nama, email, dan foto profil", textColor, subTextColor, cardBg, borderColor,
                              () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreenBiometric(isDarkMode: currentIsDark)))),

                      const SizedBox(height: 12),
                      _buildSettingItem(Icons.lock_outline, "Ganti Password", "Perbarui kata sandi akun Anda", textColor, subTextColor, cardBg, borderColor,
                              () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChangePasswordScreenBiometric(isDarkMode: currentIsDark)))),

                      const SizedBox(height: 12),
                      _buildSettingItem(Icons.fingerprint_rounded, "Biometrik", "Kelola sidik jari dan Face ID", textColor, subTextColor, cardBg, borderColor,
                              () => Navigator.push(context, MaterialPageRoute(builder: (_) => BiometricSettingsScreenBiometric(isDarkMode: currentIsDark)))),

                      _buildSettingItem(Icons.info_outline, "Tentang Aplikasi", "Versi 1.0.0 • Flutter Login UI Kit", textColor, subTextColor, cardBg, borderColor,
                              () => Navigator.push(context, MaterialPageRoute(builder: (_) => AboutAppScreenBiometric(isDarkMode: currentIsDark)))),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // METHOD PRIVATE UNTUK ITEM SETTING (LINEAR STRUCTURE)

  Widget _buildSettingItem(IconData icon, String title, String subtitle, Color textColor, Color subTextColor, Color bg, Color border, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: border)),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.cyan.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: Colors.cyan, size: 22)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.w600)), Text(subtitle, style: TextStyle(color: subTextColor, fontSize: 12))])),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}