import 'package:flutter/material.dart';

import '../login.dart';
import '../services/menu_storage_service.dart';
import '../services/url_service.dart';
import 'widgets/menu_helpers.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _storage = MenuStorageService();
  final _urlService = UrlService();

  String _email = '-';
  String _phone = '-';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final email = await _storage.getString(StorageKeys.email, 'Belum diatur');
    final phone = await _storage.getString(StorageKeys.phone, '-');
    if (!mounted) return;
    setState(() {
      _email = email;
      _phone = phone;
    });
  }

  void _goToLogin() {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }

  Future<void> _editEmail() async {
    final ctrl =
        TextEditingController(text: _email == 'Belum diatur' ? '' : _email);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ubah Email'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'nama@email.com'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
              child: const Text('Simpan')),
        ],
      ),
    );
    if (result == null) return;
    if (!result.contains('@') || !result.contains('.')) {
      if (mounted) showSnack(context, 'Format email tidak valid', error: true);
      return;
    }
    await _storage.setString(StorageKeys.email, result);
    _load();
    if (mounted) showSnack(context, 'Email berhasil diubah!');
  }

  Future<void> _changePassword() async {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    String? error;

    // true = password disembunyikan
    bool hideOld = true;
    bool hideNew = true;
    bool hideConfirm = true;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) {
          Widget field(String label, TextEditingController c, bool hidden,
              VoidCallback toggle) {
            return TextField(
              controller: c,
              obscureText: hidden,
              decoration: InputDecoration(
                labelText: label,
                suffixIcon: IconButton(
                  tooltip: hidden ? 'Lihat password' : 'Sembunyikan password',
                  icon: Icon(
                      hidden ? Icons.visibility : Icons.visibility_off),
                  onPressed: toggle,
                ),
              ),
            );
          }

          return AlertDialog(
            title: const Text('Ubah Password'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  field('Password lama', oldCtrl, hideOld,
                      () => setLocal(() => hideOld = !hideOld)),
                  field('Password baru', newCtrl, hideNew,
                      () => setLocal(() => hideNew = !hideNew)),
                  field('Konfirmasi password', confirmCtrl, hideConfirm,
                      () => setLocal(() => hideConfirm = !hideConfirm)),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(error!,
                          style: const TextStyle(color: Colors.red)),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal')),
              TextButton(
                onPressed: () {
                  if (oldCtrl.text.isEmpty) {
                    setLocal(() => error = 'Password lama wajib diisi');
                  } else if (newCtrl.text.length < 6) {
                    setLocal(() => error = 'Password baru minimal 6 karakter');
                  } else if (newCtrl.text != confirmCtrl.text) {
                    setLocal(() => error = 'Konfirmasi password tidak cocok');
                  } else {
                    // TODO: sambungkan ke sistem login (Fui) bila sudah ada auth
                    Navigator.pop(ctx);
                    showSnack(context, 'Password berhasil diubah!');
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openPrivacy() async {
    try {
      await _urlService.openUrl('https://www.getcontact.com');
    } catch (e) {
      if (mounted) showSnack(context, 'Gagal membuka link: $e', error: true);
    }
  }

  Future<bool> _confirm(String title, String message, String action) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(action, style: const TextStyle(color: Colors.red))),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<void> _logout() async {
    if (!await _confirm('Log Out', 'Yakin ingin keluar?', 'Log Out')) return;
    // TODO: hapus sesi login milik Fui di sini (kalau sudah ada)
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    _goToLogin();
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Berhasil log out'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _deleteAccount() async {
    if (!await _confirm(
      'Hapus Akun',
      'Semua data (profile, birthday, pengaturan) akan dihapus dari perangkat ini.',
      'Hapus',
    )) {
      return;
    }
    await _storage.clearAll();
    if (!mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    _goToLogin();
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Akun berhasil dihapus'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        foregroundColor: Colors.white,
        title: const Text('Account Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          MenuTile(
            icon: Icons.phone,
            title: 'Phone Number',
            subtitle: _phone,
            onTap: () => showSnack(
                context, 'Ubah nomor lewat Edit Profile (ketuk foto profil)'),
          ),
          MenuTile(
            icon: Icons.email,
            title: 'Email',
            subtitle: _email,
            onTap: _editEmail,
          ),
          MenuTile(
            icon: Icons.lock,
            title: 'Change Password',
            onTap: _changePassword,
          ),
          MenuTile(
            icon: Icons.privacy_tip,
            title: 'Privacy Policy',
            onTap: _openPrivacy,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _logout,
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _deleteAccount,
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            label: const Text('Delete Account',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}