import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/menu_storage_service.dart';
import 'widgets/menu_helpers.dart';

class _Call {
  final String name;
  final String number;
  final String time;
  final IconData icon;
  final bool missed;
  const _Call(this.name, this.number, this.time, this.icon,
      {this.missed = false});
}

const List<_Call> _calls = [
  _Call('Unknown', '+62 811-2345-6789', 'Just now', Icons.call_missed,
      missed: true),
  _Call('Andi', '+62 812-1111-2222', '10 minutes ago', Icons.call_received),
  _Call('Budi', '+62 813-3333-4444', '1 hour ago', Icons.call_made),
  _Call('Cica', '+62 857-5555-6666', 'Yesterday', Icons.call_received),
  _Call('Dedi', '+62 878-7777-8888', 'Yesterday', Icons.call_missed,
      missed: true),
];

class ShortcutsScreen extends StatefulWidget {
  const ShortcutsScreen({super.key});

  @override
  State<ShortcutsScreen> createState() => _ShortcutsScreenState();
}

class _ShortcutsScreenState extends State<ShortcutsScreen> {
  final _storage = MenuStorageService();
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();

  bool _loaded = false;
  bool _search = true;
  bool _copy = true;
  bool _block = true;
  bool _tag = true;
  bool _notifBar = true;

  final Set<String> _blocked = {};
  final Map<String, String> _tags = {}; // nomor -> tag
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final a = await _storage.getBool(StorageKeys.scSearch, true);
    final b = await _storage.getBool(StorageKeys.scCopy, true);
    final c = await _storage.getBool(StorageKeys.scBlock, true);
    final d = await _storage.getBool(StorageKeys.scTag, true);
    final e = await _storage.getBool(StorageKeys.scNotifBar, true);
    final blocked = await _storage.getStringList(StorageKeys.scBlocked) ?? [];
    final tagsRaw = await _storage.getStringList(StorageKeys.scTags) ?? [];

    final tags = <String, String>{};
    for (final raw in tagsRaw) {
      final i = raw.indexOf('|');
      if (i > 0) tags[raw.substring(0, i)] = raw.substring(i + 1);
    }

    if (!mounted) return;
    setState(() {
      _search = a;
      _copy = b;
      _block = c;
      _tag = d;
      _notifBar = e;
      _blocked
        ..clear()
        ..addAll(blocked);
      _tags
        ..clear()
        ..addAll(tags);
      _loaded = true;
    });
  }

  Future<void> _saveBlocked() =>
      _storage.setStringList(StorageKeys.scBlocked, _blocked.toList());

  Future<void> _saveTags() => _storage.setStringList(StorageKeys.scTags,
      _tags.entries.map((e) => '${e.key}|${e.value}').toList());


  Future<void> _copyNumber(String number) async {
    if (!_copy) {
      showSnack(context, 'Aktifkan Quick Copy Number dulu', error: true);
      return;
    }
    await Clipboard.setData(ClipboardData(text: number));
    if (mounted) showSnack(context, 'Nomor disalin: $number');
  }

  Future<void> _toggleBlock(_Call call) async {
    final nowBlocked = !_blocked.contains(call.number);
    setState(() {
      if (nowBlocked) {
        _blocked.add(call.number);
      } else {
        _blocked.remove(call.number);
      }
    });
    await _saveBlocked();
    if (mounted) {
      showSnack(
        context,
        nowBlocked
            ? '${call.number} diblokir'
            : 'Blokir ${call.number} dibuka',
      );
    }
  }

  Future<void> _simulateCallEnded() async {
    if (!_tag) {
      showSnack(context, 'Aktifkan Quick Tag dulu', error: true);
      return;
    }
    final call = _calls.first;
    final ctrl = TextEditingController(text: _tags[call.number] ?? '');

    final tag = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: kCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Call ended', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            Text(call.number,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Add a tag for this number?',
                style: TextStyle(color: Colors.white)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                for (final s in const [
                  'Penipuan',
                  'Telemarketing',
                  'Kurir',
                  'Teman'
                ])
                  ActionChip(
                    label: Text(s),
                    onPressed: () => ctrl.text = s,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              maxLength: 20,
              style: const TextStyle(color: Colors.white),
              decoration: _fieldDecoration('Tag'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Skip'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kAccent,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
                  child: const Text('Save tag'),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (tag == null || tag.isEmpty) return;
    setState(() => _tags[call.number] = tag);
    await _saveTags();
    if (mounted) showSnack(context, 'Tag "$tag" disimpan');
  }

  void _openSearchFromBar() {
    if (!_search) {
      showSnack(context, 'Aktifkan Quick Search dulu', error: true);
      return;
    }
    _searchFocus.requestFocus();
  }

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: kBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      );

  List<_Call> get _filtered {
    final q = _query.trim().toLowerCase();
    if (!_search || q.isEmpty) return _calls;
    final digits = q.replaceAll(RegExp(r'[^0-9]'), '');
    return _calls.where((c) {
      final nameMatch = c.name.toLowerCase().contains(q);
      final numberMatch = digits.isNotEmpty &&
          c.number.replaceAll(RegExp(r'[^0-9]'), '').contains(digits);
      return nameMatch || numberMatch;
    }).toList();
  }

  Widget _switchItem(String title, String sub, bool value, String key,
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

  Widget _sectionTitle(String text, {String? note}) => Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
            if (note != null)
              Text(note,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      );

  Widget _notificationBarPreview() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: const IconBadge(icon: Icons.search),
          title: const Text('Search numbers',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: const Text('GetContact · notification bar (preview)',
              style: TextStyle(color: Colors.grey, fontSize: 12)),
          trailing: TextButton(
            onPressed: _openSearchFromBar,
            child: const Text('Search'),
          ),
          onTap: _openSearchFromBar,
        ),
      ),
    );
  }

  Widget _callTile(_Call call) {
    final isBlocked = _blocked.contains(call.number);
    final tag = _tags[call.number];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          // Quick Copy Number: tekan lama
          onLongPress: () => _copyNumber(call.number),
          leading: CircleAvatar(
            backgroundColor: Colors.white10,
            child: Icon(call.icon,
                color: call.missed ? const Color(0xFFD64550) : Colors.white),
          ),
          title: Text(call.name,
              style: TextStyle(
                color: isBlocked ? Colors.grey : Colors.white,
                fontWeight: FontWeight.w600,
                decoration:
                    isBlocked ? TextDecoration.lineThrough : TextDecoration.none,
              )),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${call.number} · ${call.time}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              if (tag != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('Tag: $tag',
                      style: const TextStyle(color: kAccent, fontSize: 12)),
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isBlocked)
                const Text('Blocked',
                    style: TextStyle(color: Color(0xFFD64550), fontSize: 12)),
              // Quick Block: satu ketukan
              if (_block)
                IconButton(
                  tooltip: isBlocked ? 'Unblock' : 'Block',
                  icon: Icon(
                    isBlocked ? Icons.lock_open : Icons.block,
                    color: isBlocked ? Colors.grey : const Color(0xFFD64550),
                  ),
                  onPressed: () => _toggleBlock(call),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final calls = _filtered;

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
                _switchItem(
                    'Quick Search',
                    'Show a search box to find numbers quickly',
                    _search,
                    StorageKeys.scSearch,
                    (v) => _search = v),
                _switchItem(
                    'Quick Copy Number',
                    'Long-press a number to copy it',
                    _copy,
                    StorageKeys.scCopy,
                    (v) => _copy = v),
                _switchItem(
                    'Quick Block',
                    'Block a number with one tap from recent calls',
                    _block,
                    StorageKeys.scBlock,
                    (v) => _block = v),
                _switchItem(
                    'Quick Tag',
                    'Suggest adding a tag after a call ends',
                    _tag,
                    StorageKeys.scTag,
                    (v) => _tag = v),
                _switchItem(
                    'Notification Bar Shortcut',
                    'Show a search shortcut in the notification bar',
                    _notifBar,
                    StorageKeys.scNotifBar,
                    (v) => _notifBar = v),

                const SizedBox(height: 8),
                const Divider(height: 1, color: Colors.white12),
                const SizedBox(height: 12),

                _sectionTitle('Try your shortcuts',
                    note: 'Demo with sample recent calls.'),

                if (_notifBar) _notificationBarPreview(),

                if (_search)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      controller: _searchCtrl,
                      focusNode: _searchFocus,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (v) => setState(() => _query = v),
                      decoration:
                          _fieldDecoration('Search name or number').copyWith(
                        fillColor: kCard,
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.grey),
                      ),
                    ),
                  ),

                OutlinedButton.icon(
                  onPressed: _simulateCallEnded,
                  icon: const Icon(Icons.call_end,
                      color: Colors.white, size: 18),
                  label: const Text('Simulate call ended',
                      style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 12),

                if (calls.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Text('Nomor tidak ditemukan.',
                          style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                for (final c in calls) _callTile(c),
              ],
            ),
    );
  }
}