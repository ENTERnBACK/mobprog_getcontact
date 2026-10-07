import 'package:flutter/material.dart';
import 'chat_room_screen.dart';
import 'contact_store.dart';
import 'widget/common.dart';

class ContactFormScreen extends StatefulWidget {
  const ContactFormScreen({super.key});

  @override
  State<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends State<ContactFormScreen> {
  final _first = TextEditingController();
  final _last = TextEditingController();
  final _phone = TextEditingController();

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _save() {
    final name = '${_first.text.trim()} ${_last.text.trim()}'.trim();
    if (name.isEmpty || _phone.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi nama dan nomor dulu')),
      );
      return;
    }
    contacts.value = [
      ...contacts.value,
      Contact(name: name, number: _phone.text.trim()),
    ];
    final nav = Navigator.of(context);
    nav.popUntil((route) => route.isFirst);
    nav.push(
      MaterialPageRoute(
        builder: (_) =>
            ChatRoomScreen(name: name, number: _phone.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'New Contact',
              trailing: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: _save,
                  child: Container(
                    width: 70,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(23),
                    ),
                    child: const Icon(Icons.check, color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 110,
                      height: 110,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2F3345),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person,
                          color: Colors.white, size: 60),
                    ),
                    const SizedBox(height: 32),
                    _field(_first, 'First Name'),
                    const SizedBox(height: 22),
                    _field(_last, 'Last Name'),
                    const SizedBox(height: 22),
                    _field(_phone, 'Phone Number (Mobile)',
                        type: TextInputType.phone),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint,
      {TextInputType type = TextInputType.text}) {
    return TextField(
      controller: c,
      keyboardType: type,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 18),
        filled: true,
        fillColor: kCard,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: BorderSide(color: Colors.grey.shade800),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}