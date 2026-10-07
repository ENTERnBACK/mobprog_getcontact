import 'package:flutter/material.dart';
import 'widgets/profile_summary.dart';
import 'widgets/tags_section.dart';
import 'widgets/message_action.dart';

class SearchedProfileScreen extends StatelessWidget {
  final String phoneNumber;

  const SearchedProfileScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profil Nomor'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, 
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileSummary(
              phoneNumber: phoneNumber,
              primaryName: 'Kurir Paket JNT',
            ),
            
            const SizedBox(height: 24),
            const MessageAction(),
            
            const SizedBox(height: 24),
            const TagsSection(
              tags: ['Kurir Paket', 'Tukang Galon', 'Penipu', 'Sales Asuransi', 'Orang Baik'],
            ),
            
            const SizedBox(height: 24),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}