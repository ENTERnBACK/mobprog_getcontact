import 'package:flutter/material.dart';

// 1. Buat model data kontak
class Contact {
  final String name;
  final String phone;

  Contact({required this.name, required this.phone});
}

class ContactSearchPage extends StatefulWidget {
  const ContactSearchPage({super.key});

  @override
  State<ContactSearchPage> createState() => _ContactSearchPageState();
}

class _ContactSearchPageState extends State<ContactSearchPage> {
  // 2. Dummy data kontak
  final List<Contact> allContacts = [
    Contact(name: 'Andi', phone: '08123456789'),
    Contact(name: 'Budi', phone: '08567891234'),
    Contact(name: 'Caca', phone: '08781234567'),
    Contact(name: 'Dedi', phone: '08987654321'),
  ];

  List<Contact> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    filteredContacts = allContacts;
  }

  // 3. Fungsi filter berdasarkan nama atau nomor
  void _runFilter(String keyword) {
    List<Contact> results = [];
    if (keyword.isEmpty) {
      results = allContacts;
    } else {
      results = allContacts
          .where((contact) =>
              contact.name.toLowerCase().contains(keyword.toLowerCase()) ||
              contact.phone.contains(keyword))
          .toList();
    }

    setState(() {
      filteredContacts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GetContact - Search')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                labelText: 'Cari nama atau nomor...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: filteredContacts.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = filteredContacts[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(contact.name[0]),
                          ),
                          title: Text(contact.name),
                          subtitle: Text(contact.phone),
                        );
                      },
                    )
                  : const Center(
                      child: Text('Kontak tidak ditemukan'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}