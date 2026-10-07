import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalNote extends StatefulWidget {
  final String phoneNumber; 

  const PersonalNote({super.key, required this.phoneNumber});

  @override
  State<PersonalNote> createState() => _PersonalNoteState();
}

class _PersonalNoteState extends State<PersonalNote> {
  String _noteText = ''; 
  final TextEditingController _noteController = TextEditingController();
  bool _isLoading = true; 

  @override
  void initState() {
    super.initState();
    _loadNote(); 
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadNote() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _noteText = prefs.getString('note_${widget.phoneNumber}') ?? '';
      _isLoading = false; 
    });
  }

  Future<void> _saveNote(String newNote) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('note_${widget.phoneNumber}', newNote);
    
    setState(() {
      _noteText = newNote;
    });
  }

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
                _saveNote(_noteController.text);
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
          _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
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