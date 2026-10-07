import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'widgets/profile_summary.dart';
import 'widgets/tags_section.dart';
import 'widgets/message_action.dart';
import 'widgets/personal_note.dart';
import 'widgets/comments_section.dart';

class SearchedProfileScreen extends StatefulWidget {
  final String phoneNumber;

  const SearchedProfileScreen({super.key, required this.phoneNumber});

  @override
  State<SearchedProfileScreen> createState() => _SearchedProfileScreenState();
}

class _SearchedProfileScreenState extends State<SearchedProfileScreen> {
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profil Nomor'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        actions: [
          // Tombol Save
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: _isSaved ? Colors.blueAccent : Colors.black,
            ),
            onPressed: () {
              setState(() {
                _isSaved = !_isSaved; 
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isSaved ? 'Kontak disimpan!' : 'Kontak dihapus dari simpanan.'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          
          // Tombol Share
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              final String shareText = 'Cek nomor ini: ${widget.phoneNumber} di aplikasi kita! Banyak yang tag dia sebagai Kurir Paket.';
              
              Share.share(shareText);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileSummary(
              phoneNumber: widget.phoneNumber, 
              primaryName: 'Kurir Paket JNT',
            ),
            const SizedBox(height: 24),
            const MessageAction(),
            const SizedBox(height: 24),
            const TagsSection(
              tags: ['Kurir Paket', 'Tukang Galon', 'Penipu', 'Sales Asuransi', 'Orang Baik'],
            ),
            const SizedBox(height: 24),
            PersonalNote(phoneNumber: widget.phoneNumber),
            const SizedBox(height: 24),
            const CommentsSection(),
          ],
        ),
      ),
    );
  }
}