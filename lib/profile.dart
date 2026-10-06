import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'menu/account_settings_screen.dart';
import 'menu/birthday_screen.dart';
import 'menu/edit_profile_screen.dart';
import 'menu/notifications_screen.dart';
import 'menu/protection_screen.dart';
import 'menu/widgets/menu_helpers.dart';
import 'services/menu_storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final MenuStorageService _storage = MenuStorageService();

  String _name = 'Elizabeth';
  String _phone = '+62 812-0000-0000';
  String? _imagePath;
  String? _birthday;
  bool _protectionOn = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final name = await _storage.getString(StorageKeys.name, 'Elizabeth');
    final phone =
        await _storage.getString(StorageKeys.phone, '+62 812-0000-0000');
    final img = await _storage.getStringOrNull(StorageKeys.imagePath);
    final bday = await _storage.getStringOrNull(StorageKeys.birthday);
    final prot = await _storage.getBool(StorageKeys.protectionOn, true);
    if (!mounted) return;
    setState(() {
      _name = name;
      _phone = phone;
      _imagePath = img;
      _birthday = bday;
      _protectionOn = prot;
    });
  }

  Future<void> _open(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    _load();
  }

  ImageProvider? get _avatar {
    if (kIsWeb || _imagePath == null) return null;
    final file = File(_imagePath!);
    return file.existsSync() ? FileImage(file) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _open(const EditProfileScreen()),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: Colors.blueGrey,
                      backgroundImage: _avatar,
                      child: _avatar == null
                          ? const Icon(Icons.person,
                              size: 54, color: Colors.white)
                          : null,
                    ),
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: kAccent,
                      child: Icon(Icons.edit, size: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(_name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(_phone, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _QuickButton(
                      icon: Icons.sell,
                      label: 'My Tags',
                      onTap: () => showSnack(context,
                          'Terhubung ke halaman My Tags (Nabila) nanti'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickButton(
                      icon: Icons.person_search,
                      label: 'My Profile Summary',
                      onTap: () => showSnack(context,
                          'Terhubung ke Profile Summary (Nabila) nanti'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: kCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  onTap: () => _open(const BirthdayScreen()),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: kAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.cake, color: Colors.white),
                  ),
                  title: Text(
                    _birthday == null ? 'Add Your Birthday!' : 'Your Birthday',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    _birthday == null
                        ? 'Add your birthday for celebrations, promotions and special offers.'
                        : formatDate(DateTime.parse(_birthday!)),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                ),
              ),

              MenuTile(
                icon: Icons.notifications,
                title: 'Notifications',
                onTap: () => _open(const NotificationsScreen()),
              ),
              MenuTile(
                icon: Icons.shield,
                title: 'Activated Protection',
                subtitle: _protectionOn ? 'Active' : 'Not active',
                onTap: () => _open(const ProtectionScreen()),
              ),
              MenuTile(
                icon: Icons.manage_accounts,
                title: 'Account Settings',
                onTap: () => _open(const AccountSettingsScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: kAccent),
            const SizedBox(height: 6),
            Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
