import 'package:flutter/material.dart';

import '../services/menu_storage_service.dart';
import 'widgets/menu_helpers.dart';

class ShortcutsScreen extends StatefulWidget {
  const ShortcutsScreen({super.key});

  @override
  State<ShortcutsScreen> createState() => _ShortcutsScreenState();
}

class _ShortcutsScreenState extends State<ShortcutsScreen> {
  final _storage = MenuStorageService();

  bool _loaded = false;
  bool _search = true;
  bool _copy = true;
  bool _block = false;
  bool _tag = true;
  bool _notifBar = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final a = await _storage.getBool(StorageKeys.scSearch, true);
    final b = await _storage.getBool(StorageKeys.scCopy, true);
    final c = await _storage.getBool(StorageKeys.scBlock, false);
    final d = await _storage.getBool(StorageKeys.scTag, true);
    final e = await _storage.getBool(StorageKeys.scNotifBar, false);
    if (!mounted) return;
    setState(() {
      _search = a;
      _copy = b;
      _block = c;
      _tag = d;
      _notifBar = e;
      _loaded = true;
    });
  }

  Widget _item(String title, String sub, bool value, String key,
      ValueChanged<bool> setter) {
    return SwitchCard(
      title: title,
      subtitle: sub,
      value: value,
      onChanged: (v) {
        setState(() => setter(v));
        _storage.setBool(key, v);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        foregroundColor: Colors.white,
        title: const Text('Shortcuts'),
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text('Choose which shortcuts you want to use.',
                      style: TextStyle(color: Colors.grey)),
                ),
                _item('Quick Search', 'Show a search shortcut on the home screen',
                    _search, StorageKeys.scSearch, (v) => _search = v),
                _item('Quick Copy Number', 'Long-press a number to copy it',
                    _copy, StorageKeys.scCopy, (v) => _copy = v),
                _item('Quick Block', 'Block a number with one tap from recent calls',
                    _block, StorageKeys.scBlock, (v) => _block = v),
                _item('Quick Tag', 'Suggest adding a tag after a call ends',
                    _tag, StorageKeys.scTag, (v) => _tag = v),
                _item('Notification Bar Shortcut',
                    'Search numbers from the notification bar',
                    _notifBar, StorageKeys.scNotifBar, (v) => _notifBar = v),
              ],
            ),
    );
  }
}
