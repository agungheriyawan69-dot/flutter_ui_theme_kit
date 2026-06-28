import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math' as math;
import 'theme_provider.dart';

// ==========================================
// REGISTER SCREEN NEON CYBERPUNK (FINAL + DUAL PASSWORD)
// 1. Partikel Cursor (neon_liquid.frag) AKTIF
// 2. Border Muter Pakai SweepGradient (Stabil & Nyambung Sempurna)
// 3. Toggle Password Native Terintegrasi (2 Field)
// ==========================================
class RegisterNeonCyber extends StatefulWidget {
  const RegisterNeonCyber({super.key});

  @override
  State<RegisterNeonCyber> createState() => _RegisterNeonCyberState();
}

class _RegisterNeonCyberState extends State<RegisterNeonCyber> with TickerProviderStateMixin {
  // --- PARTIKEL CURSOR STATE ---
  FragmentProgram? _liquidProgram;
  final List<Meteor> _meteors = [];
  Offset _mouse = const Offset(-1000, -1000);
  bool _active = false;
  final math.Random _rnd = math.Random();
  final Paint _glowPaint = Paint()..style = PaintingStyle.fill..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
  final Paint _corePaint = Paint()..style = PaintingStyle.fill;

  // --- BORDER ANIMATION STATE ---
  late AnimationController _borderCtrl;

  // --- TOGGLE PASSWORD STATES ---
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final TextEditingController _confirmPassCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Setup Partikel Cursor
    _loadLiquidShader();
    SchedulerBinding.instance.addPostFrameCallback((_) => _renderLoop());

    // Setup Border Muter (3 detik per putaran)
    _borderCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
  }

  Future<void> _loadLiquidShader() async {
    try {
      _liquidProgram = await FragmentProgram.fromAsset('shaders/neon_liquid.frag');
      if (mounted) setState(() {});
    } catch (e) { debugPrint('Liquid shader load failed: $e'); }
  }

  void _renderLoop() {
    if (!mounted) return;
    final bool isDark = NeonCyberpunkTheme.theme.value;
    _glowPaint.blendMode = isDark ? BlendMode.screen : BlendMode.srcOver;
    _corePaint.blendMode = isDark ? BlendMode.screen : BlendMode.srcOver;

    for (int i = _meteors.length - 1; i >= 0; i--) {
      final m = _meteors[i];
      m.x += m.vx; m.y += m.vy; m.life -= 0.02;
      if (m.life <= 0) _meteors.removeAt(i);
    }

    if (_active && _meteors.length < 800) {
      for (int i = 0; i < 4 + _rnd.nextInt(3); i++) {
        if (_meteors.length >= 800) break;
        final angle = _rnd.nextDouble() * math.pi * 2;
        final speed = 1.5 + _rnd.nextDouble() * 4.0;
        int colorVal;
        if (isDark) {
          final darkColors = [0xFF00F3FF, 0xFFFF0055, 0xFFBF00FF, 0xFFFFD700];
          colorVal = darkColors[_rnd.nextInt(darkColors.length)];
        } else {
          final lightColors = [0xFF8B0000, 0xFF1A1A1A, 0xFF00008B, 0xFF4B0082];
          colorVal = lightColors[_rnd.nextInt(lightColors.length)];
        }
        _meteors.add(Meteor(
            _mouse.dx + (_rnd.nextDouble()-0.5)*15,
            _mouse.dy + (_rnd.nextDouble()-0.5)*15,
            math.cos(angle)*speed, math.sin(angle)*speed,
            1.0, 2.0+_rnd.nextDouble()*5.0, colorVal
        ));
      }
    }
    setState(() {});
    SchedulerBinding.instance.addPostFrameCallback((_) => _renderLoop());
  }

  void _updateMouse(Offset pos) { if(mounted) { _mouse = pos; _active = true; } }

  @override
  void dispose() {
    _borderCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = NeonCyberpunkTheme.theme.value;
    final primaryNeon = isDark ? const Color(0xFF00F3FF) : const Color(0xFF8B0000);
    final secondaryNeon = isDark ? const Color(0xFFFFD700) : const Color(0xFF1A1A1A);
    final textColor = isDark ? Colors.white : const Color(0xFF121212);
    final bgColor = isDark ? const Color(0xFF050505) : const Color(0xFFF0F2F5);
    final cardBg = isDark ? const Color(0xFF151921) : Colors.white;

    return ValueListenableBuilder<bool>(
      valueListenable: NeonCyberpunkTheme.theme,
      builder: (context, _, __) {
        return Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent, elevation: 0,
            leading: IconButton(icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryNeon), onPressed: () => Navigator.pop(context)),
            actions: [IconButton(icon: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: primaryNeon), onPressed: () => NeonCyberpunkTheme.toggle())],
          ),
          body: Stack(
            children: [
              // LAYER 1: BACKGROUND PARTIKEL CURSOR
              Positioned.fill(child: CustomPaint(painter: MeteorPainter(meteors: _meteors, backgroundColor: bgColor))),

              // LAYER 2: MOUSE TRACKER
              Positioned.fill(child: MouseRegion(onHover: (e) => _updateMouse(e.localPosition), child: GestureDetector(onPanUpdate: (d) => _updateMouse(d.localPosition)))),

              // LAYER 3: FORM REGISTER DENGAN BORDER MUTER
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: 360,
                    height: 720, // Lebih tinggi karena ada 2 field password
                    child: Stack(
                      children: [
                        // A. BORDER BERJALAN MUTER (SWEEP GRADIENT)
                        Positioned.fill(
                          child: AnimatedBuilder(
                            animation: _borderCtrl,
                            builder: (context, child) {
                              double angle = _borderCtrl.value * 2 * math.pi;
                              return ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return SweepGradient(
                                    center: Alignment.center,
                                    startAngle: 0.0,
                                    endAngle: math.pi * 2,
                                    transform: GradientRotation(angle),
                                    colors: [primaryNeon, secondaryNeon, primaryNeon],
                                    stops: const [0.0, 0.5, 1.0],
                                  ).createShader(bounds);
                                },
                                blendMode: BlendMode.srcIn,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // B. KONTEN FORM REGISTER (DI DEPAN BORDER)
                        Positioned.fill(
                          child: Container(
                            margin: const EdgeInsets.all(2),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("NEW IDENTITY", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryNeon, letterSpacing: 2)),
                                const SizedBox(height: 40),

                                TextField(style: TextStyle(color: textColor), cursorColor: primaryNeon,
                                    decoration: InputDecoration(labelText: "USERNAME", labelStyle: TextStyle(color: primaryNeon.withOpacity(0.7)),
                                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryNeon.withOpacity(0.3))),
                                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryNeon, width: 2)))),
                                const SizedBox(height: 24),

                                TextField(style: TextStyle(color: textColor), cursorColor: primaryNeon,
                                    decoration: InputDecoration(labelText: "EMAIL", labelStyle: TextStyle(color: primaryNeon.withOpacity(0.7)),
                                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryNeon.withOpacity(0.3))),
                                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryNeon, width: 2)))),
                                const SizedBox(height: 24),

                                // FIELD PASSWORD PERTAMA
                                TextField(
                                    obscureText: !_isPasswordVisible,
                                    style: TextStyle(color: textColor),
                                    cursorColor: secondaryNeon,
                                    decoration: InputDecoration(
                                        labelText: "PASSWORD",
                                        labelStyle: TextStyle(color: secondaryNeon.withOpacity(0.7)),
                                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryNeon.withOpacity(0.3))),
                                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryNeon, width: 2)),
                                        suffixIcon: IconButton(
                                          icon: Icon(_isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: secondaryNeon.withOpacity(0.7)),
                                          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                        )
                                    )
                                ),
                                const SizedBox(height: 24),

                                // FIELD KONFIRMASI PASSWORD (BARU!)
                                TextField(
                                    controller: _confirmPassCtrl,
                                    obscureText: !_isConfirmPasswordVisible,
                                    style: TextStyle(color: textColor),
                                    cursorColor: secondaryNeon,
                                    decoration: InputDecoration(
                                        labelText: "CONFIRM PASSWORD",
                                        labelStyle: TextStyle(color: secondaryNeon.withOpacity(0.7)),
                                        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryNeon.withOpacity(0.3))),
                                        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryNeon, width: 2)),
                                        suffixIcon: IconButton(
                                          icon: Icon(_isConfirmPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: secondaryNeon.withOpacity(0.7)),
                                          onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                                        )
                                    )
                                ),

                                const SizedBox(height: 40),

                                // TOMBOL REGISTER DENGAN VALIDASI DASAR
                                SizedBox(width: double.infinity, height: 50,
                                  child: ElevatedButton(onPressed: () {
                                    if (_confirmPassCtrl.text.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: const Text('Please confirm your password!'), backgroundColor: Colors.redAccent)
                                      );
                                      return;
                                    }
                                    // Lanjutkan logic register di sini...
                                  },
                                      style: ElevatedButton.styleFrom(backgroundColor: primaryNeon, foregroundColor: isDark?Colors.black:Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                                      child: const Text("REGISTER NOW", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1))
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ==========================================
// METEOR DATA & PAINTER (PARTIKEL CURSOR)
// ==========================================
class Meteor {
  double x, y, vx, vy, life, size;
  final int colorVal;
  Meteor(this.x, this.y, this.vx, this.vy, this.life, this.size, this.colorVal);
}

class MeteorPainter extends CustomPainter {
  final List<Meteor> meteors;
  final Color backgroundColor;
  static final Paint _bgPaint = Paint();
  MeteorPainter({required this.meteors, required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    _bgPaint.color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), _bgPaint);
    for (final m in meteors) {
      if (m.life <= 0) continue;
      final opacity = m.life;
      final color = Color(m.colorVal).withOpacity(opacity);
      final isDark = backgroundColor.value == 0xFF050505 || backgroundColor == Colors.black;
      final blend = isDark ? BlendMode.screen : BlendMode.srcOver;
      final glowP = Paint()..style = PaintingStyle.fill..blendMode = blend..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)..color = color.withOpacity(opacity * 0.5);
      final coreP = Paint()..style = PaintingStyle.fill..blendMode = blend..color = color;
      canvas.drawCircle(Offset(m.x, m.y), m.size * 3.0, glowP);
      canvas.drawCircle(Offset(m.x, m.y), m.size, coreP);
    }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}