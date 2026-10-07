import 'package:flutter/material.dart';

import 'widgets/menu_helpers.dart';

class _Viewer {
  final String name;
  final String time;
  const _Viewer(this.name, this.time);
}

class WhoViewedScreen extends StatefulWidget {
  const WhoViewedScreen({super.key});

  @override
  State<WhoViewedScreen> createState() => _WhoViewedScreenState();
}

class _WhoViewedScreenState extends State<WhoViewedScreen> {
  List<_Viewer> _viewers = const [
    _Viewer('Andi', '5 minutes ago'),
    _Viewer('Budi', '32 minutes ago'),
    _Viewer('Cica', '2 hours ago'),
    _Viewer('Dedi', '5 hours ago'),
    _Viewer('Nomor tidak dikenal (+62812xxxx)', 'Yesterday'),
    _Viewer('Sari', 'Yesterday'),
    _Viewer('Rina', '3 days ago'),
  ];

  Future<void> _clear() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Riwayat'),
        content: const Text('Hapus semua riwayat yang melihat profilmu?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Hapus', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (ok == true) {
      setState(() => _viewers = []);
      if (mounted) showSnack(context, 'Riwayat dihapus');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        foregroundColor: Colors.white,
        title: const Text('Who Viewed My Profile'),
        actions: [
          if (_viewers.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clear,
            ),
        ],
      ),
      body: _viewers.isEmpty
          ? const Center(
              child: Text('Belum ada yang melihat profilmu.',
                  style: TextStyle(color: Colors.grey)),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('${_viewers.length} people viewed your profile recently',
                    style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 12),
                for (final v in _viewers)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Material(
                      color: kCard,
                      borderRadius: BorderRadius.circular(16),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: kAccent,
                          child: Text(v.name[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white)),
                        ),
                        title: Text(v.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                        subtitle: Text(v.time,
                            style: const TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
