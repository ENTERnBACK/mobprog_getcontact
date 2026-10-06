import 'package:flutter/material.dart';

import '../services/menu_storage_service.dart';
import 'widgets/menu_helpers.dart';

String formatDate(DateTime d) {
  const months = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];
  return '${d.day} ${months[d.month - 1]} ${d.year}';
}

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  final _storage = MenuStorageService();
  DateTime? _date;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final saved = await _storage.getStringOrNull(StorageKeys.birthday);
    if (!mounted) return;
    setState(() => _date = saved == null ? null : DateTime.parse(saved));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (_date == null) {
      showSnack(context, 'Pilih tanggal lahir dulu', error: true);
      return;
    }
    await _storage.setString(
        StorageKeys.birthday, _date!.toIso8601String().split('T').first);
    if (!mounted) return;
    showSnack(context, 'Birthday berhasil disimpan!');
    Navigator.pop(context);
  }

  Future<void> _remove() async {
    await _storage.remove(StorageKeys.birthday);
    if (!mounted) return;
    showSnack(context, 'Birthday dihapus');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        foregroundColor: Colors.white,
        title: const Text('Birthday'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Icon(Icons.cake, size: 80, color: kAccent),
            const SizedBox(height: 12),
            const Text(
              'Add your birthday for celebrations, promotions and special offers.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
                        Material(
              color: kCard,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: _pickDate,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.white),
                      const SizedBox(width: 12),
                      Text(
                        _date == null ? 'Select date' : formatDate(_date!),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
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
            if (_date != null)
              TextButton(
                onPressed: _remove,
                child: const Text('Remove birthday',
                    style: TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
