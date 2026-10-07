import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'widgets/profile_summary.dart';
import 'widgets/tags_section.dart';
import 'widgets/message_action.dart';
import 'widgets/personal_note.dart';
import 'widgets/comments_section.dart';

class SearchedProfileScreen extends StatefulWidget {
  final String phoneNumber;
  final String contactName;

  const SearchedProfileScreen({super.key, required this.phoneNumber, required this.contactName});

  @override
  State<SearchedProfileScreen> createState() => _SearchedProfileScreenState();
}

class _SearchedProfileScreenState extends State<SearchedProfileScreen> {
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> dynamicComments = [];
    List<String> dynamicTags = [];

    if (widget.contactName.toLowerCase() == 'budi') {
      dynamicComments = [
        {'name': 'Andi', 'text': 'Oh ini nomor Budi temen kampus.'},
        {'name': 'Anonim', 'text': 'Sering ngutang di kantin.'},
      ];
      dynamicTags = ['Teman Kampus', 'Tukang Ngutang'];
    } else if (widget.contactName.toLowerCase() == 'caca') {
      dynamicComments = [
        {'name': 'Siti', 'text': 'Ini nomor Caca yang jualan kue.'},
      ];
      dynamicTags = ['Jualan Kue', 'Teman SMP'];
    } else {
      dynamicComments = [
        {'name': 'Sistem', 'text': 'No comments available for this number.'},
      ];
      dynamicTags = ['Baru Dikenal'];
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile Number'),
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
                  content: Text(_isSaved ? 'Contact saved!' : 'Contact removed from saved.'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          
          // Tombol Share
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              final String shareText = 'Check out this number: ${widget.phoneNumber} on our app!';
              
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
              primaryName: widget.contactName,
            ),
            const SizedBox(height: 24),
            MessageAction(
              contactName: widget.contactName,
              phoneNumber: widget.phoneNumber,
            ),
            const SizedBox(height: 24),
            TagsSection(
              phoneNumber: widget.phoneNumber,
              initialTags: dynamicTags,
            ),
            const SizedBox(height: 24),
            PersonalNote(phoneNumber: widget.phoneNumber),
            const SizedBox(height: 24),
            CommentsSection(
              comments: dynamicComments,
            ),
          ],
        ),
      ),
    );
  }
}