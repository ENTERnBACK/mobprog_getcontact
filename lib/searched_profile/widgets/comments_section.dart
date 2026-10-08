import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CommentsSection extends StatefulWidget {
  final String phoneNumber; 
  final List<Map<String, String>> comments;
  
  const CommentsSection({super.key, required this.phoneNumber, required this.comments});

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  List<Map<String, String>> _localComments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedCommentsJson = prefs.getString('saved_comments_${widget.phoneNumber}');
    
    List<Map<String, String>> userSavedComments = [];
    if (savedCommentsJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(savedCommentsJson);
        userSavedComments = decoded.map((item) => Map<String, String>.from(item)).toList();
      } catch (e) {
        debugPrint('Failed to load comments: $e');
      }
    }

    setState(() {
      _localComments = [...userSavedComments, ...widget.comments];
      _isLoading = false;
    });
  }

  Future<void> _saveNewComment(String text) async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedCommentsJson = prefs.getString('saved_comments_${widget.phoneNumber}');
    
    List<Map<String, String>> userSavedComments = [];
    if (savedCommentsJson != null) {
      try {
        final List<dynamic> decoded = jsonDecode(savedCommentsJson);
        userSavedComments = decoded.map((item) => Map<String, String>.from(item)).toList();
      } catch (e) {
        debugPrint('Failed to load comments: $e');
      }
    }

    final newComment = {'name': 'Anda', 'text': text};
    userSavedComments.insert(0, newComment); 

    await prefs.setString('saved_comments_${widget.phoneNumber}', jsonEncode(userSavedComments));

    setState(() {
      _localComments.insert(0, newComment);
    });
  }

  void _showAddCommentDialog() {
    final TextEditingController commentController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E), 
          title: const Text('Add a Comment', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: commentController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Share info about this number...',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade700),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (commentController.text.trim().isNotEmpty) {
                  _saveNewComment(commentController.text.trim());
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Post'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.comment_bank_outlined, color: Colors.blueAccent, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Comments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const Spacer(),
            Text(
              '${_localComments.length} Comments',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _showAddCommentDialog,
              child: const Icon(Icons.add_comment, color: Colors.blueAccent, size: 22),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _localComments.isEmpty
            ? Text(
                'No comments yet. Be the first to comment!',
                style: TextStyle(color: Colors.grey.shade500, fontStyle: FontStyle.italic),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _localComments.length,
                separatorBuilder: (context, index) => Divider(color: Colors.grey.shade800),
                itemBuilder: (context, index) {
                  final comment = _localComments[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.withValues(alpha: 0.1),
                      foregroundColor: Colors.blueAccent,
                      child: Text(
                        comment['name']![0].toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      comment['name']!,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        comment['text']!,
                        style: TextStyle(color: Colors.grey.shade400, height: 1.3),
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}