import 'package:flutter/material.dart';

class WhoViewedMyProfile extends StatelessWidget {
  const WhoViewedMyProfile({super.key});

  // ======================================================
  // DATA WHO VIEWED MY PROFILE
  // ======================================================

  static const List<Map<String, String>> viewers = [
    {
      'name': 'Caca',
      'phone': '08818003442',
      'time': '5 minutes ago',
    },
    {
      'name': 'Budi',
      'phone': '08567891234',
      'time': '20 minutes ago',
    },
    {
      'name': 'Fajar',
      'phone': '082112345678',
      'time': '1 hour ago',
    },
    {
      'name': 'Aerosol',
      'phone': '08123456789',
      'time': '2 hours ago',
    },
    {
      'name': 'Dedi',
      'phone': '08987654321',
      'time': 'Yesterday',
    },

    // NOMOR TIDAK DIKENAL DI PALING BAWAH
    {
      'name': 'Unknown Number',
      'phone': '081234567890',
      'time': 'Yesterday',
    },
    {
      'name': 'Unknown Number',
      'phone': '089876543210',
      'time': '2 days ago',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AllProfileViewersPage(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade800,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================================================
            // HEADER
            // ======================================================

            Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.visibility_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Who Viewed My Profile',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'See who recently viewed your profile',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 16,
                ),
              ],
            ),

            const SizedBox(height: 18),

            // ======================================================
            // 3 VIEWER TERBARU
            // ======================================================

            ...viewers.take(3).map(
              (viewer) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xFF333333),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              viewer['name']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              viewer['phone']!,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Text(
                        viewer['time']!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 3),

            // ======================================================
            // TOTAL VIEWERS
            // ======================================================

            Text(
              '${viewers.length} people viewed your profile',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================
// ALL PROFILE VIEWERS
// ======================================================

class AllProfileViewersPage extends StatelessWidget {
  const AllProfileViewersPage({super.key});

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
          'Who Viewed My Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // ======================================================
      // ALL VIEWERS
      // ======================================================

      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: WhoViewedMyProfile.viewers.length,

        itemBuilder: (context, index) {
          final viewer =
              WhoViewedMyProfile.viewers[index];

          return Container(
            margin: const EdgeInsets.only(
              bottom: 12,
            ),
            padding: const EdgeInsets.all(15),

            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(15),
            ),

            child: Row(
              children: [
                const CircleAvatar(
                  radius: 27,
                  backgroundColor: Color(0xFF333333),
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        viewer['name']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        viewer['phone']!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        viewer['time']!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}