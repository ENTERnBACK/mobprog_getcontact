import 'package:flutter/material.dart';

class PersonalNote extends StatelessWidget {
  const PersonalNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.edit_note, color: Colors.amber.shade800),
                  const SizedBox(width: 8),
                  Text(
                    'Catatan Pribadi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ],
              ),
              IconButton(
                constraints: const BoxConstraints(), 
                padding: EdgeInsets.zero,
                icon: Icon(Icons.edit, size: 20, color: Colors.amber.shade800),
                onPressed: () {
                },
              )
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Jangan diangkat, biasanya nawarin kartu kredit atau asuransi.',
            style: TextStyle(color: Colors.black87, height: 1.4),
          ),
        ],
      ),
    );
  }
}