import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../services/image_service.dart';
import '../services/menu_storage_service.dart';
import 'widgets/menu_helpers.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _storage = MenuStorageService();
  final _imageService = ImageService();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final name = await _storage.getString(StorageKeys.name, '');
    final phone = await _storage.getString(StorageKeys.phone, '');
    final img = await _storage.getStringOrNull(StorageKeys.imagePath);
    if (!mounted) return;
    setState(() {
      _nameCtrl.text = name;
      _phoneCtrl.text = phone;
      _imagePath = img;
    });
  }

  Future<void> _pick(bool fromCamera) async {
    try {
      final path = fromCamera
          ? await _imageService.pickFromCamera()
          : await _imageService.pickFromGallery();
      if (path == null) {
        if (mounted) showSnack(context, 'Gagal menambahkan gambar.', error: true);
        return;
      }
      setState(() => _imagePath = path);
    } catch (e) {
      if (mounted) showSnack(context, 'Terjadi error: $e', error: true);
    }
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty || _phoneCtrl.text.trim().isEmpty) {
      showSnack(context, 'Nama dan nomor tidak boleh kosong', error: true);
      return;
    }
    await _storage.setString(StorageKeys.name, _nameCtrl.text.trim());
    await _storage.setString(StorageKeys.phone, _phoneCtrl.text.trim());
    if (_imagePath != null) {
      await _storage.setString(StorageKeys.imagePath, _imagePath!);
    }
    if (!mounted) return;
    showSnack(context, 'Profile berhasil disimpan!');
    Navigator.pop(context);
  }

  ImageProvider? get _avatar {
    if (kIsWeb || _imagePath == null) return null;
    final f = File(_imagePath!);
    return f.existsSync() ? FileImage(f) : null;
  }

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: kCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        foregroundColor: Colors.white,
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 64,
              backgroundColor: Colors.blueGrey,
              backgroundImage: _avatar,
              child: _avatar == null
                  ? const Icon(Icons.person, size: 64, color: Colors.white)
                  : null,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pick(true),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Kamera'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () => _pick(false),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galeri'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: _dec('Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: _dec('Phone Number'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _save,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}