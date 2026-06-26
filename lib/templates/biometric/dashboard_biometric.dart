import 'package:flutter/material.dart';
import 'login_biometric.dart';
import 'settings_biometric.dart';
import 'view_profile_biometric.dart';
import 'theme_provider.dart';

class DashboardBiometric extends StatelessWidget {
  final bool isDarkMode;
  const DashboardBiometric({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: BiometricTheme.theme,
      builder: (context, currentIsDark, _) {
        // FIX: Null safety untuk Colors.grey[50]
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
            title: Text("Dashboard", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                icon: Icon(currentIsDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: subTextColor),
                onPressed: () => BiometricTheme.toggle(),
              ),
              IconButton(icon: Icon(Icons.analytics_outlined, color: subTextColor), onPressed: () {}),
              // FIX: Navigator.push membutuhkan 2 argumen: context dan route
              IconButton(
                icon: Icon(Icons.person_outline, color: subTextColor),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ViewProfileScreenBiometric(isDarkMode: currentIsDark))
                ),
              ),
              IconButton(
                icon: Icon(Icons.settings_outlined, color: subTextColor),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SettingsScreenBiometric(isDarkMode: currentIsDark))
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeHeader(textColor, subTextColor),
                      const SizedBox(height: 32),
                      _buildResponsiveStatsGrid(context, cardBg, borderColor, textColor, subTextColor, currentIsDark),
                      const SizedBox(height: 32),
                      Text("Aktivitas Terakhir", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(height: 16),
                      _buildActivityList(cardBg, borderColor, textColor, subTextColor),
                      const SizedBox(height: 32),
                      _buildLogoutButton(context, currentIsDark),
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

  // --- PRIVATE METHODS (LINEAR STRUCTURE) ---

  Widget _buildWelcomeHeader(Color textColor, Color subTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Selamat Datang,", style: TextStyle(fontSize: 16, color: subTextColor)),
        Text("Admin User", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green.withOpacity(0.3)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shield_rounded, color: Colors.green, size: 16),
              SizedBox(width: 6),
              Text("Sistem Aman", style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResponsiveStatsGrid(BuildContext context, Color cardBg, Color borderColor, Color textColor, Color subTextColor, bool currentIsDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        double aspectRatio = constraints.maxWidth > 600 ? 1.4 : 1.8;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: aspectRatio,
          children: [
            _buildProfileCard(context, cardBg, borderColor, textColor, subTextColor, currentIsDark),
            _buildStatCard("Total Pengguna", "12.4k", Icons.people_outline, Colors.cyan, cardBg, borderColor, textColor, subTextColor),
            _buildStatCard("Pendapatan", "\$48.2k", Icons.attach_money_outlined, Colors.green, cardBg, borderColor, textColor, subTextColor),
            _buildStatCard("Pesanan Baru", "1,842", Icons.shopping_bag_outlined, Colors.orange, cardBg, borderColor, textColor, subTextColor),
            _buildStatCard("Keamanan", "99.9%", Icons.lock_outline, Colors.purple, cardBg, borderColor, textColor, subTextColor),
          ],
        );
      },
    );
  }

  Widget _buildProfileCard(BuildContext context, Color bg, Color border, Color text, Color subText, bool currentIsDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 20, backgroundColor: Colors.cyan.withOpacity(0.1), child: Icon(Icons.person, color: Colors.cyan, size: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Admin User", style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 14)),
                    Text("admin@biometric.id", style: TextStyle(color: subText, fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ViewProfileScreenBiometric(isDarkMode: currentIsDark)),
              );
            },
            child: const Text("Lihat Profil >", style: TextStyle(color: Colors.cyan, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color accent, Color bg, Color border, Color text, Color subText) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: accent, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: text)),
              Text(label, style: TextStyle(fontSize: 12, color: subText)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList(Color cardBg, Color borderColor, Color textColor, Color subTextColor) {
    final activities = [
      {'title': 'Login Berhasil', 'time': '2 menit lalu', 'icon': Icons.login, 'color': Colors.green},
      {'title': 'Update Profil', 'time': '1 jam lalu', 'icon': Icons.edit, 'color': Colors.blue},
      {'title': 'Verifikasi 2FA', 'time': '3 jam lalu', 'icon': Icons.security, 'color': Colors.orange},
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = activities[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: (item['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title'] as String, style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                    Text(item['time'] as String, style: TextStyle(color: subTextColor, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context, bool currentIsDark) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => LoginScreenBiometric(isDarkMode: currentIsDark)),
              (route) => false,
        ),
        icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
        label: const Text("Keluar dari Akun", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.redAccent),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}