import 'package:flutter/material.dart';

class TagsSection extends StatelessWidget {
  final List<String> tags;

  const TagsSection({super.key, required this.tags});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul Section
        Row(
          children: [
            const Icon(Icons.sell, color: Colors.blueAccent, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Penanda (Tags)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(
              '${tags.length} Tags',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // List Tag
        Wrap(
          spacing: 8.0, 
          runSpacing: 10.0, 
          children: tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.08), 
                borderRadius: BorderRadius.circular(20), 
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Text(
                '# $tag', 
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}