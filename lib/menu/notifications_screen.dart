import 'package:flutter/material.dart';

import '../services/menu_storage_service.dart';
import 'widgets/menu_helpers.dart';

class _Notif {
  final int id;
  final String type;
  final IconData icon;
  final String title;
  final String body;
  final String time;
  bool read;

  _Notif({
    required this.id,
    required this.type,
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    this.read = false,
  });
}

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
  bool _promo = true;

  int _nextId = 100;
  final List<_Notif> _notifs = [
    _Notif(
        id: 1,
        type: 'protection',
        icon: Icons.phone_missed,
        title: 'Spam call blocked',
        body: 'A call from +62811xxxx was blocked automatically.',
        time: '2 minutes ago'),
    _Notif(
        id: 2,
        type: 'viewed',
        icon: Icons.visibility,
        title: 'Andi viewed your profile',
        body: 'Someone looked you up.',
        time: '10 minutes ago'),
    _Notif(
        id: 3,
        type: 'chat',
        icon: Icons.chat_bubble,
        title: 'New message from Budi',
        body: 'Hey, are you free today?',
        time: '1 hour ago'),
    _Notif(
        id: 4,
        type: 'tags',
        icon: Icons.sell,
        title: 'New tag added',
        body: 'Someone tagged your number as "Eliz".',
        time: '3 hours ago'),
    _Notif(
        id: 5,
        type: 'protection',
        icon: Icons.sms_outlined,
        title: 'Spam SMS filtered',
        body: '1 suspicious message was moved to spam.',
        time: 'Yesterday',
        read: true),
    _Notif(
        id: 6,
        type: 'chat',
        icon: Icons.chat_bubble,
        title: 'New message from Cica',
        body: 'Thanks for the help earlier!',
        time: 'Yesterday',
        read: true),
    _Notif(
        id: 7,
        type: 'viewed',
        icon: Icons.visibility,
        title: 'Dedi viewed your profile',
        body: 'Someone looked you up.',
        time: '2 days ago',
        read: true),
    _Notif(
        id: 8,
        type: 'promo',
        icon: Icons.cake,
        title: 'Birthday offer',
        body: 'Add your birthday to get special offers.',
        time: '3 days ago',
        read: true),
  ];

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
    final e = await _storage.getBool(StorageKeys.notifPromo, true);
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

  bool _allowed(_Notif n) {
    if (!_push) return false;
    switch (n.type) {
      case 'viewed':
        return _viewed;
      case 'tags':
        return _tags;
      case 'chat':
        return _chat;
      case 'promo':
        return _promo;
      default:
        return true;
    }
  }

  List<_Notif> get _visible => _notifs.where(_allowed).toList();

  void _sendTest() {
    if (!_push) {
      showSnack(context, 'Nyalakan Push Notifications dulu', error: true);
      return;
    }
    setState(() {
      _notifs.insert(
        0,
        _Notif(
          id: _nextId++,
          type: 'test',
          icon: Icons.notifications_active,
          title: 'Test notification',
          body: 'Ini notifikasi dummy untuk mencoba tampilan.',
          time: 'Just now',
        ),
      );
    });
    showSnack(context, 'Notifikasi dummy dikirim');
  }

  void _markAllRead() {
    setState(() {
      for (final n in _notifs) {
        n.read = true;
      }
    });
  }

  void _clearAll() {
    setState(() => _notifs.clear());
    showSnack(context, 'Semua notifikasi dihapus');
  }

  Widget _switchItem(String title, String sub, bool value, String key,
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

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 10),
        child: Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold)),
      );

  Widget _notifTile(_Notif n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: () => setState(() => n.read = true),
          leading: IconBadge(icon: n.icon),
          title: Text(
            n.title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: n.read ? FontWeight.w500 : FontWeight.bold,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text('${n.body}\n${n.time}',
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ),
          isThreeLine: true,
          trailing: n.read
              ? null
              : const CircleAvatar(radius: 5, backgroundColor: kAccent),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = _visible;

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        foregroundColor: Colors.white,
        title: const Text('Notifications'),
        actions: [
          IconButton(
            tooltip: 'Mark all as read',
            icon: const Icon(Icons.done_all),
            onPressed: _markAllRead,
          ),
          IconButton(
            tooltip: 'Clear all',
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: _clearAll,
          ),
        ],
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _sectionTitle('Settings'),
                _switchItem(
                    'Push Notifications',
                    'Enable or disable all notifications',
                    _push,
                    StorageKeys.notifPush,
                    (v) => _push = v,
                    needPush: false),
                _switchItem(
                    'Who Viewed My Profile',
                    'Get notified when someone looks you up',
                    _viewed,
                    StorageKeys.notifViewed,
                    (v) => _viewed = v),
                _switchItem('New Tags', 'When someone adds a tag to your number',
                    _tags, StorageKeys.notifTags, (v) => _tags = v),
                _switchItem('Chat Messages', 'New messages in your chats', _chat,
                    StorageKeys.notifChat, (v) => _chat = v),
                _switchItem('Promotions', 'Offers and special events', _promo,
                    StorageKeys.notifPromo, (v) => _promo = v),

                const SizedBox(height: 8),
                const Divider(height: 1, color: Colors.white12),
                const SizedBox(height: 12),

                _sectionTitle('Recent notifications'),
                OutlinedButton.icon(
                  onPressed: _sendTest,
                  icon: const Icon(Icons.send, color: Colors.white, size: 18),
                  label: const Text('Send test notification',
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 12),
                if (!_push)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text(
                        'Push notifications are turned off.\nNyalakan switch di atas.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else if (list.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text('Belum ada notifikasi.',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                for (final n in list) _notifTile(n),
              ],
            ),
    );
  }
}