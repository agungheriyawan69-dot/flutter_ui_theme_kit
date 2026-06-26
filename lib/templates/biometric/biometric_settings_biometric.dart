import 'package:flutter/material.dart';
import 'theme_provider.dart';

class BiometricSettingsScreenBiometric extends StatefulWidget {
  final bool isDarkMode;
  const BiometricSettingsScreenBiometric({super.key, required this.isDarkMode});

  @override
  State<BiometricSettingsScreenBiometric> createState() => _BiometricSettingsScreenState();
}

class _BiometricSettingsScreenState extends State<BiometricSettingsScreenBiometric> with SingleTickerProviderStateMixin {
  final List<Map<String, String>> _fingerprints = [
    {'name': 'Jari Telunjuk Kanan', 'date': '25 Jun 2024'},
    {'name': 'Jari Jempol Kiri', 'date': '20 Mei 2024'},
  ];

  // STATE DIALOG 3 STEP
  int _enrollStep = 0; // 0=Verif Lama, 1=Enroll Baru, 2=Validasi Baru, 3=Selesai
  double _scanProgress = 0.0;
  bool _isScanning = false;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 1))..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // LOGIKA SCAN 3 TAHAP
  void _startBiometricFlow(BuildContext context, bool isDark) {
    setState(() {
      _enrollStep = 0;
      _scanProgress = 0.0;
      _isScanning = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (dialogCtx, setDialogState) {
          final bgColor = isDark ? const Color(0xFF0F172A) : Colors.white;
          final textColor = isDark ? Colors.white : Colors.black87;
          final subText = isDark ? Colors.white60 : Colors.black54;

          // Judul & Deskripsi Dinamis Berdasarkan Step
          String title = "";
          String desc = "";

          if (_enrollStep == 0) {
            title = "Verifikasi Identitas";
            desc = "Scan sidik jari LAMA untuk melanjutkan";
          } else if (_enrollStep == 1) {
            title = "Daftar Sidik Jari Baru";
            desc = "Sentuh sensor untuk merekam jari BARU";
          } else if (_enrollStep == 2) {
            title = "Validasi Sidik Jari Baru";
            desc = "Scan ULANG jari baru untuk konfirmasi";
          } else {
            title = "Berhasil!";
            desc = "Sidik jari baru telah disimpan dan divalidasi.";
          }

          return AlertDialog(
            backgroundColor: bgColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(title, style: TextStyle(color: textColor, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Text(desc, textAlign: TextAlign.center, style: TextStyle(color: subText, fontSize: 14)),
                const SizedBox(height: 30),

                // AREA SCAN INTERAKTIF
                GestureDetector(
                  onTap: _isScanning || _enrollStep == 3 ? null : () {
                    setDialogState(() => _isScanning = true);
                    int step = 0;
                    Future.doWhile(() async {
                      await Future.delayed(const Duration(milliseconds: 400));
                      if (!mounted) return false;
                      step++;
                      setDialogState(() => _scanProgress = step / 4);

                      if (step >= 4) {
                        setDialogState(() {
                          _isScanning = false;
                          _enrollStep++; // OTOMATIS LANJUT KE STEP BERIKUTNYA
                          _scanProgress = 0.0;
                        });
                        return false;
                      }
                      return true;
                    });
                  },
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (_, __) => Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_isScanning)
                          Container(
                            width: 140 * _pulseAnimation.value, height: 140 * _pulseAnimation.value,
                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.cyan.withValues(alpha: 0.2), width: 2)),
                          ),
                        SizedBox(
                          width: 120, height: 120,
                          child: CircularProgressIndicator(
                            value: _scanProgress > 0 ? _scanProgress : null,
                            strokeWidth: 6, backgroundColor: Colors.cyan.withValues(alpha: 0.1),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.cyan),
                          ),
                        ),
                        Icon(
                          _enrollStep == 3 ? Icons.check_circle_rounded : Icons.fingerprint_rounded,
                          size: 60, color: _enrollStep == 3 ? Colors.green : (_isScanning ? Colors.cyan : subText),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _isScanning ? "${(_scanProgress * 100).toInt()}%" : (_enrollStep == 3 ? "Selesai" : "Ketuk untuk memindai"),
                  style: TextStyle(color: _isScanning ? Colors.cyan : subText, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              if (_enrollStep < 3)
                TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Batal", style: TextStyle(color: subText)))
              else
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    // Tambah data baru ke list setelah validasi sukses
                    setState(() => _fingerprints.add({'name': 'Jari Baru ${_fingerprints.length + 1}', 'date': 'Baru saja'}));
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan, foregroundColor: Colors.black),
                  child: const Text("SELESAI"),
                ),
            ],
          );
        },
      ),
    );
  }

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
            backgroundColor: Colors.transparent, elevation: 0,
            title: Text("Pengaturan Biometrik", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            actions: [
              IconButton(icon: Icon(currentIsDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: subTextColor), onPressed: () => BiometricTheme.toggle()),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: ListView(
                    children: [
                      // SECTION 1: TOGGLE LOGIN
                      Text("Keamanan Login", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: borderColor)),
                        child: Row(children: [
                          Icon(Icons.fingerprint_rounded, color: Colors.cyan, size: 32), const SizedBox(width: 16),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text("Login Sidik Jari", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                            Text("Gunakan sidik jari untuk masuk cepat", style: TextStyle(color: subTextColor, fontSize: 12))
                          ])),
                          Switch.adaptive(value: true, onChanged: (_) {}, activeColor: Colors.cyan)
                        ]),
                      ),
                      const SizedBox(height: 32),

                      // SECTION 2: LIST SIDIK JARI
                      Text("Sidik Jari Terdaftar (${_fingerprints.length})", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                      const SizedBox(height: 16),
                      ListView.separated(
                        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                        itemCount: _fingerprints.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final fp = _fingerprints[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(12), border: Border.all(color: borderColor)),
                            child: Row(children: [
                              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.cyan.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.fingerprint, color: Colors.cyan, size: 20)),
                              const SizedBox(width: 16),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(fp['name']!, style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
                                Text("Didaftarkan pada ${fp['date']}", style: TextStyle(color: subTextColor, fontSize: 12)),
                              ])),
                              IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => setState(() => _fingerprints.removeAt(index))),
                            ]),
                          );
                        },
                      ),
                      const SizedBox(height: 16),

                      // TOMBOL DAFTAR BARU (TRIGGER FLOW 3 STEP)
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _startBiometricFlow(context, currentIsDark),
                          icon: const Icon(Icons.add_circle_outline, color: Colors.cyan),
                          label: const Text("DAFTAR SIDIK JARI BARU", style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.cyan), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // SECTION 3: ZONA BAHAYA
                      Text("Zona Bahaya", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.redAccent.withOpacity(0.3))),
                        child: Row(children: [
                          Icon(Icons.phonelink_lock_rounded, color: Colors.redAccent, size: 32), const SizedBox(width: 16),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text("Hapus Semua Data Biometrik", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                            Text("Tindakan ini tidak dapat dibatalkan", style: TextStyle(color: subTextColor, fontSize: 12))
                          ])),
                          TextButton(onPressed: () => setState(() => _fingerprints.clear()), child: const Text("HAPUS", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))),
                        ]),
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
}