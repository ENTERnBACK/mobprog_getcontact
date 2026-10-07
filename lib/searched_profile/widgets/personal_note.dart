import 'package:flutter/material.dart';

class PersonalNote extends StatefulWidget {
  const PersonalNote({super.key});

  @override
  State<PersonalNote> createState() => _PersonalNoteState();
}

class _PersonalNoteState extends State<PersonalNote> {
  String _noteText = 'Jangan diangkat, biasanya nawarin kartu kredit atau asuransi.';
  
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  // Fungsi dialog edit
  void _showEditDialog() {
    _noteController.text = _noteText;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Catatan'),
          content: TextField(
            controller: _noteController, 
            decoration: const InputDecoration(
              hintText: 'Tulis catatan untuk nomor ini...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _noteText = _noteController.text;
                });
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
                onPressed: _showEditDialog,
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _noteText.isEmpty ? 'Belum ada catatan. Tambahkan sekarang.' : _noteText,
            style: TextStyle(
              color: _noteText.isEmpty ? Colors.grey : Colors.black87, 
              height: 1.4,
              fontStyle: _noteText.isEmpty ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }
}