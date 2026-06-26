import 'package:flutter/material.dart';
import 'theme_provider.dart';

class ChangePasswordScreenBiometric extends StatelessWidget {
  final bool isDarkMode;
  const ChangePasswordScreenBiometric({super.key, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: BiometricTheme.theme,
      builder: (context, currentIsDark, _) {
        // FIX: Null safety untuk Colors.grey[50]
        final bgColor = currentIsDark ? const Color(0xFF0F172A) : (Colors.grey[50] ?? Colors.white);
        final textColor = currentIsDark ? Colors.white : Colors.black87;
        final subTextColor = currentIsDark ? Colors.white60 : Colors.black54;
        final inputBg = currentIsDark ? Colors.white.withOpacity(0.05) : Colors.white;
        final borderColor = currentIsDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05);

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text("Ganti Password", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            actions: [
              // FIX: TOMBOL TOGGLE DI APPBAR ACTIONS
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
                                TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        labelText: "Password Lama",
                                        labelStyle: TextStyle(color: subTextColor),
                                        filled: true,
                                        fillColor: inputBg,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor))
                                    ),
                                    style: TextStyle(color: textColor)
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        labelText: "Password Baru",
                                        labelStyle: TextStyle(color: subTextColor),
                                        filled: true,
                                        fillColor: inputBg,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor))
                                    ),
                                    style: TextStyle(color: textColor)
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        labelText: "Konfirmasi Password Baru",
                                        labelStyle: TextStyle(color: subTextColor),
                                        filled: true,
                                        fillColor: inputBg,
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: borderColor))
                                    ),
                                    style: TextStyle(color: textColor)
                                ),
                                const SizedBox(height: 32),
                                ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.cyan,
                                        foregroundColor: Colors.black,
                                        minimumSize: const Size(double.infinity, 50),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                                    ),
                                    child: const Text("UPDATE PASSWORD", style: TextStyle(fontWeight: FontWeight.bold))
                                ),
                              ]
                          )
                      )
                  )
              )
          ),
        );
      },
    );
  }
}