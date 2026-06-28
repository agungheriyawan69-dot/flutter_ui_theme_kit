import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'dart:math' as math;
import 'theme_provider.dart';
import 'dashboard_neon_cyber.dart';
import 'profile_neon_cyber.dart';
import 'login_neon_cyber.dart';
import 'analytics_neon_cyber.dart';

class SettingsNeonCyber extends StatefulWidget {
  const SettingsNeonCyber({super.key});
  @override State<SettingsNeonCyber> createState() => _SettingsNeonCyberState();
}

class _SettingsNeonCyberState extends State<SettingsNeonCyber> with TickerProviderStateMixin {
  int _selectedIndex = 3;
  bool _isLoading = true;
  final _meteorPainterKey = GlobalKey<_OptimizedMeteorPainterState>();

  final _nameCtrl = TextEditingController(text: 'Kenzao_Admin');
  final _emailCtrl = TextEditingController(text: 'kenzao@cyber.net');
  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _notifEnabled = true;
  bool _twoFactorEnabled = false;
  bool _showOldPass = false;
  bool _showNewPass = false;
  bool _showConfirmPass = false;

  @override void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => _startParticleLoop());
    Future.delayed(const Duration(milliseconds: 600), () { if (mounted) setState(() => _isLoading = false); });
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

  // FUNGSI LOGOUT
  void _handleLogout() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginNeonCyber()), (route) => false);
    });
  }

  void _toggleTheme() { NeonCyberpunkTheme.toggle(); setState(() {}); }

  void _saveSettings() {
    if (_newPassCtrl.text.isNotEmpty) {
      if (_newPassCtrl.text.length < 8) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('⚠️ New password must be at least 8 characters'), backgroundColor: Colors.redAccent)); return;
      }
      if (_newPassCtrl.text != _confirmPassCtrl.text) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('⚠️ New password and confirmation do not match'), backgroundColor: Colors.redAccent)); return;
      }
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('✅ System Configuration Updated'), backgroundColor: Colors.greenAccent.withOpacity(0.9), behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))));
        _oldPassCtrl.clear(); _newPassCtrl.clear(); _confirmPassCtrl.clear();
        setState(() => _isLoading = false);
      }
    });
  }

  @override void dispose() { _nameCtrl.dispose(); _emailCtrl.dispose(); _oldPassCtrl.dispose(); _newPassCtrl.dispose(); _confirmPassCtrl.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) {
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
        RepaintBoundary(child: Stack(children: [
          OptimizedMeteorCanvas(key: _meteorPainterKey, isDark: isDark, bgColor: bgColor),
          Positioned.fill(child: MouseRegion(onHover: (e) => _meteorPainterKey.currentState?.updateMouse(e.localPosition), child: GestureDetector(onPanUpdate: (d) => _meteorPainterKey.currentState?.updateMouse(d.localPosition)))),
        ])),
        Row(children: [
          Container(width: 240, color: surfaceColor, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(padding: const EdgeInsets.all(24.0), child: Text("CYBER.DASH", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryNeon, letterSpacing: 2))),
            const Divider(color: Colors.transparent, height: 1),
            ...['Overview', 'Users', 'Analytics', 'Settings'].asMap().entries.map((entry) {
              final index = entry.key; final label = entry.value; final isSelected = _selectedIndex == index;
              return InkWell(onTap: () => _navigateTo(index), child: Container(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), decoration: BoxDecoration(border: Border(left: BorderSide(color: isSelected ? primaryNeon : Colors.transparent, width: 3)), color: isSelected ? primaryNeon.withOpacity(0.1) : Colors.transparent), child: Row(children: [Icon(Icons.circle_outlined, size: 8, color: isSelected ? primaryNeon : textColor.withOpacity(0.3)), const SizedBox(width: 12), Text(label, style: TextStyle(color: isSelected ? primaryNeon : textColor.withOpacity(0.7), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal))])));
            }).toList(),
            const Spacer(),
            // SIDEBAR BAWAH DENGAN TOMBOL LOGOUT
            Padding(padding: const EdgeInsets.all(24.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [CircleAvatar(radius: 16, backgroundColor: primaryNeon.withOpacity(0.2), child: Icon(Icons.person_outline, size: 16, color: primaryNeon)), const SizedBox(width: 12), Expanded(child: Text("Kenzao_Admin", style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis))]),
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: _handleLogout, icon: Icon(Icons.logout_rounded, size: 16, color: Colors.redAccent), label: const Text("LOGOUT", style: TextStyle(color: Colors.redAccent, fontSize: 12)), style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.redAccent.withOpacity(0.3)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))))),
            ])),
          ])),
          Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(32.0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("SYSTEM SETTINGS", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor, letterSpacing: 1)),
            const SizedBox(height: 8), Text("Manage identity, security & access protocols", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 14)),
            const SizedBox(height: 32),
            Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryNeon.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Icon(Icons.person_outline, color: primaryNeon), const SizedBox(width: 8), Text("PROFILE IDENTITY", style: TextStyle(color: primaryNeon, fontWeight: FontWeight.bold, letterSpacing: 1))]),
              const SizedBox(height: 24),
              TextField(controller: _nameCtrl, style: TextStyle(color: textColor), cursorColor: primaryNeon, decoration: InputDecoration(labelText: "DISPLAY NAME", labelStyle: TextStyle(color: primaryNeon.withOpacity(0.7)), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryNeon.withOpacity(0.3))), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryNeon, width: 2)))),
              const SizedBox(height: 20),
              TextField(controller: _emailCtrl, style: TextStyle(color: textColor), cursorColor: primaryNeon, decoration: InputDecoration(labelText: "SECURE EMAIL", labelStyle: TextStyle(color: primaryNeon.withOpacity(0.7)), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryNeon.withOpacity(0.3))), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: primaryNeon, width: 2)))),
            ])),
            const SizedBox(height: 24),
            Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: secondaryNeon.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Icon(Icons.lock_outline, color: secondaryNeon), const SizedBox(width: 8), Text("CREDENTIAL UPDATE", style: TextStyle(color: secondaryNeon, fontWeight: FontWeight.bold, letterSpacing: 1))]),
              const SizedBox(height: 24),
              TextField(controller: _oldPassCtrl, obscureText: !_showOldPass, style: TextStyle(color: textColor), cursorColor: secondaryNeon, decoration: InputDecoration(labelText: "CURRENT PASSWORD", labelStyle: TextStyle(color: secondaryNeon.withOpacity(0.7)), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryNeon.withOpacity(0.3))), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryNeon, width: 2)), suffixIcon: IconButton(icon: Icon(_showOldPass ? Icons.visibility_off : Icons.visibility, color: secondaryNeon.withOpacity(0.7)), onPressed: () => setState(() => _showOldPass = !_showOldPass)))),
              const SizedBox(height: 20),
              TextField(controller: _newPassCtrl, obscureText: !_showNewPass, style: TextStyle(color: textColor), cursorColor: secondaryNeon, decoration: InputDecoration(labelText: "NEW PASSWORD", labelStyle: TextStyle(color: secondaryNeon.withOpacity(0.7)), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryNeon.withOpacity(0.3))), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryNeon, width: 2)), suffixIcon: IconButton(icon: Icon(_showNewPass ? Icons.visibility_off : Icons.visibility, color: secondaryNeon.withOpacity(0.7)), onPressed: () => setState(() => _showNewPass = !_showNewPass)))),
              const SizedBox(height: 20),
              TextField(controller: _confirmPassCtrl, obscureText: !_showConfirmPass, style: TextStyle(color: textColor), cursorColor: secondaryNeon, decoration: InputDecoration(labelText: "CONFIRM NEW PASSWORD", labelStyle: TextStyle(color: secondaryNeon.withOpacity(0.7)), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryNeon.withOpacity(0.3))), focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: secondaryNeon, width: 2)), suffixIcon: IconButton(icon: Icon(_showConfirmPass ? Icons.visibility_off : Icons.visibility, color: secondaryNeon.withOpacity(0.7)), onPressed: () => setState(() => _showConfirmPass = !_showConfirmPass)))),
            ])),
            const SizedBox(height: 24),
            Container(padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: cardBg, borderRadius: BorderRadius.circular(16), border: Border.all(color: primaryNeon.withOpacity(0.2))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [Icon(Icons.shield_sharp, color: primaryNeon), const SizedBox(width: 8), Text("ACCESS PROTOCOLS", style: TextStyle(color: primaryNeon, fontWeight: FontWeight.bold, letterSpacing: 1))]),
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("System Notifications", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)), Text("Receive alerts for system events", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12))]), Switch(value: _notifEnabled, onChanged: (v) => setState(() => _notifEnabled = v), activeColor: primaryNeon, inactiveThumbColor: textColor.withOpacity(0.3), inactiveTrackColor: textColor.withOpacity(0.1))]),
              const Divider(color: Colors.transparent, height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Two-Factor Auth (2FA)", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)), Text("Require OTP for sensitive operations", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12))]), Switch(value: _twoFactorEnabled, onChanged: (v) => setState(() => _twoFactorEnabled = v), activeColor: secondaryNeon, inactiveThumbColor: textColor.withOpacity(0.3), inactiveTrackColor: textColor.withOpacity(0.1))]),
            ])),
            const SizedBox(height: 32),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton.icon(onPressed: _saveSettings, icon: const Icon(Icons.save_rounded), label: const Text("SAVE CHANGES", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)), style: ElevatedButton.styleFrom(backgroundColor: primaryNeon, foregroundColor: isDark ? Colors.black : Colors.white, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))),
          ]))),
        ]),
        Positioned(top: 24, right: 24, child: IconButton.filledTonal(onPressed: _toggleTheme, icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, color: primaryNeon), style: IconButton.styleFrom(backgroundColor: cardBg, side: BorderSide(color: primaryNeon.withOpacity(0.3))))),
        if (_isLoading) Positioned.fill(child: Container(color: bgColor.withOpacity(0.95), child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [SizedBox(width: 60, height: 60, child: CircularProgressIndicator(color: primaryNeon, strokeWidth: 3)), const SizedBox(height: 24), Text("UPDATING CONFIG...", style: TextStyle(color: primaryNeon, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)), const SizedBox(height: 8), Text("Syncing preferences", style: TextStyle(color: textColor.withOpacity(0.5), fontSize: 12))])))),
      ]),
    );
  }
}

// --- OPTIMIZED METEOR CANVAS (COPY PASTE DARI FILE LAIN BIAR SELF-CONTAINED) ---
class OptimizedMeteorCanvas extends StatefulWidget { final bool isDark; final Color bgColor; const OptimizedMeteorCanvas({super.key, required this.isDark, required this.bgColor}); @override State<OptimizedMeteorCanvas> createState() => _OptimizedMeteorPainterState(); }
class _OptimizedMeteorPainterState extends State<OptimizedMeteorCanvas> { final List<Meteor> _meteors = []; Offset _mouse = const Offset(-1000, -1000); bool _active = false; final math.Random _rnd = math.Random(); late Paint _glowPaint; late Paint _corePaint; late Paint _bgPaint; @override void initState() { super.initState(); _initPaints(); } void _initPaints() { _glowPaint = Paint()..style = PaintingStyle.fill..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6); _corePaint = Paint()..style = PaintingStyle.fill; _bgPaint = Paint(); } void update() { if (!mounted) return; final isDark = widget.isDark; _glowPaint.blendMode = isDark ? BlendMode.screen : BlendMode.srcOver; _corePaint.blendMode = isDark ? BlendMode.screen : BlendMode.srcOver; for (int i = _meteors.length - 1; i >= 0; i--) { final m = _meteors[i]; m.x += m.vx * 0.5; m.y += m.vy * 0.5; m.life -= 0.015; if (m.life <= 0) _meteors.removeAt(i); } if (_active && _meteors.length < 100) { for (int i = 0; i < 1; i++) { final angle = _rnd.nextDouble() * math.pi * 2; final speed = 1.0 + _rnd.nextDouble() * 2.0; int colorVal; if (isDark) { final darkColors = [0xFF00F3FF, 0xFFFF0055, 0xFFBF00FF, 0xFFFFD700]; colorVal = darkColors[_rnd.nextInt(darkColors.length)]; } else { final lightColors = [0xFF8B0000, 0xFF1A1A1A, 0xFF00008B, 0xFF4B0082]; colorVal = lightColors[_rnd.nextInt(lightColors.length)]; } _meteors.add(Meteor(_mouse.dx + (_rnd.nextDouble()-0.5)*10, _mouse.dy + (_rnd.nextDouble()-0.5)*10, math.cos(angle)*speed, math.sin(angle)*speed, 0.8, 1.5+_rnd.nextDouble()*3.0, colorVal)); } } setState(() {}); } void updateMouse(Offset pos) { if(mounted) { _mouse = pos; _active = true; } } @override Widget build(BuildContext context) { return SizedBox.expand(child: CustomPaint(painter: MeteorPainter(meteors: _meteors, backgroundColor: widget.bgColor, glowPaint: _glowPaint, corePaint: _corePaint, bgPaint: _bgPaint))); } }
class Meteor { double x, y, vx, vy, life, size; final int colorVal; Meteor(this.x, this.y, this.vx, this.vy, this.life, this.size, this.colorVal); }
class MeteorPainter extends CustomPainter { final List<Meteor> meteors; final Color backgroundColor; final Paint glowPaint; final Paint corePaint; final Paint bgPaint; MeteorPainter({required this.meteors, required this.backgroundColor, required this.glowPaint, required this.corePaint, required this.bgPaint}); @override void paint(Canvas canvas, Size size) { bgPaint.color = backgroundColor; canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint); for (final m in meteors) { if (m.life <= 0) continue; final opacity = m.life * 0.4; final color = Color(m.colorVal).withOpacity(opacity); glowPaint.color = color.withOpacity(opacity * 0.5); corePaint.color = color; canvas.drawCircle(Offset(m.x, m.y), m.size * 2.0, glowPaint); canvas.drawCircle(Offset(m.x, m.y), m.size, corePaint); } } @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true; }