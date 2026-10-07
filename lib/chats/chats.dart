import 'package:flutter/material.dart';

import 'chat_room_screen.dart';
import 'contact_store.dart';
import 'new_chat_screen.dart';
import 'widget/common.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 75,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey, width: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),

                  Container(
                    width: 62,
                    height: 55,
                    decoration: BoxDecoration(
                      color: kCard,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey.shade800),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  const Expanded(child: SizedBox()),

                  const Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: Text(
                      'Chats',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: AnimatedBuilder(
                      animation:
                          Listenable.merge([contacts, groups, chatHistory]),
                      builder: (context, _) {
                        final all = contacts.value;
                        final groupList = groups.value;
                        final history = chatHistory.value;

                        if (all.isEmpty && groupList.isEmpty) {
                          return _noActiveChat();
                        }

                        final entries = <_ChatEntry>[];
                        for (final key in history.keys.toList().reversed) {
                          final msgs = history[key]!;
                          if (msgs.isEmpty) continue;

                          final ci = all.indexWhere((c) => c.number == key);
                          if (ci != -1) {
                            entries.add(_ChatEntry(
                              title: all[ci].name,
                              id: key,
                              last: msgs.last,
                            ));
                            continue;
                          }

                          final gi = groupList.indexWhere((g) => g.id == key);
                          if (gi != -1) {
                            entries.add(_ChatEntry(
                              title: groupList[gi].name,
                              id: key,
                              last: msgs.last,
                              subtitle:
                                  '${groupList[gi].members.length} members',
                              isGroup: true,
                            ));
                          }
                        }

                        final chatted = entries.map((e) => e.id).toSet();
                        final suggestions = all
                            .where((c) => !chatted.contains(c.number))
                            .toList();

                        return Column(
                          children: [
                            if (suggestions.isNotEmpty)
                              _suggestions(context, suggestions),
                            if (entries.isNotEmpty && suggestions.isNotEmpty)
                              const SizedBox(height: 28),
                            if (entries.isNotEmpty)
                              _chatList(context, entries),
                          ],
                        );
                      },
                    ),
                  ),

                  const Positioned(
                    right: 28,
                    bottom: 25,
                    child: AddChatButton(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openEntry(BuildContext context, _ChatEntry e) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatRoomScreen(
          name: e.title,
          number: e.id,
          subtitle: e.subtitle,
        ),
      ),
    );
  }

  void _openContact(BuildContext context, Contact c) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatRoomScreen(name: c.name, number: c.number),
      ),
    );
  }

  Widget _noActiveChat() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.chat, color: Colors.blue, size: 50),
          const SizedBox(height: 20),
          const Text(
            'No active chat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.blue.shade900,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add, color: Colors.blue, size: 32),
              ),
              const SizedBox(width: 15),
              const Text(
                'You can start using this button.',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chatList(BuildContext context, List<_ChatEntry> entries) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          for (final e in entries)
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              leading: e.isGroup
                  ? Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900,
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.group, color: Colors.blue, size: 26),
                    )
                  : AppAvatar(name: e.title, size: 52),
              title: Text(
                e.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                e.last.text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              ),
              trailing: Text(
                formatTime(e.last.time),
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
              onTap: () => _openEntry(context, e),
            ),
        ],
      ),
    );
  }

  Widget _suggestions(BuildContext context, List<Contact> list) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chat Suggestions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, i) {
                final c = list[i];
                return GestureDetector(
                  onTap: () => _openContact(context, c),
                  child: SizedBox(
                    width: 64,
                    child: Column(
                      children: [
                        AppAvatar(name: c.name, size: 56),
                        const SizedBox(height: 6),
                        Text(
                          c.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatEntry {
  final String title;
  final String id;
  final Message last;
  final String? subtitle;
  final bool isGroup;
  const _ChatEntry({
    required this.title,
    required this.id,
    required this.last,
    this.subtitle,
    this.isGroup = false,
  });
}

class AddChatButton extends StatelessWidget {
  const AddChatButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: FloatingActionButton(
        backgroundColor: Colors.blue.shade900,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NewChatScreen()),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 50),
      ),
    );
  }
}