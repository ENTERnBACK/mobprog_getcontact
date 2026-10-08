import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String? logoPath;
  final String title; 
  final String subtitle; 

  const AuthHeader({
    super.key,
    required this.title,
    this.logoPath,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (logoPath != null) ...[
          Image.asset(
            logoPath!,
            height: 80,
            width: 80,

            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.contacts,
              size: 80,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
      ],
    );
  }
}