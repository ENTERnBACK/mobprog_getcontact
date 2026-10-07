import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../services/menu_storage_service.dart';
import 'widgets/menu_bottom_nav.dart';
import 'widgets/menu_helpers.dart';

class ProtectionScreen extends StatefulWidget {
  const ProtectionScreen({super.key});

  @override
  State<ProtectionScreen> createState() => _ProtectionScreenState();
}

class _ProtectionScreenState extends State<ProtectionScreen> {
  final _storage = MenuStorageService();

  bool _loaded = false;
  bool _protectionOn = true;
  bool _blockCall = true;
  bool _blockSms = true;
  bool _unknownId = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final a = await _storage.getBool(StorageKeys.protectionOn, true);
    final b = await _storage.getBool(StorageKeys.blockSpamCall, true);
    final c = await _storage.getBool(StorageKeys.blockSpamSms, true);
    final d = await _storage.getBool(StorageKeys.showUnknownId, true);
    if (!mounted) return;
    setState(() {
      _protectionOn = a;
      _blockCall = b;
      _blockSms = c;
      _unknownId = d;
      _loaded = true;
    });
  }

  int get _score => !_protectionOn
      ? 0
      : (_blockCall ? 1 : 0) + (_blockSms ? 1 : 0) + (_unknownId ? 1 : 0);

  String get _levelLabel =>
      _score == 0 ? 'Low' : (_score == 3 ? 'High' : 'Medium');

  Color get _levelColor => _score == 0
      ? const Color(0xFFD64550)
      : (_score == 3 ? const Color(0xFF2EB872) : const Color(0xFFF2A33A));

  double get _levelProgress => 0.15 + _score * (0.85 / 3);

  String get _levelDescription {
    switch (_score) {
      case 0:
        return 'Enable protection against scam calls and messages.';
      case 3:
        return 'You are fully protected against scam calls and messages.';
      default:
        return 'Turn on all features for full protection.';
    }
  }

  Future<void> _startProtection() async {
    setState(() {
      _protectionOn = true;
      _blockCall = true;
      _blockSms = true;
      _unknownId = true;
    });
    await _storage.setBool(StorageKeys.protectionOn, true);
    await _storage.setBool(StorageKeys.blockSpamCall, true);
    await _storage.setBool(StorageKeys.blockSpamSms, true);
    await _storage.setBool(StorageKeys.showUnknownId, true);
    if (mounted) showSnack(context, 'Protection started');
  }

  Future<void> _stopProtection() async {
    setState(() => _protectionOn = false);
    await _storage.setBool(StorageKeys.protectionOn, false);
    if (mounted) showSnack(context, 'Protection stopped');
  }

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        showSnack(context, 'Halaman Home belum tersambung');
        break;
      case 1:
        Navigator.pushNamed(context, '/chats');
        break;
      case 2:
        break;
      case 3:
        Navigator.pop(context);
        break;
    }
  }

  Widget _levelSection() {
    final isHigh = _score == 3;
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: _levelProgress),
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          builder: (context, value, _) {
            return SizedBox(
              width: 260,
              height: 140,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CustomPaint(
                    size: const Size(260, 140),
                    painter: _GaugePainter(progress: value, color: _levelColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('PROTECTION LEVEL',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                                letterSpacing: 0.5)),
                        const SizedBox(height: 2),
                        Text(_levelLabel,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        Text(
          _levelDescription,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: isHigh
              ? OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFFD64550)),
                  ),
                  onPressed: _stopProtection,
                  child: const Text('Stop Protection',
                      style: TextStyle(color: Color(0xFFD64550))),
                )
              : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccent,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _startProtection,
                  child: const Text('Start Protection',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                ),
        ),
        const SizedBox(height: 16),
        const Divider(height: 1, color: Colors.white12),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      bottomNavigationBar: MenuBottomNav(currentIndex: 2, onTap: _onNavTap),
      appBar: AppBar(
        backgroundColor: kBg,
        foregroundColor: Colors.white,
        title: const Text('Activated Protection'),
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _levelSection(),

                Center(
                  child: Icon(
                    _protectionOn ? Icons.verified_user : Icons.shield_outlined,
                    size: 80,
                    color: _protectionOn ? Colors.green : Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    _protectionOn ? 'Protection is active' : 'Protection is off',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                SwitchCard(
                  title: 'Activate Protection',
                  subtitle: 'Turn on all spam & scam protection',
                  value: _protectionOn,
                  onChanged: (v) {
                    setState(() => _protectionOn = v);
                    _storage.setBool(StorageKeys.protectionOn, v);
                  },
                ),
                SwitchCard(
                  title: 'Block Spam Calls',
                  subtitle: 'Automatically block calls tagged as spam/fraud',
                  value: _blockCall,
                  onChanged: !_protectionOn
                      ? null
                      : (v) {
                          setState(() => _blockCall = v);
                          _storage.setBool(StorageKeys.blockSpamCall, v);
                        },
                ),
                SwitchCard(
                  title: 'Block Spam SMS',
                  subtitle: 'Filter suspicious SMS messages',
                  value: _blockSms,
                  onChanged: !_protectionOn
                      ? null
                      : (v) {
                          setState(() => _blockSms = v);
                          _storage.setBool(StorageKeys.blockSpamSms, v);
                        },
                ),
                SwitchCard(
                  title: 'Identify Unknown Numbers',
                  subtitle: 'Show caller name/tag for unsaved numbers',
                  value: _unknownId,
                  onChanged: !_protectionOn
                      ? null
                      : (v) {
                          setState(() => _unknownId = v);
                          _storage.setBool(StorageKeys.showUnknownId, v);
                        },
                ),
              ],
            ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress; // 0..1
  final Color color;

  _GaugePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 18.0;
    final radius = math.min(size.width / 2 - 20, size.height - 24);
    final center = Offset(size.width / 2, size.height - 10);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.white12;
    canvas.drawArc(rect, math.pi, math.pi, false, track);

    final sweep = math.pi * progress.clamp(0.0, 1.0);
    final active = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(rect, math.pi, sweep, false, active);

    final angle = math.pi + sweep;
    final knob = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
    canvas.drawShadow(
      Path()..addOval(Rect.fromCircle(center: knob, radius: 12)),
      Colors.black,
      3,
      true,
    );
    canvas.drawCircle(knob, 12, Paint()..color = Colors.white);
    canvas.drawCircle(knob, 5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter old) =>
      old.progress != progress || old.color != color;
}