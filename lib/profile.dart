import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'menu/account_settings_screen.dart';
import 'menu/birthday_screen.dart';
import 'menu/edit_profile_screen.dart';
import 'menu/notifications_screen.dart';
import 'menu/protection_screen.dart';
import 'menu/widgets/menu_bottom_nav.dart';
import 'menu/widgets/menu_helpers.dart';
import 'services/menu_storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final MenuStorageService _storage = MenuStorageService();

  static const int _tagCount = 19;

  String _name = 'Elizabeth';
  String _phone = '+62800xxxx';
  String? _imagePath;
  String? _birthday;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final name = await _storage.getString(StorageKeys.name, 'Elizabeth');
    final phone = await _storage.getString(StorageKeys.phone, '+62800xxxx');
    final img = await _storage.getStringOrNull(StorageKeys.imagePath);
    final bday = await _storage.getStringOrNull(StorageKeys.birthday);
    if (!mounted) return;
    setState(() {
      _name = name;
      _phone = phone;
      _imagePath = img;
      _birthday = bday;
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

  void _onNavTap(int index) {
    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/chats');
        break;
      case 3:
        break;
      default:
        showSnack(context, 'Halaman ini belum tersambung');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      bottomNavigationBar: MenuBottomNav(currentIndex: 3, onTap: _onNavTap),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _open(const EditProfileScreen()),
                child: CircleAvatar(
                  radius: 46,
                  backgroundColor: Colors.blueGrey,
                  backgroundImage: _avatar,
                  child: _avatar == null
                      ? const Icon(Icons.person, size: 54, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                _name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(_phone,
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: _QuickButton(
                      top: Text('#$_tagCount',
                          style: const TextStyle(
                              color: kAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      label: 'My Tags',
                      onTap: () => showSnack(
                          context, 'Terhubung ke halaman My Tags (Nabila)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickButton(
                      top: const Icon(Icons.auto_awesome,
                          color: kAccent, size: 20),
                      label: 'My Profile Summary',
                      onTap: () => showSnack(
                          context, 'Terhubung ke Profile Summary (Nabila)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Material(
                color: kCard,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  onTap: () => _open(const BirthdayScreen()),
                  leading: const IconBadge(icon: Icons.cake),
                  title: Text(
                    _birthday == null ? 'Add Your Birthday!' : 'Your Birthday',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    _birthday == null
                        ? 'Add your birthday for celebrations, congratulations, and gifts.'
                        : formatDate(DateTime.parse(_birthday!)),
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 12),

              MenuTile(
                icon: Icons.notifications,
                title: 'Notifications',
                onTap: () => _open(const NotificationsScreen()),
              ),
              MenuTile(
                icon: Icons.visibility,
                title: 'Who Viewed My Profile',
                onTap: () => showSnack(context, 'Fitur ini belum tersedia'),
              ),
              MenuTile(
                icon: Icons.grid_view_rounded,
                title: 'Shortcuts',
                onTap: () => showSnack(context, 'Fitur ini belum tersedia'),
              ),
              MenuTile(
                icon: Icons.sms_outlined,
                title: 'Spam SMS Protection',
                onTap: () => _open(const ProtectionScreen()),
              ),
              MenuTile(
                icon: Icons.phone_missed,
                title: 'Spam Call Settings',
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
  final Widget top;
  final String label;
  final VoidCallback onTap;

  const _QuickButton(
      {required this.top, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kCard,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              top,
              const SizedBox(height: 6),
              Text(label,
                  style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
