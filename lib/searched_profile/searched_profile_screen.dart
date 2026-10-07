import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/profile_summary.dart';
import 'widgets/tags_section.dart';
import 'widgets/message_action.dart';
import 'widgets/personal_note.dart';
import 'widgets/comments_section.dart';
import 'widgets/rating_section.dart';

class SearchedProfileScreen extends StatefulWidget {
  final String phoneNumber;
  final String contactName;

  const SearchedProfileScreen({super.key, required this.phoneNumber, required this.contactName});

  @override
  State<SearchedProfileScreen> createState() => _SearchedProfileScreenState();
}

class _SearchedProfileScreenState extends State<SearchedProfileScreen> {
  bool _isSaved = false;
  bool _isBlocked = false;

  @override
  void initState() {
    super.initState();
    _loadBlockStatus();
  }

  Future<void> _loadBlockStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isBlocked = prefs.getBool('blocked_${widget.phoneNumber}') ?? false;
    });
  }

  Future<void> _toggleBlock() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isBlocked = !_isBlocked;
    });
    await prefs.setBool('blocked_${widget.phoneNumber}', _isBlocked);
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> dynamicComments = [];
    List<String> dynamicTags = [];
    double dynamicRating = 0.0;
    int dynamicReviews = 0;

    if (widget.contactName.toLowerCase() == 'budi') {
      dynamicComments = [
        {'name': 'Andi', 'text': 'Oh ini nomor Budi temen kampus.'},
        {'name': 'Anonim', 'text': 'Sering ngutang di kantin.'},
      ];
      dynamicTags = ['Teman Kampus', 'Tukang Ngutang'];
      dynamicRating = 4.2;
      dynamicReviews = 15;
    } else if (widget.contactName.toLowerCase() == 'caca') {
      dynamicComments = [
        {'name': 'Siti', 'text': 'Ini nomor Caca yang jualan kue.'},
      ];
      dynamicTags = ['Jualan Kue', 'Teman SMP'];
      dynamicRating = 4.8;
      dynamicReviews = 32;
    } else {
      dynamicComments = [
        {'name': 'Sistem', 'text': 'No comments available for this number.'},
      ];
      dynamicTags = ['New Contact'];
      dynamicRating = 0.0;
      dynamicReviews = 0;
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
              final String shareText = 'Check out this profile: ${widget.contactName} with the number ${widget.phoneNumber} on our app!';
              
              Share.share(shareText);
            },
          ),
          // Tombol Block/Unblock
          IconButton(
            icon: Icon(
              _isBlocked ? Icons.block : Icons.block_outlined,
              color: _isBlocked ? Colors.redAccent : Colors.grey.shade700,
            ),
            tooltip: _isBlocked ? 'Unblock' : 'Block Contact',
            onPressed: () {
              _toggleBlock(); 
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isBlocked ? 'Contact successfully unblocked' : 'Contact has been blocked'),
                  duration: const Duration(seconds: 2),
                ),
              );
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
              isBlocked: _isBlocked,
            ),
            RatingSection(
              phoneNumber: widget.phoneNumber,
              baseRating: dynamicRating,
              baseReviews: dynamicReviews,
            ),
            const SizedBox(height: 24),
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