import 'package:flutter/material.dart';

import 'contact_store.dart';
import 'widget/common.dart';

class ChatRoomScreen extends StatefulWidget {
  final String name;
  final String number;
  const ChatRoomScreen({super.key, required this.name, required this.number});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _msg = TextEditingController();
  late final List<Message> _messages =
      List.of(chatHistory.value[widget.number] ?? []);

  String _replyFor(String text) {
    final t = text.toLowerCase();
    if (t.contains('halo') || t.contains('hai') || t.contains('hi')) {
      return 'Hai!';
    }
    if (t.contains('apa kabar')) return 'Baik, kamu gimana?';
    if (t.contains('makasih') || t.contains('terima kasih')) {
      return 'Sama-sama!';
    }
    return 'Oke 👍';
  }

  void _saveHistory() {
    final history = Map<String, List<Message>>.of(chatHistory.value);
    history.remove(widget.number);
    history[widget.number] = List.of(_messages);
    chatHistory.value = history;
  }

  void _send() {
    final t = _msg.text.trim();
    if (t.isEmpty) return;
    setState(() => _messages.add(Message(text: t, time: DateTime.now())));
    _msg.clear();
    _saveHistory();

    Future.delayed(const Duration(seconds: 1), () {
      _messages.add(Message(
        text: _replyFor(t),
        time: DateTime.now(),
        isMe: false,
      ));
      if (mounted) setState(() {});
      _saveHistory();
    });
  }

  @override
  void dispose() {
    _msg.dispose();
    super.dispose();
  }

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
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  AppAvatar(name: widget.name, size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600)),
                        Text(widget.number,
                            style: TextStyle(
                                color: Colors.grey.shade400, fontSize: 13)),
                      ],
                    ),
                  ),
                  const Icon(Icons.more_vert, color: Colors.white),
                  const SizedBox(width: 16),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(28),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: kCard,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Kontak tersimpan',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 16),
                        AppAvatar(name: widget.name, size: 80),
                        const SizedBox(height: 14),
                        Text(widget.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(widget.number,
                            style: TextStyle(
                                color: Colors.grey.shade400, fontSize: 16)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (final m in _messages)
                    Align(
                      alignment: m.isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.fromLTRB(18, 12, 14, 8),
                        decoration: BoxDecoration(
                          color: m.isMe
                              ? Colors.blue.shade900
                              : const Color(0xFF2A2A30),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: m.isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(m.text,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            const SizedBox(height: 4),
                            Text(
                              formatTime(m.time),
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              decoration: const BoxDecoration(color: kCard),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msg,
                      style: const TextStyle(color: Colors.white),
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade800),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                          color: Colors.blue, shape: BoxShape.circle),
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}