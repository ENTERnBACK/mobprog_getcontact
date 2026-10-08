import 'package:flutter/material.dart';
import '../chats/chats.dart';

class ContactDetailPage extends StatefulWidget {
  final String name;
  final String phone;

  const ContactDetailPage({
    super.key,
    required this.name,
    required this.phone,
  });

  @override
  State<ContactDetailPage> createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  final TextEditingController _tagController =
      TextEditingController();

  final List<String> _tags = [
    'Teman',
    'Kuliah',
  ];

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  // ======================================================
  // ADD TAG
  // ======================================================

  void _showAddTagDialog() {
    _tagController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),

          title: const Text(
            'Add Tag',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),

          content: TextField(
            controller: _tagController,
            autofocus: true,
            style: const TextStyle(
              color: Colors.white,
            ),

            decoration: InputDecoration(
              hintText: 'Masukkan tag...',
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.grey,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.blue,
                ),
              ),
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                final String newTag =
                    _tagController.text.trim();

                if (newTag.isEmpty) {
                  return;
                }

                if (_tags.contains(newTag)) {
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Tag sudah ada.',
                      ),
                    ),
                  );

                  return;
                }

                setState(() {
                  _tags.add(newTag);
                });

                Navigator.pop(context);
              },

              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // ======================================================
  // DELETE TAG
  // ======================================================

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // ======================================================
      // APP BAR
      // ======================================================

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },

          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),

        title: const Text(
          'Contact Detail',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ======================================================
      // BODY
      // ======================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 30),

            // ======================================================
            // FOTO
            // ======================================================

            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF333333),

              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 50,
              ),
            ),

            const SizedBox(height: 15),

            // ======================================================
            // NAMA
            // ======================================================

            Text(
              widget.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // ======================================================
            // NOMOR
            // ======================================================

            Text(
              widget.phone,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            // ======================================================
            // CALL
            // ======================================================

            Container(
              width: double.infinity,

              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),

              child: ListTile(
                leading: const Icon(
                  Icons.call,
                  color: Colors.white,
                ),

                title: const Text(
                  'Call',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                onTap: () {},
              ),
            ),

            const SizedBox(height: 12),

            // ======================================================
            // MESSAGE
            // ======================================================

            Container(
              width: double.infinity,

              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),

              child: ListTile(
                leading: const Icon(
                  Icons.message,
                  color: Colors.white,
                ),

                title: const Text(
                  'Message',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ChatScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),

            // ======================================================
            // TAGS
            // ======================================================

            const Align(
              alignment: Alignment.centerLeft,

              child: Text(
                'Tags',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ======================================================
            // TAG LIST
            // ======================================================

            Align(
              alignment: Alignment.centerLeft,

              child: Wrap(
                spacing: 8,
                runSpacing: 8,

                children: [
                  ..._tags.map(
                    (tag) {
                      return Chip(
                        label: Text(
                          tag,
                          style: const TextStyle(
                            color: Colors.black87,
                          ),
                        ),

                        deleteIcon: const Icon(
                          Icons.close,
                          size: 16,
                        ),

                        onDeleted: () {
                          _removeTag(tag);
                        },

                        backgroundColor:
                            Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                      );
                    },
                  ),

                  // ======================================================
                  // ADD TAG BUTTON
                  // ======================================================

                  ActionChip(
                    avatar: const Icon(
                      Icons.add,
                      size: 18,
                      color: Colors.white,
                    ),

                    label: const Text(
                      'Add Tag',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),

                    backgroundColor:
                        const Color(0xFF1E1E1E),

                    side: const BorderSide(
                      color: Colors.grey,
                    ),

                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8),
                    ),

                    onPressed: _showAddTagDialog,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}