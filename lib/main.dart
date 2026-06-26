import 'package:flutter/material.dart';
import 'templates/biometric/theme_provider.dart';
import 'templates/biometric/login_biometric.dart';

void main() => runApp(const LoginUIKitApp());

class LoginUIKitApp extends StatelessWidget {
  const LoginUIKitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login UI Kit by Kenzao',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF0B1120)),
      home: ShowcaseMenuScreen(),
    );
  }
}

class ShowcaseMenuScreen extends StatelessWidget {
   ShowcaseMenuScreen({super.key});

  // FIX: Hapus 'const' di depan List karena berisi closure/fungsi
  final List<Map<String, dynamic>> _templates = [
    {
      'name': 'Biometric Fingerprint',
      'desc': 'Real-time dual mode, responsive grid',
      'color': Colors.cyan,
      // Closure tidak bisa const
      'screen': (bool isDark) => LoginScreenBiometric(isDarkMode: isDark),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: BiometricTheme.theme,
      builder: (context, isDark, _) {
        final bgColor = isDark ? const Color(0xFF0B1120) : Colors.grey[50];
        final textColor = isDark ? Colors.white : Colors.black87;
        final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

        return Scaffold(
          appBar: AppBar(
            title: const Text('🎨 Flutter Login UI Kit'),
            centerTitle: true,
            elevation: 0,
            backgroundColor: bgColor,
            foregroundColor: textColor,
            actions: [
              IconButton(
                icon: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded),
                onPressed: () => BiometricTheme.toggle(),
              ),
            ],
          ),
          body: Container(
            color: bgColor,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: ListView.separated(
                itemCount: _templates.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final t = _templates[index];
                  final Color accent = t['color'] as Color;
                  final cardBg = isDark ? Colors.grey[900] : Colors.white;

                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => (t['screen'] as Widget Function(bool))(isDark),
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
      },
    );
  }
}