import 'package:flutter/material.dart';

import 'chat_room_screen.dart';
import 'contact_store.dart';
import 'widget/common.dart';

class NewGroupScreen extends StatefulWidget {
  const NewGroupScreen({super.key});

  @override
  State<NewGroupScreen> createState() => _NewGroupScreenState();
}

class _NewGroupScreenState extends State<NewGroupScreen> {
  final _name = TextEditingController();
  final Set<String> _selected = {}; 

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _create() {
    final name = _name.text.trim();

    String? warning;
    if (name.isEmpty && _selected.isEmpty) {
      warning = 'Please input group name and choose at least one contact';
    } else if (name.isEmpty) {
      warning = 'Please input group name';
    } else if (_selected.isEmpty) {
      warning = 'Please choose at least one contact';
    }

    if (warning != null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(warning)),
      );
      return;
    }

    final id = 'group_${DateTime.now().millisecondsSinceEpoch}';
    groups.value = [
      ...groups.value,
      Group(id: id, name: name, members: _selected.toList()),
    ];

    final nav = Navigator.of(context);
    nav.popUntil((route) => route.isFirst);
    nav.push(
      MaterialPageRoute(
        builder: (_) => ChatRoomScreen(
          name: name,
          number: id,
          subtitle: '${_selected.length} members',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = contacts.value;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(
              title: 'New Group',
              trailing: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: _create,
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

            // Nama grup
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 8),
              child: TextField(
                controller: _name,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Group Name *',
                  hintStyle:
                      TextStyle(color: Colors.grey.shade500, fontSize: 18),
                  filled: true,
                  fillColor: kCard,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 24),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide(color: Colors.grey.shade800),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Choose contacts (${_selected.length} selected)',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Daftar kontak
            Expanded(
              child: list.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(28),
                        child: Text(
                          'Belum ada kontak.\nTambah kontak dulu lewat New contact.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 16),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        final c = list[i];
                        final on = _selected.contains(c.number);
                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 28),
                          leading: AppAvatar(name: c.name, size: 52),
                          title: Text(
                            c.name,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                          subtitle: Text(
                            c.number,
                            style: TextStyle(
                                color: Colors.grey.shade400, fontSize: 14),
                          ),
                          trailing: Icon(
                            on ? Icons.check_circle : Icons.circle_outlined,
                            color: on ? Colors.blue : Colors.grey,
                            size: 28,
                          ),
                          onTap: () => setState(() {
                            if (on) {
                              _selected.remove(c.number);
                            } else {
                              _selected.add(c.number);
                            }
                          }),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}