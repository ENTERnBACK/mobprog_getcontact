import 'package:flutter/material.dart';

import '../chats/chats.dart'; // ChatScreen (Marsyha)
import '../home/searchbar.dart';
import '../profile.dart';
import 'protection_screen.dart';
import 'widgets/menu_bottom_nav.dart';
import 'widgets/menu_helpers.dart';

/// Kerangka dengan bottom nav yang menetap.
/// Urutan tab HARUS sama dengan urutan item di MenuBottomNav:
/// 0 = Home, 1 = Chat, 2 = Protection, 3 = Menu
class MenuShell extends StatefulWidget {
  final int initialIndex;

  const MenuShell({super.key, this.initialIndex = 0});

  @override
  State<MenuShell> createState() => _MenuShellState();
}

class _MenuShellState extends State<MenuShell> {
  late int _index = widget.initialIndex.clamp(0, _pages.length - 1);

  // Harus berisi tepat 4 halaman, urutannya = urutan tab.
  static const List<Widget> _pages = [
    ContactSearchPage(), // 0 Home  -> GANTI dengan HomeScreen() milik Amelia
    ChatScreen(), //        1 Chat  (Marsyha)
    ProtectionScreen(), //  2 Protection (Elizabeth)
    ProfileScreen(), //     3 Menu (Elizabeth)
  ];

  void _onNavTap(int index) {
    if (index != _index) setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    assert(_pages.length == 4, 'Jumlah halaman harus sama dengan jumlah tab (4)');
    return Scaffold(
      backgroundColor: kBg,
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: MenuBottomNav(currentIndex: _index, onTap: _onNavTap),
    );
  }
}

/// Pengganti sementara sampai halaman Home (Amelia) tersambung.
