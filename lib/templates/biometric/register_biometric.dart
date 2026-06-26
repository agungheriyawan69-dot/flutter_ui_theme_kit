import 'package:flutter/material.dart';
import 'dashboard_biometric.dart';
import 'theme_provider.dart';

// ==========================================
// TEMPLATE: BIOMETRIC REGISTER (3-STEP ENROLLMENT)
// AUTHOR: Kenzao
// FITUR: Enroll -> Validate -> Form, No Skip, Dual Mode
// ==========================================

class RegisterScreenBiometric extends StatefulWidget {
  final bool isDarkMode;
  const RegisterScreenBiometric({super.key, required this.isDarkMode});

  @override
  State<RegisterScreenBiometric> createState() => _RegisterScreenBiometricState();
}

class _RegisterScreenBiometricState extends State<RegisterScreenBiometric> with SingleTickerProviderStateMixin {
  // STATE MACHINE: 0=Enroll, 1=Validate, 2=Form
  int _currentStep = 0;
  double _scanProgress = 0.0;
  bool _isScanning = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier<bool>(false);
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _isPasswordVisible.dispose();
    super.dispose();
  }

  // LOGIKA SCAN OTOMATIS LANJUT KE STEP BERIKUTNYA
  void _startScanProcess() {
    if (_isScanning) return;
    setState(() {
      _isScanning = true;
      _scanProgress = 0.0;
    });

    int step = 0;
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return false;

      step++;
      setState(() => _scanProgress = step / 4);

      if (step >= 4) {
        setState(() {
          _isScanning = false;
          _currentStep++; // LANGSUNG LANJUT KE STEP BERIKUTNYA (Enroll->Validate->Form)
          _scanProgress = 0.0;
        });
        return false;
      }
      return true;
    });
  }

  void _handleRegister(BuildContext context, bool currentIsDark) {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => DashboardBiometric(isDarkMode: currentIsDark)),
            (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: BiometricTheme.theme,
      builder: (context, currentIsDark, _) {
        final bgColor = currentIsDark ? const Color(0xFF0F172A) : Colors.white;
        final textColor = currentIsDark ? Colors.white : Colors.black87;
        final subTextColor = currentIsDark ? Colors.white60 : Colors.black54;
        final inputBg = currentIsDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey.shade100;

        // Judul & Deskripsi Dinamis
        String title = _currentStep == 0 ? "Daftar Sidik Jari" : (_currentStep == 1 ? "Validasi Sidik Jari" : "Lengkapi Data");
        String desc = _currentStep == 0
            ? "Sentuh sensor untuk merekam sidik jari baru"
            : (_currentStep == 1 ? "Scan ULANG jari yang sama untuk konfirmasi" : "Buat akun dengan sidik jari yang sudah divalidasi");

        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent, elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: subTextColor),
              onPressed: () => Navigator.pop(context),
            ),
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
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                    child: _currentStep < 2
                        ? _buildScanUI(title, desc, textColor, subTextColor, currentIsDark)
                        : _buildFormUI(textColor, subTextColor, inputBg, currentIsDark),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // UI KHUSUS SCAN (DIPAKAI BERSAMA UNTUK ENROLL & VALIDATE)
  Widget _buildScanUI(String title, String desc, Color textColor, Color subTextColor, bool isDark) {
    return Column(
      key: ValueKey(_currentStep), // Key penting agar animasi switcher jalan saat ganti step
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Text(title, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 8),
        Text(desc, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: subTextColor)),
        const SizedBox(height: 60),

        GestureDetector(
          onTap: _isScanning ? null : _startScanProcess,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Stack(alignment: Alignment.center, children: [
                if (_isScanning) Container(
                  width: 180 * _pulseAnimation.value, height: 180 * _pulseAnimation.value,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.cyan.withValues(alpha: 0.2), width: 2)),
                ),
                SizedBox(
                  width: 140, height: 140,
                  child: CircularProgressIndicator(
                    value: _scanProgress, strokeWidth: 6,
                    backgroundColor: Colors.cyan.withValues(alpha: 0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyan),
                  ),
                ),
                Icon(Icons.fingerprint_rounded, size: 70, color: _isScanning ? Colors.cyan : (isDark ? Colors.white70 : Colors.black54)),
              ]);
            },
          ),
        ),

        const SizedBox(height: 30),
        Text(_isScanning ? "${(_scanProgress * 100).toInt()}%" : "Ketuk untuk memindai",
            style: TextStyle(fontSize: 16, color: _isScanning ? Colors.cyan : subTextColor, fontWeight: FontWeight.w600)),

        if (!_isScanning) ...[
          const SizedBox(height: 60),
          Text("Langkah ${_currentStep + 1} dari 2", style: TextStyle(color: subTextColor, fontSize: 12)),
        ],
      ],
    );
  }

  // UI FORM DATA AKUN (MUNCUL SETELAH VALIDASI SUKSES)
  Widget _buildFormUI(Color textColor, Color subTextColor, Color inputBg, bool currentIsDark) {
    return Column(
      key: const ValueKey('form'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Row(children: [
          const Icon(Icons.check_circle_rounded, color: Colors.green, size: 24),
          const SizedBox(width: 8),
          Expanded(child: Text("Identitas Terverifikasi!", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold))),
        ]),
        const SizedBox(height: 8),
        Text("Buat Akun Baru", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
        const SizedBox(height: 32),

        TextField(decoration: InputDecoration(hintText: "Username", hintStyle: TextStyle(color: subTextColor), filled: true, fillColor: inputBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), prefixIcon: Icon(Icons.person_outline, color: subTextColor)), style: TextStyle(color: textColor), cursorColor: Colors.cyan),
        const SizedBox(height: 16),
        TextField(keyboardType: TextInputType.emailAddress, decoration: InputDecoration(hintText: "Email Address", hintStyle: TextStyle(color: subTextColor), filled: true, fillColor: inputBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), prefixIcon: Icon(Icons.email_outlined, color: subTextColor)), style: TextStyle(color: textColor), cursorColor: Colors.cyan),
        const SizedBox(height: 16),
        ValueListenableBuilder<bool>(valueListenable: _isPasswordVisible, builder: (_, isVisible, __) => TextField(obscureText: !isVisible, decoration: InputDecoration(hintText: "Password", hintStyle: TextStyle(color: subTextColor), filled: true, fillColor: inputBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), prefixIcon: Icon(Icons.lock_outline, color: subTextColor), suffixIcon: IconButton(icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: subTextColor), onPressed: () => _isPasswordVisible.value = !isVisible)), style: TextStyle(color: textColor), cursorColor: Colors.cyan)),
        const SizedBox(height: 32),

        ElevatedButton(
          onPressed: _isLoading ? null : () => _handleRegister(context, currentIsDark),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), minimumSize: const Size(double.infinity, 50)),
          child: _isLoading
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 3, color: Colors.black))
              : const Text("DAFTAR SEKARANG", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}