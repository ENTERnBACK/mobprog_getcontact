import 'package:flutter/foundation.dart';

class Contact {
  final String name;
  final String number;
  const Contact({required this.name, required this.number});
}

// Daftar kontak yang sudah disimpan (kosong di awal)
final ValueNotifier<List<Contact>> contacts = ValueNotifier([]);

// Riwayat pesan per kontak, key = nomor telepon.
// Urutan key = urutan chat terakhir (yang paling baru ada di akhir).
final ValueNotifier<Map<String, List<String>>> chatHistory = ValueNotifier({});