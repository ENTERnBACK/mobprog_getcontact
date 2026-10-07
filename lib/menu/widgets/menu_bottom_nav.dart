import 'package:flutter/material.dart';

import 'menu_helpers.dart';

class MenuBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MenuBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    (Icons.phone_outlined, 'Home'),
    (Icons.chat_bubble_outline, 'Chat'),
    (Icons.verified_user_outlined, 'Protection'),
    (Icons.menu, 'Menu'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Colors.white10)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final selected = i == currentIndex;
              final (icon, label) = _items[i];
              return InkWell(
                onTap: () => onTap(i),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 56,
                        height: 32,
                        decoration: BoxDecoration(
                          color: selected ? kAccent : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(icon,
                            size: 22,
                            color: selected ? Colors.white : Colors.grey),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 10,
                          color: selected ? Colors.white : Colors.grey,
                          fontWeight:
                              selected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
