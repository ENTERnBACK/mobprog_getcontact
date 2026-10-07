import 'package:flutter/material.dart';

import '../profile.dart';
import 'protection_screen.dart';
import 'widgets/menu_bottom_nav.dart';
import 'widgets/menu_helpers.dart';

class MenuShell extends StatefulWidget {
  final int initialIndex;

  const MenuShell({super.key, this.initialIndex = 3});

  @override
  State<MenuShell> createState() => _MenuShellState();
}

class _MenuShellState extends State<MenuShell> {
  late int _index = widget.initialIndex;

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        showSnack(context, 'Halaman Home belum tersambung');
        break;
      case 1:
        Navigator.pushNamed(context, '/chats');
        break;
      default:
        if (index != _index) setState(() => _index = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: IndexedStack(
        index: _index == 2 ? 0 : 1,
        children: const [
          ProtectionScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: MenuBottomNav(currentIndex: _index, onTap: _onNavTap),
    );
  }
}