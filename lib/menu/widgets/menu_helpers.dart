import 'package:flutter/material.dart';

const Color kBg = Colors.black;
const Color kCard = Color(0xFF1C1C1E);
const Color kAccent = Color(0xFF1E5BFF);

void showSnack(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: error ? Colors.red : Colors.green,
      duration: const Duration(seconds: 2),
    ),
  );
}

/// Baris menu dengan icon biru di kiri dan panah di kanan.
class MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const MenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: subtitle == null
            ? null
            : Text(subtitle!, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }
}

/// Switch dengan tampilan kartu gelap.
class SwitchCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SwitchCard({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        activeThumbColor: Colors.white,
        activeTrackColor: kAccent,
        title: Text(title,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
        subtitle: subtitle == null
            ? null
            : Text(subtitle!, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
