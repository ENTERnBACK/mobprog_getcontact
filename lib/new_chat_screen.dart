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
            AppHeader(
              title: 'New Chat',
              trailing: const Padding(
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
            _actionRow(Icons.mail, 'Invite to Getcontact', () {}),
            const SizedBox(height: 10),
            Container(height: 24, color: const Color(0xFF0C0C0E)),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Getcontact Contacts',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _contactTile('Bu Amelia sk', '+62 878-7865-2863'),
            _contactTile('Bu maretha SK', '+62 815-9954-099'),
            _contactTile('aca', '+62 881-8003-442'),
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

  static Widget _contactTile(String name, String number) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 28),
      leading: AppAvatar(name: name, size: 56),
      title: Text(name,
          style: const TextStyle(color: Colors.white, fontSize: 18)),
      subtitle: Text(number,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 15)),
    );
  }
}