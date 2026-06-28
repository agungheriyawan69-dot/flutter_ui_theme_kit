import 'package:flutter/material.dart';
import 'package:flutter_ui_theme_kit/templates/biometric/register_biometric.dart';
import 'dart:async';
import 'dashboard_biometric.dart';
import 'theme_provider.dart';

// ==========================================
// TEMPLATE: BIOMETRIC LOGIN (REAL-TIME MODE TOGGLE)
// AUTHOR: Kenzao
// FITUR: ValueListenable Rebuild, Linear Structure, Self-Contained
// ==========================================

class LoginScreenBiometric extends StatefulWidget {
  final bool isDarkMode;
  const LoginScreenBiometric({super.key, required this.isDarkMode});

  @override
  State<LoginScreenBiometric> createState() => _LoginScreenBiometricState();
}

class _LoginScreenBiometricState extends State<LoginScreenBiometric> with SingleTickerProviderStateMixin {
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;
  bool _isScanning = false;
  bool _showManualLogin = false;
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _scanController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _scanController.dispose();
    _isPasswordVisible.dispose();
    super.dispose();
  }

  void _startScan() {
    setState(() => _isScanning = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardBiometric(isDarkMode: BiometricTheme.isDark)));
    });
  }

  @override
  Widget build(BuildContext context) {
    // DENGARKAN PERUBAHAN TEMA SECARA REAL-TIME
    return ValueListenableBuilder<bool>(
      valueListenable: BiometricTheme.theme,
      builder: (context, currentIsDark, _) {
        final bgColor = currentIsDark ? const Color(0xFF0F172A) : Colors.white;
        final textColor = currentIsDark ? Colors.white : Colors.black87;
        final subTextColor = currentIsDark ? Colors.white60 : Colors.black54;
        final inputBg = currentIsDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100;
        final dividerColor = currentIsDark ? Colors.white24 : Colors.black12;

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(currentIsDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: subTextColor),
                onPressed: () => BiometricTheme.toggle(),
              ),
            ],
          ),
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Text("Verifikasi Identitas", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(height: 8),
                      Text("Sentuh sensor sidik jari untuk masuk", style: TextStyle(fontSize: 14, color: subTextColor)),
                      const SizedBox(height: 60),

                      GestureDetector(
                        onTap: _startScan,
                        child: AnimatedBuilder(
                          animation: _scanAnimation,
                          builder: (context, child) {
                            return Stack(alignment: Alignment.center, children: [
                              Container(
                                width: 160 + (_scanAnimation.value * 20), height: 160 + (_scanAnimation.value * 20),
                                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.cyan.withValues(alpha: 0.3 - (_scanAnimation.value * 0.2)), width: 2)),
                              ),
                              Icon(Icons.fingerprint_rounded, size: 100, color: _isScanning ? Colors.cyan : (currentIsDark ? Colors.white70 : Colors.black54)),
                              Positioned(top: 40 + (_scanAnimation.value * 60), child: Container(width: 80, height: 2, color: Colors.cyan.withValues(alpha: 0.8))),
                            ]);
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(_isScanning ? "Memindai..." : "Ketuk untuk memindai", style: TextStyle(fontSize: 14, color: _isScanning ? Colors.cyan : subTextColor, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 60),

                      Row(children: [Expanded(child: Divider(color: dividerColor)), Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Text("ATAU", style: TextStyle(color: subTextColor, fontSize: 12))), Expanded(child: Divider(color: dividerColor))]),
                      const SizedBox(height: 32),

                      OutlinedButton.icon(
                        onPressed: () => setState(() => _showManualLogin = !_showManualLogin),
                        icon: const Icon(Icons.password_rounded, color: Colors.cyan),
                        label: const Text("Masuk dengan Password", style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.cyan, width: 1.5), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), minimumSize: const Size(double.infinity, 50)),
                      ),

                      if (_showManualLogin) ...[
                        const SizedBox(height: 24),
                        TextField(decoration: InputDecoration(hintText: "Username", hintStyle: TextStyle(color: subTextColor), filled: true, fillColor: inputBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), prefixIcon: Icon(Icons.person_outline, color: subTextColor)), style: TextStyle(color: textColor), cursorColor: Colors.cyan),
                        const SizedBox(height: 16),
                        ValueListenableBuilder<bool>(valueListenable: _isPasswordVisible, builder: (context, isVisible, _) {
                          return TextField(obscureText: !isVisible, decoration: InputDecoration(hintText: "Password", hintStyle: TextStyle(color: subTextColor), filled: true, fillColor: inputBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), prefixIcon: Icon(Icons.lock_outline, color: subTextColor), suffixIcon: IconButton(icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: subTextColor), onPressed: () => _isPasswordVisible.value = !isVisible)), style: TextStyle(color: textColor), cursorColor: Colors.cyan);
                        }),
                        const SizedBox(height: 12),
                        const Text('💡 Tip: Field ini bisa diubah menjadi Email, No. HP,\natau PIN sesuai kebutuhan project Anda.', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
                        const SizedBox(height: 24),
                        ElevatedButton(onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardBiometric(isDarkMode: BiometricTheme.isDark))), style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), minimumSize: const Size(double.infinity, 50)), child: const Text("MASUK", style: TextStyle(fontWeight: FontWeight.bold))),
                      ],

                      const SizedBox(height: 40),
                      Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: inputBg, borderRadius: BorderRadius.circular(8)), child: RichText(textAlign: TextAlign.center, text: TextSpan(style: TextStyle(color: subTextColor, fontSize: 12, height: 1.5), children: [const TextSpan(text: "Akses Demo:\n"), TextSpan(text: "User: admin | Pass: admin", style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold))]))),
                      // ... (di dalam Column body, setelah Container Demo Credentials) ...

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Belum punya akun? ", style: TextStyle(color: subTextColor)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => RegisterScreenBiometric(isDarkMode: currentIsDark))
                              );
                            },
                            child: Text(
                              "Daftar Akun",
                              style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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
}