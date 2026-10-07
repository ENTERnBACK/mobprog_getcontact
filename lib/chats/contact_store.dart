import 'package:flutter/foundation.dart';

class Contact {
  final String name;
  final String number;
  const Contact({required this.name, required this.number});
}

final ValueNotifier<List<Contact>> contacts = ValueNotifier([]);