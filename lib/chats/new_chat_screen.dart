import 'package:flutter/material.dart';

import 'chat_room_screen.dart';
import 'contact_form_screen.dart';
import 'contact_store.dart';
import 'new_group_screen.dart';
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
            _actionRow(
              Icons.group,
              'New Group',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NewGroupScreen()),
              ),
            ),
            _actionRow(
              Icons.person_add,
              'New contact',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContactFormScreen()),
              ),
            ),

            Expanded(
              child: AnimatedBuilder(
                animation: Listenable.merge([contacts, groups]),
                builder: (context, _) {
                  final list = contacts.value;
                  final groupList = groups.value;
                  if (list.isEmpty && groupList.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return ListView(
                    children: [
                      const SizedBox(height: 10),

                      if (list.isNotEmpty) ...[
                        Container(height: 24, color: const Color(0xFF0C0C0E)),
                        _sectionTitle('Getcontact Contacts'),
                        for (final c in list)
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 28),
                            leading: AppAvatar(name: c.name, size: 56),
                            title: Text(
                              c.name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                            subtitle: Text(
                              c.number,
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 15),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatRoomScreen(
                                  name: c.name,
                                  number: c.number,
                                ),
                              ),
                            ),
                          ),
                      ],

                      if (groupList.isNotEmpty) ...[
                        Container(height: 24, color: const Color(0xFF0C0C0E)),
                        _sectionTitle('Groups'),
                        for (final g in groupList)
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 28),
                            leading: _groupAvatar(56),
                            title: Text(
                              g.name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                            subtitle: Text(
                              '${g.members.length} members',
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 15),
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatRoomScreen(
                                  name: g.name,
                                  number: g.id,
                                  subtitle: '${g.members.length} members',
                                ),
                              ),
                            ),
                          ),
                      ],
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 12),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Widget _groupAvatar(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.blue.shade900,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.group, color: Colors.blue, size: size * 0.5),
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