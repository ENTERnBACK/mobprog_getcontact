import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TagsSection extends StatefulWidget {
  final String phoneNumber;
  final List<String> initialTags; // Tag bawaan dummy

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

  // Mengambil tag dari memori lokal berdasarkan nomor telepon
  Future<void> _loadTags() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTags = prefs.getStringList('tags_${widget.phoneNumber}');
    setState(() {
      // Jika belum ada tag yang disimpan, pakai tag awal (initialTags)
      _tags = savedTags ?? List.from(widget.initialTags);
      _isLoading = false;
    });
  }

  // Menyimpan tag baru
  Future<void> _addTag(String newTag) async {
    if (newTag.trim().isEmpty) return;
    
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tags.add(newTag.trim());
    });
    // Simpan list terbaru ke memori
    await prefs.setStringList('tags_${widget.phoneNumber}', _tags);
  }

  // Memunculkan dialog untuk mengetik tag baru
  void _showAddTagDialog() {
    final TextEditingController tagController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Penanda (Tag)'),
          content: TextField(
            controller: tagController,
            decoration: const InputDecoration(
              hintText: 'Contoh: Kurir, Teman, Penipu',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                _addTag(tagController.text);
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
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
              'Penanda (Tags)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Text(
              '${_tags.length} Tags',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8.0,
          runSpacing: 10.0,
          children: [
            // List Tag yang ada
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
            
            // Tombol "Tambah Tag"
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
                    Icon(Icons.add, size: 16, color: Colors.grey.shade700),
                    const SizedBox(width: 4),
                    Text('Tambah', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
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