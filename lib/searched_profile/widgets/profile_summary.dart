import 'package:flutter/material.dart';

class ProfileSummary extends StatelessWidget {
  final String phoneNumber;
  final String primaryName;

const ProfileSummary({
  super.key,
  required this.phoneNumber,
  required this.primaryName,
});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 45,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(height: 16),
          Text(
            primaryName,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white), // Tambahkan warna putih
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            phoneNumber,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}