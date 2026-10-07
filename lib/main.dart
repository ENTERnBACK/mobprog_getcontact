import 'package:flutter/material.dart';
import 'searchbar.dart'; 
import 'profile.dart';
import 'login.dart';
import 'chats/chats.dart';
import 'menu/main_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GetContact',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WelcomeScreen(),
      routes: {
        '/chats': (context) => const ChatScreen(),
        '/menu': (context) => const MenuShell(),
      },

    );
  }
}

