import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'menu/account_settings_screen.dart';
import 'menu/birthday_screen.dart';
import 'menu/edit_profile_screen.dart';
import 'menu/notifications_screen.dart';
import 'menu/shortcuts_screen.dart';
import 'menu/who_viewed_screen.dart';
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
  String _phone = '+62800xxxx';
  String? _imagePath;
  String? _birthday;
  bool _copyEnabled = true;

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
    final copy = await _storage.getBool(StorageKeys.scCopy, true);
    if (!mounted) return;
    setState(() {
      _name = name;
      _phone = phone;
      _imagePath = img;
      _birthday = bday;
      _copyEnabled = copy;
    });
  }

  Future<void> _copyPhone() async {
    if (!_copyEnabled) {
      showSnack(context, 'Aktifkan Quick Copy Number di Shortcuts', error: true);
      return;
    }
    await Clipboard.setData(ClipboardData(text: _phone));
    if (mounted) showSnack(context, 'Nomor disalin: $_phone');
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
              GestureDetector(
                onLongPress: _copyPhone,
                child: Text(_phone,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ),
              const SizedBox(height: 20),

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
                onTap: () => _open(const WhoViewedScreen()),
              ),
              MenuTile(
                icon: Icons.grid_view_rounded,
                title: 'Shortcuts',
                onTap: () => _open(const ShortcutsScreen()),
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