import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math' as math;
import 'theme_provider.dart';
import 'dashboard_neon_cyber.dart';
import 'profile_neon_cyber.dart';
import 'settings_neon_cyber.dart';
import 'login_neon_cyber.dart';


class AnalyticsNeonCyber extends StatefulWidget {
  const AnalyticsNeonCyber({super.key});

  @override
  State<AnalyticsNeonCyber> createState() => _AnalyticsNeonCyberState();
}

class _AnalyticsNeonCyberState extends State<AnalyticsNeonCyber> with TickerProviderStateMixin {
  int _selectedIndex = 2; // Default ke Analytics
  bool _isLoading = true;
  final _meteorPainterKey = GlobalKey<_OptimizedMeteorPainterState>();

  // Mock Data untuk Threat Logs
  final List<Map<String, dynamic>> _threatLogs = [
    {'time': '18:55:02', 'type': 'CRITICAL', 'msg': 'Brute force attempt from IP 192.168.1.45', 'color': Colors.redAccent},
    {'time': '18:54:15', 'type': 'WARNING', 'msg': 'Unusual outbound traffic detected on Port 8080', 'color': const Color(0xFFFFD700)},
    {'time': '18:52:30', 'type': 'INFO', 'msg': 'Firewall rules updated successfully', 'color': const Color(0xFF00F3FF)},
    {'time': '18:50:11', 'type': 'SAFE', 'msg': 'System integrity check passed', 'color': const Color(0xFF00FF88)},
    {'time': '18:48:05', 'type': 'WARNING', 'msg': 'High memory usage on Node-04', 'color': const Color(0xFFFFD700)},
  ];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _startParticleLoop());
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  void _startParticleLoop() {
    if (!mounted) return;
    _meteorPainterKey.currentState?.update();
    SchedulerBinding.instance.addPostFrameCallback((_) => _startParticleLoop());
  }

  void _navigateTo(int index) {
    if (_selectedIndex == index) return;
    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      Widget targetScreen;
      switch (index) {
        case 0: targetScreen = const DashboardNeonCyber(); break;
        case 1: targetScreen = const ProfileNeonCyber(); break;
        case 2: targetScreen = const AnalyticsNeonCyber(); break;
        case 3: targetScreen = const SettingsNeonCyber(); break;
        default: return;
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => targetScreen));
    });
  }

  void _handleLogout() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginNeonCyber()), (route) => false);
    });
  }

  void _toggleTheme() { NeonCyberpunkTheme.toggle(); setState(() {}); }
  @override void dispose() { super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final bool isDark = NeonCyberpunkTheme.theme.value;
    final primaryNeon = isDark ? const Color(0xFF00F3FF) : const Color(0xFF8B0000);
    final secondaryNeon = isDark ? const Color(0xFFFFD700) : const Color(0xFF1A1A1A);
    final textColor = isDark ? Colors.white : const Color(0xFF121212);
    final bgColor = isDark ? const Color(0xFF050505) : const Color(0xFFF0F2F5);
    final cardBg = isDark ? const Color(0xFF151921) : Colors.white;
    final surfaceColor = isDark ? const Color(0xFF0B0E14) : const Color(0xFFE8EAED);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(children: [
        // LAYER 1: PARTIKEL BACKGROUND
        RepaintBoundary(child: Stack(children: [
          OptimizedMeteorCanvas(key: _meteorPainterKey, isDark: isDark, bgColor: bgColor),
          Positioned.fill(child: MouseRegion(onHover: (e) => _meteorPainterKey.currentState?.updateMouse(e.localPosition), child: GestureDetector(onPanUpdate: (d) => _meteorPainterKey.currentState?.updateMouse(d.localPosition)))),
        ])),

        Row(children: [
          // SIDEBAR NAVIGASI
          Container(width: 240, color: surfaceColor, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(padding: const EdgeInsets.all(24.0), child: Text("CYBER.DASH", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryNeon, letterSpacing: 2))),
            const Divider(color: Colors.transparent, height: 1),
            ...['Overview', 'Users', 'Analytics', 'Settings'].asMap().entries.map((entry) {
              final index = entry.key; final label = entry.value; final isSelected = _selectedIndex == index;
              return InkWell(onTap: () => _navigateTo(index), child: Container(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), decoration: BoxDecoration(border: Border(left: BorderSide(color: isSelected ? primaryNeon : Colors.transparent, width: 3)), color: isSelected ? primaryNeon.withOpacity(0.1) : Colors.transparent), child: Row(children: [Icon(Icons.circle_outlined, size: 8, color: isSelected ? primaryNeon : textColor.withOpacity(0.3)), const SizedBox(width: 12), Text(label, style: TextStyle(color: isSelected ? primaryNeon : textColor.withOpacity(0.7), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal))])));
            }).toList(),
            const Spacer(),
            Padding(padding: const EdgeInsets.all(24.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [CircleAvatar(radius: 16, backgroundColor: primaryNeon.withOpacity(0.2), child: Icon(Icons.person_outline, size: 16, color: primaryNeon)), const SizedBox(width: 12), Expanded(child: Text("Kenzao_Admin", style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis))]),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: _handleLogout, icon: Icon(Icons.logout_rounded, size: 16, color: Colors.redAccent), label: const Text("LOGOUT", style: TextStyle(color: Colors.redAccent, fontSize: 12)), style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.redAccent.withOpacity(0.3)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))))),
            ])),
          ])),

          // MAIN CONTENT
          Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(32.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("SYSTEM ANALYTICS", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor, letterSpacing: 1)),
            const SizedBox(height: 8), Text("Real-time network monitoring & threat analysis", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 14)),
            const SizedBox(height: 32),

            // RESOURCE GAUGES ROW
            Wrap(spacing: 24, runSpacing: 24, children: [
              _buildGaugeCard(isDark, primaryNeon, textColor, cardBg, "CPU LOAD", "42%", 0.42),
              _buildGaugeCard(isDark, secondaryNeon, textColor, cardBg, "RAM USAGE", "6.2 GB", 0.78),
              _buildGaugeCard(isDark, const Color(0xFF00FF88), textColor, cardBg, "ENCRYPTION", "AES-256", 1.0),
              _buildGaugeCard(isDark, Colors.redAccent, textColor, cardBg, "LATENCY", "12ms", 0.15),
            ]),

            const SizedBox(height: 32),

            // NETWORK TRAFFIC CHART
            Container(width: double.infinity, height: 250, padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryNeon.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Icon(Icons.show_chart_rounded, color: primaryNeon), const SizedBox(width: 8), Text("NETWORK TRAFFIC (I/O)", style: TextStyle(color: primaryNeon, fontWeight: FontWeight.bold, letterSpacing: 1))]),
              const Spacer(),
              SizedBox(height: 150, width: double.infinity, child: CustomPaint(painter: NetworkTrafficPainter(color: primaryNeon, secondaryColor: secondaryNeon))),
            ])),

            const SizedBox(height: 32),

            // THREAT DETECTION LOGS
            Text("THREAT DETECTION LOGS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor, letterSpacing: 1)),
            const SizedBox(height: 16),
            Container(decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: secondaryNeon.withOpacity(0.2))), child: Column(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), decoration: BoxDecoration(gradient: LinearGradient(colors: [secondaryNeon.withOpacity(0.1), Colors.transparent]), borderRadius: const BorderRadius.vertical(top: Radius.circular(16))), child: Row(children: [Expanded(flex: 2, child: Text("TIMESTAMP", style: TextStyle(color: secondaryNeon, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1))), Expanded(flex: 2, child: Text("SEVERITY", style: TextStyle(color: secondaryNeon, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1))), Expanded(flex: 6, child: Text("EVENT MESSAGE", style: TextStyle(color: secondaryNeon, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1)))])),
              ...List.generate(_threatLogs.length, (index) {
                final log = _threatLogs[index];
                return Container(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), decoration: BoxDecoration(border: Border(bottom: BorderSide(color: secondaryNeon.withOpacity(0.05))), color: index % 2 == 0 ? Colors.transparent : secondaryNeon.withOpacity(0.02)), child: Row(children: [Expanded(flex: 2, child: Text(log['time'], style: TextStyle(color: textColor.withOpacity(0.5), fontFamily: 'monospace', fontSize: 12))), Expanded(flex: 2, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: log['color'].withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text(log['type'], style: TextStyle(color: log['color'], fontSize: 12, fontWeight: FontWeight.bold)))), Expanded(flex: 6, child: Text(log['msg'], style: TextStyle(color: textColor, fontSize: 13)))]));
              }),
            ])),
          ]))),
        ]),

        // TOGGLE THEME
        Positioned(top: 24, right: 24, child: IconButton.filledTonal(onPressed: _toggleTheme, icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: primaryNeon), style: IconButton.styleFrom(backgroundColor: cardBg, side: BorderSide(color: primaryNeon.withOpacity(0.3))))),

        // LOADING OVERLAY
        if (_isLoading) Positioned.fill(child: Container(color: bgColor.withOpacity(0.95), child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [SizedBox(width: 60, height: 60, child: CircularProgressIndicator(color: primaryNeon, strokeWidth: 3)), const SizedBox(height: 24), Text("ANALYZING DATA...", style: TextStyle(color: primaryNeon, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 8), Text("Processing metrics stream", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12))])))),
      ]),
    );
  }

  Widget _buildGaugeCard(bool isDark, Color color, Color text, Color bg, String label, String value, double percent) {
    return Container(
      width: 200,
      // HAPUS height: 200 → biarkan fleksibel
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // GANTI Spacer() DENGAN INI
        children: [
          Text(label, style: TextStyle(color: text.withOpacity(0.6), fontSize: 12, letterSpacing: 1)),
          const SizedBox(height: 20), // Spacing tetap rapi tanpa maksa
          SizedBox(
              width: 100,
              height: 100,
              child: CustomPaint(painter: CircularGaugePainter(color: color, percent: percent, isDark: isDark))
          ),
          const SizedBox(height: 20),
          Text(value, style: TextStyle(color: text, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
        ],
      ),
    );
  }
}

// CUSTOM PAINTER UNTUK CIRCULAR GAUGE
class CircularGaugePainter extends CustomPainter {
  final Color color; final double percent; final bool isDark;
  CircularGaugePainter({required this.color, required this.percent, required this.isDark});
  @override void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    final bgPaint = Paint()..color = (isDark ? Colors.white : Colors.black).withOpacity(0.1)..style = PaintingStyle.stroke..strokeWidth = 8;
    final fgPaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 8..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, math.pi * 2 * percent, false, fgPaint);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// CUSTOM PAINTER UNTUK NETWORK TRAFFIC CHART
class NetworkTrafficPainter extends CustomPainter {
  final Color color; final Color secondaryColor;
  NetworkTrafficPainter({required this.color, required this.secondaryColor});
  @override void paint(Canvas canvas, Size size) {
    final rng = math.Random(42);
    final pointsIn = <Offset>[]; final pointsOut = <Offset>[];
    final stepX = size.width / 20;
    for (int i = 0; i <= 20; i++) {
      pointsIn.add(Offset(i * stepX, size.height - (rng.nextDouble() * size.height * 0.6 + size.height * 0.2)));
      pointsOut.add(Offset(i * stepX, size.height - (rng.nextDouble() * size.height * 0.4 + size.height * 0.1)));
    }
    final pathIn = Path()..moveTo(pointsIn[0].dx, pointsIn[0].dy); for (int i = 1; i < pointsIn.length; i++) pathIn.lineTo(pointsIn[i].dx, pointsIn[i].dy);
    final pathOut = Path()..moveTo(pointsOut[0].dx, pointsOut[0].dy); for (int i = 1; i < pointsOut.length; i++) pathOut.lineTo(pointsOut[i].dx, pointsOut[i].dy);
    canvas.drawPath(pathIn, Paint()..color = color..strokeWidth = 2..style = PaintingStyle.stroke);
    canvas.drawPath(pathOut, Paint()..color = secondaryColor..strokeWidth = 2..style = PaintingStyle.stroke);
    // Grid lines
    final gridPaint = Paint()..color = (color.withOpacity(0.1))..strokeWidth = 1;
    for (int i = 1; i < 5; i++) canvas.drawLine(Offset(0, size.height * i / 5), Offset(size.width, size.height * i / 5), gridPaint);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- OPTIMIZED METEOR CANVAS (SELF-CONTAINED) ---
class OptimizedMeteorCanvas extends StatefulWidget { final bool isDark; final Color bgColor; const OptimizedMeteorCanvas({super.key, required this.isDark, required this.bgColor}); @override State<OptimizedMeteorCanvas> createState() => _OptimizedMeteorPainterState(); }
class _OptimizedMeteorPainterState extends State<OptimizedMeteorCanvas> { final List<Meteor> _meteors = []; Offset _mouse = const Offset(-1000, -1000); bool _active = false; final math.Random _rnd = math.Random(); late Paint _glowPaint; late Paint _corePaint; late Paint _bgPaint; @override void initState() { super.initState(); _initPaints(); } void _initPaints() { _glowPaint = Paint()..style = PaintingStyle.fill..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6); _corePaint = Paint()..style = PaintingStyle.fill; _bgPaint = Paint(); } void update() { if (!mounted) return; final isDark = widget.isDark; _glowPaint.blendMode = isDark ? BlendMode.screen : BlendMode.srcOver; _corePaint.blendMode = isDark ? BlendMode.screen : BlendMode.srcOver; for (int i = _meteors.length - 1; i >= 0; i--) { final m = _meteors[i]; m.x += m.vx * 0.5; m.y += m.vy * 0.5; m.life -= 0.015; if (m.life <= 0) _meteors.removeAt(i); } if (_active && _meteors.length < 100) { for (int i = 0; i < 1; i++) { final angle = _rnd.nextDouble() * math.pi * 2; final speed = 1.0 + _rnd.nextDouble() * 2.0; int colorVal; if (isDark) { final darkColors = [0xFF00F3FF, 0xFFFF0055, 0xFFBF00FF, 0xFFFFD700]; colorVal = darkColors[_rnd.nextInt(darkColors.length)]; } else { final lightColors = [0xFF8B0000, 0xFF1A1A1A, 0xFF00008B, 0xFF4B0082]; colorVal = lightColors[_rnd.nextInt(lightColors.length)]; } _meteors.add(Meteor(_mouse.dx + (_rnd.nextDouble()-0.5)*10, _mouse.dy + (_rnd.nextDouble()-0.5)*10, math.cos(angle)*speed, math.sin(angle)*speed, 0.8, 1.5+_rnd.nextDouble()*3.0, colorVal)); } } setState(() {}); } void updateMouse(Offset pos) { if(mounted) { _mouse = pos; _active = true; } } @override Widget build(BuildContext context) { return SizedBox.expand(child: CustomPaint(painter: MeteorPainter(meteors: _meteors, backgroundColor: widget.bgColor, glowPaint: _glowPaint, corePaint: _corePaint, bgPaint: _bgPaint))); } }
class Meteor { double x, y, vx, vy, life, size; final int colorVal; Meteor(this.x, this.y, this.vx, this.vy, this.life, this.size, this.colorVal); }
class MeteorPainter extends CustomPainter { final List<Meteor> meteors; final Color backgroundColor; final Paint glowPaint; final Paint corePaint; final Paint bgPaint; MeteorPainter({required this.meteors, required this.backgroundColor, required this.glowPaint, required this.corePaint, required this.bgPaint}); @override void paint(Canvas canvas, Size size) { bgPaint.color = backgroundColor; canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint); for (final m in meteors) { if (m.life <= 0) continue; final opacity = m.life * 0.4; final color = Color(m.colorVal).withOpacity(opacity); glowPaint.color = color.withOpacity(opacity * 0.5); corePaint.color = color; canvas.drawCircle(Offset(m.x, m.y), m.size * 2.0, glowPaint); canvas.drawCircle(Offset(m.x, m.y), m.size, corePaint); } } @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true; }