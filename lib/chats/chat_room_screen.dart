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
  late final List<String> _messages =
      List.of(chatHistory.value[widget.number] ?? []);

  void _send() {
    final t = _msg.text.trim();
    if (t.isEmpty) return;
    setState(() => _messages.add(t));
    _msg.clear();

    // Simpan ke riwayat, dan pindahkan chat ini jadi yang terbaru
    final history = Map<String, List<String>>.of(chatHistory.value);
    history.remove(widget.number);
    history[widget.number] = List.of(_messages);
    chatHistory.value = history;
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
            // Header profil
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

            // Isi chat
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(28),
                children: [
                  // Kartu profil tersimpan
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
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(m,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 17)),
                      ),
                    ),
                ],
              ),
            ),

            // Input pesan
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