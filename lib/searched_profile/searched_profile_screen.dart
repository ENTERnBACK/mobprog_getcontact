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

    String nama = widget.contactName.toLowerCase();

    if (nama == 'andi') {
      dynamicRating = 4.5;
      dynamicReviews = 24;
      dynamicTags = ['Teman SD', 'Suka Main Bola'];
      dynamicComments = [{'name': 'Budi', 'text': 'Andi jago futsal nih.'}];
    } else if (nama == 'caca') {
      dynamicRating = 4.8;
      dynamicReviews = 32;
      dynamicTags = ['Jualan Kue', 'Teman Kuliah'];
      dynamicComments = [{'name': 'Siti', 'text': 'Kuenya enak banget!'}];
    } else if (nama == 'fajar') {
      dynamicRating = 4.1;
      dynamicReviews = 18;
      dynamicTags = ['Anak Kos', 'Tukang Ngutang'];
      dynamicComments = [{'name': 'Anonim', 'text': 'Sering pinjem duit di kantin.'}];
    } else if (nama == 'budi') {
      dynamicRating = 4.2;
      dynamicReviews = 15;
      dynamicTags = ['Rajin', 'Teman Kampus'];
      dynamicComments = [{'name': 'Andi', 'text': 'Oh ini nomor Budi temen kampus.'}];
    } else if (nama == 'aerosol') {
      dynamicRating = 3.9;
      dynamicReviews = 8;
      dynamicTags = ['Toko Material', 'Suplier'];
      dynamicComments = [{'name': 'Pak RT', 'text': 'Toko Aerosol langganan cat.'}];
    } else if (nama == 'dedi') {
      dynamicRating = 4.7;
      dynamicReviews = 50;
      dynamicTags = ['Bos Besar', 'Client'];
      dynamicComments = [{'name': 'Staff', 'text': 'Nomor Pak Dedi, mohon sopan.'}];
    } else {
      dynamicRating = 0.0;
      dynamicReviews = 0;
      dynamicTags = ['Baru Dikenal'];
      dynamicComments = [{'name': 'Sistem', 'text': 'Belum ada komentar untuk nomor ini.'}];
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Profile Details'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0.5,
        actions: [
          // Tombol Save
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: _isSaved ? Colors.blueAccent : Colors.white,
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
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () {
              final String shareText = 'Check out this profile: ${widget.contactName} with the number ${widget.phoneNumber} on our app!';
              
              Share.share(shareText);
            },
          ),
          // Tombol Block/Unblock
          IconButton(
            icon: Icon(
              _isBlocked ? Icons.block : Icons.block_outlined,
              color: _isBlocked ? Colors.redAccent : Colors.white,
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