import 'package:flutter/foundation.dart';

class Contact {
  final String name;
  final String number;
  const Contact({required this.name, required this.number});
}

class Message {
  final String text;
  final DateTime time;
  const Message({required this.text, required this.time});
}

String formatTime(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

final ValueNotifier<List<Contact>> contacts = ValueNotifier([]);

final ValueNotifier<Map<String, List<Message>>> chatHistory =
    ValueNotifier({});