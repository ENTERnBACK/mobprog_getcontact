import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  final String title; 
  final String subtitle; 
  final String? logoPath;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.logoPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        if (logoPath != null) ...[
          Image.asset(
            logoPath!,
            width: 96,
            height: 96,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.contacts,
              size: 96,
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