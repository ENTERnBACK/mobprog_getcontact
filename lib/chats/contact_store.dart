import 'package:flutter/foundation.dart';

class Contact {
  final String name;
  final String number;
  const Contact({required this.name, required this.number});
}

class Group {
  final String id; 
  final String name;
  final List<String> members; 
  const Group({required this.id, required this.name, required this.members});
}

class Message {
  final String text;
  final DateTime time;
  final bool isMe;
  const Message({required this.text, required this.time, this.isMe = true});
}

String formatTime(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

final ValueNotifier<List<Contact>> contacts = ValueNotifier([]);

final ValueNotifier<List<Group>> groups = ValueNotifier([]);

final ValueNotifier<Map<String, List<Message>>> chatHistory =
    ValueNotifier({});