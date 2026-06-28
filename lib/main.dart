import 'package:flutter/material.dart';

// Import Tema Biometric
import 'templates/biometric/theme_provider.dart' as biometric;
import 'templates/biometric/login_biometric.dart';

// Import Tema Neon Cyberpunk
import 'templates/neon_cyberpunk/theme_provider.dart' as neon;
import 'templates/neon_cyberpunk/login_neon_cyber.dart';

void main() => runApp(const LoginUIKitApp());

class LoginUIKitApp extends StatelessWidget {
  const LoginUIKitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI Kit by Kenzao',
      debugShowCheckedModeBanner: false,
      // Default theme fallback
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF0B1120)),
      home: const ShowcaseMenuScreen(),
    );
  }
}

class ShowcaseMenuScreen extends StatefulWidget {
  const ShowcaseMenuScreen({super.key});

  @override
  State<ShowcaseMenuScreen> createState() => _ShowcaseMenuScreenState();
}

class _ShowcaseMenuScreenState extends State<ShowcaseMenuScreen> {
  // STATE GLOBAL UNTUK MENU SHOWCASE
  bool _isDarkMode = true;

  // DAFTAR TEMPLATE YANG BISA DITAMBAH TANPA BATAS
  final List<Map<String, dynamic>> _templates = [
    {
      'name': 'Biometric Fingerprint',
      'desc': '3-step enrollment, responsive grid, linear structure',
      'color': Colors.cyan,
      'screen': (bool isDark) => LoginScreenBiometric(isDarkMode: isDark),
    },
    // CARI BAGIAN INI DI DALAM LIST _templates:
    {
      'name': 'Neon Cyberpunk',
      'desc': 'Animated snake border, adaptive dark/light neon palette',
      'color': const Color(0xFF00F3FF),
      'screen': (bool isDark) => const LoginNeonCyber(),
    },
  ];

  void _toggleGlobalTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
    // Sinkronkan state ke semua provider tema
    biometric.BiometricTheme.theme.value = _isDarkMode;
    neon.NeonCyberpunkTheme.theme.value = _isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎨 Flutter Login UI Kit'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: _isDarkMode ? const Color(0xFF0B1120) : Colors.white,
        foregroundColor: _isDarkMode ? Colors.white : Colors.black87,
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
            onPressed: _toggleGlobalTheme,
          ),
        ],
      ),
      body: Container(
        color: _isDarkMode ? const Color(0xFF0B1120) : Colors.grey[50],
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView.separated(
            itemCount: _templates.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final t = _templates[index];
              final Color accent = t['color'] as Color;
              final cardBg = _isDarkMode ? Colors.grey[900] : Colors.white;
              final textColor = _isDarkMode ? Colors.white : Colors.black87;
              final subTextColor = _isDarkMode ? Colors.grey[400] : Colors.grey[600];

              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => (t['screen'] as Widget Function(bool))(_isDarkMode),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: accent.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(width: 8, height: 40, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(4))),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t['name'] as String, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                            const SizedBox(height: 4),
                            Text(t['desc'] as String, style: TextStyle(fontSize: 12, color: subTextColor)),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: accent),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}