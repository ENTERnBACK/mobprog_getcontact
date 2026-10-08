import 'package:flutter/material.dart';
import '../../chats/chat_room_screen.dart';

class MessageAction extends StatelessWidget {
  final String contactName;
  final String phoneNumber;
  final bool isBlocked;

  const MessageAction({
    super.key,
    required this.contactName,
    required this.phoneNumber,
    required this.isBlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Tombol Kirim Pesan
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isBlocked
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatRoomScreen(
                          name: contactName,
                          number: phoneNumber,
                        ),
                      ),
                    );
                  },
            icon: Icon(isBlocked ? Icons.block : Icons.chat_bubble_outline),
            label: Text(
              isBlocked ? 'Unblock' : 'Message',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade800, 
              disabledForegroundColor: Colors.grey.shade500,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
        
        const SizedBox(width: 12), 
        
        // Tombol Call
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isBlocked
                ? null
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('The call feature is not available.'),
                        backgroundColor: const Color(0xFF1E1E1E),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
            icon: const Icon(Icons.call),
            label: const Text(
              'Call',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, 
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade800, 
              disabledForegroundColor: Colors.grey.shade500,
              padding: const EdgeInsets.symmetric(vertical: 14), 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }
}