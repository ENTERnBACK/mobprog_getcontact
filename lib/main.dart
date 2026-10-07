import 'package:flutter/material.dart';
import 'searchbar.dart'; 
import 'profile.dart';
import 'auth/login.dart';
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

      theme: ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MenuShell(),
      routes: {
        '/chats': (context) => const ChatScreen(),
        '/menu': (context) => const MenuShell(),
      },

    );
  }
}