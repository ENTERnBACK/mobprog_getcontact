import 'package:flutter/material.dart';
import 'searchbar.dart'; 
import 'profile.dart';

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
      theme: ThemeData(
        // Perbaikan: tambahkan ColorScheme.fromSeed
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ContactSearchPage(),
    );
  }
}