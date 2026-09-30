import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 75,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.3,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 20),

                  // Search button
                  Container(
                    width: 62,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFF19181D),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.grey.shade800,
                      ),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        'SMS Messages',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.only(right: 30),
                    child: Text(
                      'Chats',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      children: [
                        // No active chat
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: const Color(0xFF19181D),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.chat,
                                color: Colors.blue,
                                size: 50,
                              ),

                              const SizedBox(height: 20),

                              const Text(
                                'No active chat',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 25),

                              Row(
                                children: [
                                  Container(
                                    width: 45,
                                    height: 45,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade900,
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.blue,
                                      size: 32,
                                    ),
                                  ),

                                  const SizedBox(width: 15),

                                  const Text(
                                    'You can start using this button.',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Chat Suggestions
                        Container(
                          width: double.infinity,
                          height: 180,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: const Color(0xFF19181D),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Chat Suggestions',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Floating Add Button
                  Positioned(
                    right: 28,
                    bottom: 25,
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: FloatingActionButton(
                        backgroundColor: Colors.blue.shade900,
                        onPressed: () {},
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Navigation
            Container(
              height: 90,
              decoration: const BoxDecoration(
                color: Color(0xFF19181D),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _bottomItem(
                    Icons.phone,
                    'Home',
                    false,
                  ),
                  _bottomItem(
                    Icons.chat_bubble,
                    'Chat',
                    true,
                  ),
                  _bottomItem(
                    Icons.shield,
                    'Protection',
                    false,
                  ),
                  _bottomItem(
                    Icons.menu,
                    'Menu',
                    false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _bottomItem(
    IconData icon,
    String title,
    bool selected,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: selected ? Colors.blue : Colors.grey,
          size: 28,
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(
            color: selected ? Colors.blue : Colors.grey,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}