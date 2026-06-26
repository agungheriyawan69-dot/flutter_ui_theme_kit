import 'package:flutter/material.dart';
import 'edit_profile_biometric.dart';
import 'theme_provider.dart';

class ViewProfileScreenBiometric extends StatelessWidget {
  final bool isDarkMode;
  const ViewProfileScreenBiometric({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: BiometricTheme.theme,
      builder: (context, currentIsDark, _) {
        final bgColor = currentIsDark ? const Color(0xFF0F172A) : (Colors.grey[50] ?? Colors.white);
        final textColor = currentIsDark ? Colors.white : Colors.black87;
        final subTextColor = currentIsDark ? Colors.white60 : Colors.black54;
        final cardBg = currentIsDark ? Colors.white.withOpacity(0.05) : Colors.white;
        final borderColor = currentIsDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text("Profil Saya", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            actions: [
              // TOMBOL TOGGLE TEMA DI APPBAR PROFIL
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
                    children: [
                      const SizedBox(height: 20),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.cyan.withOpacity(0.1),
                            child: Icon(Icons.person, size: 60, color: Colors.cyan),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: bgColor, width: 3)),
                            child: const Icon(Icons.check, color: Colors.white, size: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text("Admin User", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(height: 4),
                      Text("admin@biometric.id", style: TextStyle(fontSize: 16, color: subTextColor)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(color: Colors.cyan.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                        child: const Text("Administrator", style: TextStyle(color: Colors.cyan, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow("Status Akun", "Aktif & Terverifikasi", Icons.check_circle_outline, Colors.green, subTextColor),
                            const Divider(height: 24, color: Colors.grey),
                            _buildInfoRow("Metode Login", "Sidik Jari (Biometrik)", Icons.fingerprint_rounded, Colors.cyan, subTextColor),
                            const Divider(height: 24, color: Colors.grey),
                            _buildInfoRow("Terakhir Login", "Hari ini, 16:59 WIB", Icons.access_time_rounded, subTextColor, subTextColor),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfileScreenBiometric(isDarkMode: currentIsDark))),
                          icon: const Icon(Icons.edit_rounded),
                          label: const Text("EDIT PROFIL", style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan, foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
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

  Widget _buildInfoRow(String label, String value, IconData icon, Color iconColor, Color subTextColor) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 12, color: subTextColor)),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: iconColor)),
        ])),
      ],
    );
  }
}