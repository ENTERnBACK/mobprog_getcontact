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

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        showSnack(context, 'Halaman Home belum tersambung');
        break;
      case 1:
        Navigator.pushNamed(context, '/chats');
        break;
      case 2:
        break; // sudah di Protection
      case 3:
        Navigator.pop(context); // kembali ke halaman Menu
        break;
    }
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