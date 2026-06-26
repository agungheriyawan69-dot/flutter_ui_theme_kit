import 'package:flutter/material.dart';
import 'theme_provider.dart';

class AboutAppScreenBiometric extends StatelessWidget {
  final bool isDarkMode;
  const AboutAppScreenBiometric({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: BiometricTheme.theme,
      builder: (context, currentIsDark, _) {
        // FIX: Null safety untuk Colors.grey[50]
        final bgColor = currentIsDark ? const Color(0xFF0F172A) : (Colors.grey[50] ?? Colors.white);
        final textColor = currentIsDark ? Colors.white : Colors.black87;
        final subTextColor = currentIsDark ? Colors.white60 : Colors.black54;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text("Tentang Aplikasi", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            actions: [
              // FIX: TOMBOL TOGGLE DI APPBAR ACTIONS
              IconButton(
                icon: Icon(currentIsDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: subTextColor),
                onPressed: () => BiometricTheme.toggle(),
              ),
            ],
          ),
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shield_rounded, size: 80, color: Colors.cyan),
                    const SizedBox(height: 24),
                    Text("Flutter Login UI Kit", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
                    const SizedBox(height: 8),
                    Text("Versi 1.0.0", style: TextStyle(fontSize: 16, color: subTextColor)),
                    const SizedBox(height: 40),
                    Text("Dibuat oleh Kenzao\nSelf-Contained Biometric Theme", textAlign: TextAlign.center, style: TextStyle(color: subTextColor)),
                  ]
              )
          ),
        );
      },
    );
  }
}