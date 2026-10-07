import 'package:flutter/material.dart';

class CommentsSection extends StatelessWidget {
  final List<Map<String, String>> comments;

  const CommentsSection({super.key, required this.comments});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.comment_bank_outlined, color: Colors.blueAccent, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Komentar Komunitas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(
              '${comments.length} Komentar',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true, 
          physics: const NeverScrollableScrollPhysics(),
          itemCount: comments.length,
          separatorBuilder: (context, index) => Divider(color: Colors.grey.shade200),
          itemBuilder: (context, index) {
            final comment = comments[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Colors.blue.withValues(alpha: 0.1),
                foregroundColor: Colors.blueAccent,
                child: Text(
                  comment['name']![0], 
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                comment['name']!, 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  comment['text']!,
                  style: TextStyle(color: Colors.grey.shade700, height: 1.3),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}