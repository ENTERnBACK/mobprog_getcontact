import 'package:flutter/material.dart';

import '../searched_profile/searched_profile_screen.dart';
import 'widgets/menu_helpers.dart';

class _Viewer {
  final String name;
  final String number;
  final String time;
  const _Viewer(this.name, this.number, this.time);
}

class WhoViewedScreen extends StatefulWidget {
  const WhoViewedScreen({super.key});

  @override
  State<WhoViewedScreen> createState() => _WhoViewedScreenState();
}

class _WhoViewedScreenState extends State<WhoViewedScreen> {
  List<_Viewer> _viewers = const [
    _Viewer('Andi', '081234567890', '5 minutes ago'),
    _Viewer('Budi', '085678912345', '32 minutes ago'),
    _Viewer('Caca', '087123456789', '2 hours ago'),
    _Viewer('Dedi', '089676543210', '5 hours ago'),
    _Viewer('Fajar', '081355577799', 'Yesterday'),
    _Viewer('Aerosol', '082144455566', 'Yesterday'),
    _Viewer('Nomor tidak dikenal', '081299988877', '3 days ago'),
  ];

  void _openProfile(_Viewer v) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchedProfileScreen(
          phoneNumber: v.number,
          contactName: v.name,
        ),
      ),
    );
  }

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
                        onTap: () => _openProfile(v),
                        leading: CircleAvatar(
                          backgroundColor: kAccent,
                          child: Text(v.name[0].toUpperCase(),
                              style: const TextStyle(color: Colors.white)),
                        ),
                        title: Text(v.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                        subtitle: Text('${v.number} · ${v.time}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12)),
                        trailing: const Icon(Icons.chevron_right,
                            color: Colors.grey),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}