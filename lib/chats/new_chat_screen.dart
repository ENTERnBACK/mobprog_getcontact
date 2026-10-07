import 'package:flutter/material.dart';

import 'contact_form_screen.dart';
import 'widget/common.dart';

class NewChatScreen extends StatelessWidget {
  const NewChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(
              title: 'New Chat',
              trailing: Padding(
                padding: EdgeInsets.only(right: 24),
                child: Icon(Icons.search, color: Colors.white, size: 30),
              ),
            ),
            const SizedBox(height: 10),
            _actionRow(Icons.group, 'New Group', () {}),
            _actionRow(
              Icons.person_add,
              'New contact',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContactFormScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _actionRow(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue.shade900,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.blue, size: 28),
            ),
            const SizedBox(width: 16),
            Text(text,
                style: const TextStyle(color: Colors.blue, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}