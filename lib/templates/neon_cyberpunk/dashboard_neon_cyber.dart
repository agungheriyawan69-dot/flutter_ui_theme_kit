import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math' as math;
import 'theme_provider.dart';
import 'login_neon_cyber.dart';
import 'settings_neon_cyber.dart';
import 'profile_neon_cyber.dart';
import 'analytics_neon_cyber.dart';

// ==========================================
// DASHBOARD NEON CYBERPUNK (WITH LOGOUT NAVIGATION)
// - Tombol Logout Aktif + Loading Effect
// - Toggle Theme Responsif
// - Zero-Lag Particle System
// ==========================================
class DashboardNeonCyber extends StatefulWidget {
  const DashboardNeonCyber({super.key});

  @override
  State<DashboardNeonCyber> createState() => _DashboardNeonCyberState();
}

class _DashboardNeonCyberState extends State<DashboardNeonCyber> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isLoading = true;
  String _loadingText = "INITIALIZING SYSTEM...";
  String _loadingSubtext = "Loading modules & assets";

  final _meteorPainterKey = GlobalKey<_OptimizedMeteorPainterState>();

  final List<String> _navItems = ['Overview', 'Users', 'Analytics', 'Settings'];
  final List<Map<String, dynamic>> _tableData = [
    {'id': '#NX-001', 'user': 'Kenzao_Admin', 'status': 'Active', 'lastLogin': '2 min ago'},
    {'id': '#NX-002', 'user': 'System_Bot', 'status': 'Idle', 'lastLogin': '1 hour ago'},
    {'id': '#NX-003', 'user': 'Guest_User', 'status': 'Offline', 'lastLogin': '3 days ago'},
    {'id': '#NX-004', 'user': 'Dev_Tester', 'status': 'Active', 'lastLogin': 'Just now'},
  ];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _startParticleLoop());
    Future.delayed(const Duration(milliseconds: 800), () {
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

    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;

      Widget targetScreen;
      switch (index) {
        case 0: targetScreen = const DashboardNeonCyber(); break;
        case 1: targetScreen = const ProfileNeonCyber(); break;
        case 2: targetScreen = const AnalyticsNeonCyber(); break; // KONEK KE ANALYTICS
        case 3: targetScreen = const SettingsNeonCyber(); break;
        default: return;
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => targetScreen));
    });
  }

  // FUNGSI LOGOUT DENGAN LOADING EFFECT
  void _handleLogout() {
    setState(() {
      _isLoading = true;
      _loadingText = "DISCONNECTING...";
      _loadingSubtext = "Clearing session data";
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginNeonCyber())
        );
      }
    });
  }

  void _toggleTheme() {
    NeonCyberpunkTheme.toggle();
    setState(() {});
  }

  @override
  void dispose() { super.dispose(); }

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
      body: Stack(
        children: [
          // LAYER 1: PARTIKEL & MOUSE TRACKER
          RepaintBoundary(
            child: Stack(
              children: [
                OptimizedMeteorCanvas(
                  key: _meteorPainterKey,
                  isDark: isDark,
                  bgColor: bgColor,
                ),
                Positioned.fill(
                  child: MouseRegion(
                    onHover: (e) => _meteorPainterKey.currentState?.updateMouse(e.localPosition),
                    child: GestureDetector(onPanUpdate: (d) => _meteorPainterKey.currentState?.updateMouse(d.localPosition)),
                  ),
                ),
              ],
            ),
          ),

          // LAYER 2: MAIN CONTENT
          Row(
            children: [
              Container(
                width: 240, color: surfaceColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text("CYBER.DASH", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryNeon, letterSpacing: 2)),
                    ),
                    const Divider(color: Colors.transparent, height: 1),
                    ...List.generate(_navItems.length, (index) {
                      final isSelected = _selectedIndex == index;
                      return InkWell(
                        onTap: () => _navigateTo(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                          decoration: BoxDecoration(
                            border: Border(left: BorderSide(color: isSelected ? primaryNeon : Colors.transparent, width: 3)),
                            color: isSelected ? primaryNeon.withOpacity(0.1) : Colors.transparent,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.circle_outlined, size: 8, color: isSelected ? primaryNeon : textColor.withOpacity(0.3)),
                              const SizedBox(width: 12),
                              Text(_navItems[index], style: TextStyle(color: isSelected ? primaryNeon : textColor.withOpacity(0.7), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                            ],
                          ),
                        ),
                      );
                    }),
                    const Spacer(),

                    // PROFIL USER & TOMBOL LOGOUT (AKTIF!)
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(radius: 16, backgroundColor: primaryNeon.withOpacity(0.2),
                                  child: Icon(Icons.person_outline, size: 16, color: primaryNeon)),
                              const SizedBox(width: 12),
                              Expanded(child: Text("Kenzao_Admin", style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(width: double.infinity, child: OutlinedButton.icon(
                            onPressed: _handleLogout,
                            icon: Icon(Icons.logout_rounded, size: 16, color: Colors.redAccent),
                            label: const Text("LOGOUT", style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                            style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.redAccent.withOpacity(0.3)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("SYSTEM OVERVIEW", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor, letterSpacing: 1)),
                      const SizedBox(height: 8),
                      Text("Real-time monitoring & analytics", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 14)),
                      const SizedBox(height: 32),

                      Wrap(spacing: 24, runSpacing: 24, children: [
                        _buildStatCard(isDark, primaryNeon, secondaryNeon, textColor, cardBg, "Total Users", "12,450", "+12%", true),
                        _buildStatCard(isDark, primaryNeon, secondaryNeon, textColor, cardBg, "Revenue", "\$84,200", "-3%", false),
                        _buildStatCard(isDark, primaryNeon, secondaryNeon, textColor, cardBg, "Active Sessions", "1,204", "+24%", true),
                        _buildStatCard(isDark, primaryNeon, secondaryNeon, textColor, cardBg, "Server Load", "42%", "Stable", true),
                      ]),

                      const SizedBox(height: 40),

                      Text("RECENT ACTIVITY LOGS", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor, letterSpacing: 1)),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryNeon.withOpacity(0.2))),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              decoration: BoxDecoration(gradient: LinearGradient(colors: [primaryNeon.withOpacity(0.1), Colors.transparent]), borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
                              child: Row(children: [
                                Expanded(flex: 2, child: Text("ID", style: TextStyle(color: primaryNeon, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1))),
                                Expanded(flex: 3, child: Text("USER", style: TextStyle(color: primaryNeon, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1))),
                                Expanded(flex: 2, child: Text("STATUS", style: TextStyle(color: primaryNeon, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1))),
                                Expanded(flex: 3, child: Text("LAST LOGIN", style: TextStyle(color: primaryNeon, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1))),
                              ]),
                            ),
                            ...List.generate(_tableData.length, (index) {
                              final item = _tableData[index];
                              final statusColor = item['status'] == 'Active' ? const Color(0xFF00FF88) : (item['status'] == 'Idle' ? secondaryNeon : Colors.redAccent);
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: primaryNeon.withOpacity(0.05))), color: index % 2 == 0 ? Colors.transparent : primaryNeon.withOpacity(0.02)),
                                child: Row(children: [
                                  Expanded(flex: 2, child: Text(item['id'], style: TextStyle(color: textColor.withOpacity(0.7), fontFamily: 'monospace'))),
                                  Expanded(flex: 3, child: Text(item['user'], style: TextStyle(color: textColor, fontWeight: FontWeight.bold))),
                                  Expanded(flex: 2, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text(item['status'], style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)))),
                                  Expanded(flex: 3, child: Text(item['lastLogin'], style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12))),
                                ]),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // LAYER 3: TOGGLE THEME BUTTON
          Positioned(
            top: 24, right: 24,
            child: IconButton.filledTonal(
              onPressed: _toggleTheme,
              icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: primaryNeon),
              style: IconButton.styleFrom(backgroundColor: cardBg, side: BorderSide(color: primaryNeon.withOpacity(0.3))),
              tooltip: isDark ? "Switch to Light Mode" : "Switch to Dark Mode",
            ),
          ),

          // LAYER 4: LOADING OVERLAY (DYNAMIC TEXT)
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: bgColor.withOpacity(0.95),
                child: Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    SizedBox(width: 60, height: 60, child: CircularProgressIndicator(color: primaryNeon, strokeWidth: 3)),
                    const SizedBox(height: 24),
                    Text(_loadingText, style: TextStyle(color: primaryNeon, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    const SizedBox(height: 8),
                    Text(_loadingSubtext, style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12)),
                  ]),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(bool isDark, Color primary, Color secondary, Color text, Color bg, String label, String value, String trend, bool isPositive) {
    return Container(
      width: 280, padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: primary.withOpacity(0.2)), boxShadow: [BoxShadow(color: primary.withOpacity(0.05), blurRadius: 10, spreadRadius: 2)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(color: text.withOpacity(0.6), fontSize: 12, letterSpacing: 1)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(value, style: TextStyle(color: text, fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: (isPositive ? const Color(0xFF00FF88) : Colors.redAccent).withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text(trend, style: TextStyle(color: isPositive ? const Color(0xFF00FF88) : Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold))),
        ]),
        const SizedBox(height: 16),
        SizedBox(height: 40, width: double.infinity, child: CustomPaint(painter: SparklinePainter(color: primary, isPositive: isPositive))),
      ]),
    );
  }
}

// CANVAS PARTIKEL TERISOLASI
class OptimizedMeteorCanvas extends StatefulWidget {
  final bool isDark;
  final Color bgColor;
  const OptimizedMeteorCanvas({super.key, required this.isDark, required this.bgColor});
  @override State<OptimizedMeteorCanvas> createState() => _OptimizedMeteorPainterState();
}

class _OptimizedMeteorPainterState extends State<OptimizedMeteorCanvas> {
  final List<Meteor> _meteors = [];
  Offset _mouse = const Offset(-1000, -1000);
  bool _active = false;
  final math.Random _rnd = math.Random();
  late Paint _glowPaint;
  late Paint _corePaint;
  late Paint _bgPaint;

  @override
  void initState() {
    super.initState();
    _initPaints();
  }

  void _initPaints() {
    _glowPaint = Paint()..style = PaintingStyle.fill..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    _corePaint = Paint()..style = PaintingStyle.fill;
    _bgPaint = Paint();
  }

  void update() {
    if (!mounted) return;
    final isDark = widget.isDark;
    _glowPaint.blendMode = isDark ? BlendMode.screen : BlendMode.srcOver;
    _corePaint.blendMode = isDark ? BlendMode.screen : BlendMode.srcOver;

    for (int i = _meteors.length - 1; i >= 0; i--) {
      final m = _meteors[i];
      m.x += m.vx * 0.5; m.y += m.vy * 0.5; m.life -= 0.015;
      if (m.life <= 0) _meteors.removeAt(i);
    }

    if (_active && _meteors.length < 100) {
      for (int i = 0; i < 1; i++) {
        final angle = _rnd.nextDouble() * math.pi * 2;
        final speed = 1.0 + _rnd.nextDouble() * 2.0;
        int colorVal;
        if (isDark) {
          final darkColors = [0xFF00F3FF, 0xFFFF0055, 0xFFBF00FF, 0xFFFFD700];
          colorVal = darkColors[_rnd.nextInt(darkColors.length)];
        } else {
          final lightColors = [0xFF8B0000, 0xFF1A1A1A, 0xFF00008B, 0xFF4B0082];
          colorVal = lightColors[_rnd.nextInt(lightColors.length)];
        }
        _meteors.add(Meteor(_mouse.dx + (_rnd.nextDouble()-0.5)*10, _mouse.dy + (_rnd.nextDouble()-0.5)*10, math.cos(angle)*speed, math.sin(angle)*speed, 0.8, 1.5+_rnd.nextDouble()*3.0, colorVal));
      }
    }
    setState(() {});
  }

  void updateMouse(Offset pos) {
    if(mounted) { _mouse = pos; _active = true; }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: CustomPaint(painter: MeteorPainter(meteors: _meteors, backgroundColor: widget.bgColor, glowPaint: _glowPaint, corePaint: _corePaint, bgPaint: _bgPaint)),
    );
  }
}

class Meteor {
  double x, y, vx, vy, life, size;
  final int colorVal;
  Meteor(this.x, this.y, this.vx, this.vy, this.life, this.size, this.colorVal);
}

class MeteorPainter extends CustomPainter {
  final List<Meteor> meteors;
  final Color backgroundColor;
  final Paint glowPaint;
  final Paint corePaint;
  final Paint bgPaint;

  MeteorPainter({required this.meteors, required this.backgroundColor, required this.glowPaint, required this.corePaint, required this.bgPaint});

  @override
  void paint(Canvas canvas, Size size) {
    bgPaint.color = backgroundColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    for (final m in meteors) {
      if (m.life <= 0) continue;
      final opacity = m.life * 0.4;
      final color = Color(m.colorVal).withOpacity(opacity);

      glowPaint.color = color.withOpacity(opacity * 0.5);
      corePaint.color = color;

      canvas.drawCircle(Offset(m.x, m.y), m.size * 2.0, glowPaint);
      canvas.drawCircle(Offset(m.x, m.y), m.size, corePaint);
    }
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SparklinePainter extends CustomPainter {
  final Color color;
  final bool isPositive;
  SparklinePainter({required this.color, required this.isPositive});

  @override
  void paint(Canvas canvas, Size size) {
    final points = <Offset>[];
    final stepX = size.width / 10;
    final rng = math.Random(42);
    for (int i = 0; i <= 10; i++) {
      double y = isPositive
          ? size.height - (rng.nextDouble() * size.height * 0.6 + size.height * 0.2)
          : rng.nextDouble() * size.height * 0.6 + size.height * 0.2;
      points.add(Offset(i * stepX, y));
    }
    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < points.length; i++) path.lineTo(points[i].dx, points[i].dy);

    final fillPath = Path.from(path)..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    canvas.drawPath(fillPath, Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [color.withOpacity(0.2), Colors.transparent]).createShader(Rect.fromLTWH(0, 0, size.width, size.height))..style = PaintingStyle.fill);
    canvas.drawPath(path, Paint()..color = color..strokeWidth = 2..style = PaintingStyle.stroke..strokeCap = StrokeCap.round);
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}