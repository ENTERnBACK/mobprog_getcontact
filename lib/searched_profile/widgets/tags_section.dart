import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TagsSection extends StatefulWidget {
  final String phoneNumber;
  final List<String> initialTags; 

  const TagsSection({
    super.key, 
    required this.phoneNumber, 
    required this.initialTags
  });

  @override
  State<TagsSection> createState() => _TagsSectionState();
}

class _TagsSectionState extends State<TagsSection> {
  List<String> _tags = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTags();
  }

  Future<void> _loadTags() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTags = prefs.getStringList('tags_${widget.phoneNumber}');
    setState(() {
      _tags = savedTags ?? List.from(widget.initialTags);
      _isLoading = false;
    });
  }

  Future<void> _addTag(String newTag) async {
    if (newTag.trim().isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tags.add(newTag.trim());
    });
    await prefs.setStringList('tags_${widget.phoneNumber}', _tags);
  }

  void _showAddTagDialog() {
    final TextEditingController tagController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Tag'),
          content: TextField(
            controller: tagController,
            decoration: const InputDecoration(
              hintText: 'Example: Kurir, Teman, Penipu',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                _addTag(tagController.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const CircularProgressIndicator();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.sell, color: Colors.blueAccent, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Tags',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
            ),
            const Spacer(),
            Text(
              '${_tags.length} Tags',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8.0,
          runSpacing: 10.0,
          children: [
            ..._tags.map((tag) {
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
            }),
            
            GestureDetector(
              onTap: _showAddTagDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, size: 16, color: Colors.grey.shade300),
                     const SizedBox(width: 4),
                     Text('Add Tag', style: TextStyle(color: Colors.grey.shade300, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}