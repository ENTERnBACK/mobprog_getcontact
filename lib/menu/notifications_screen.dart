import 'package:flutter/material.dart';

import '../services/menu_storage_service.dart';
import 'widgets/menu_helpers.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _storage = MenuStorageService();

  bool _loaded = false;
  bool _push = true;
  bool _viewed = true;
  bool _tags = true;
  bool _chat = true;
  bool _promo = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final a = await _storage.getBool(StorageKeys.notifPush, true);
    final b = await _storage.getBool(StorageKeys.notifViewed, true);
    final c = await _storage.getBool(StorageKeys.notifTags, true);
    final d = await _storage.getBool(StorageKeys.notifChat, true);
    final e = await _storage.getBool(StorageKeys.notifPromo, false);
    if (!mounted) return;
    setState(() {
      _push = a;
      _viewed = b;
      _tags = c;
      _chat = d;
      _promo = e;
      _loaded = true;
    });
  }

  Widget _item(String title, String sub, bool value, String key,
      ValueChanged<bool> setter,
      {bool needPush = true}) {
    return SwitchCard(
      title: title,
      subtitle: sub,
      value: value,
      onChanged: (needPush && !_push)
          ? null
          : (v) {
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
        title: const Text('Notifications'),
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _item('Push Notifications', 'Enable or disable all notifications',
                    _push, StorageKeys.notifPush, (v) => _push = v,
                    needPush: false),
                _item('Who Viewed My Profile', 'Get notified when someone looks you up',
                    _viewed, StorageKeys.notifViewed, (v) => _viewed = v),
                _item('New Tags', 'When someone adds a tag to your number',
                    _tags, StorageKeys.notifTags, (v) => _tags = v),
                _item('Chat Messages', 'New messages in your chats',
                    _chat, StorageKeys.notifChat, (v) => _chat = v),
                _item('Promotions', 'Offers and special events',
                    _promo, StorageKeys.notifPromo, (v) => _promo = v),
              ],
            ),
    );
  }
}
