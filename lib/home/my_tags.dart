import 'package:flutter/material.dart';

class MyTagsSection extends StatelessWidget {
  const MyTagsSection({super.key});

  // =========================
  // DAFTAR TAG
  // =========================

  final List<String> tags = const [
    'Teman Kuliah',
    'IT Student',
    'Amel',
    'Organisasi',
    'Anak Informatika',
    'Teman Sekelas',
    'UNTAR',
    'Web Developer',
    'Mahasiswa',
    'Gaming',
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AllTagsPage(
              tags: tags,
            ),
          ),
        );
      },

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.grey.shade800,
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================
            // HEADER MY TAGS
            // =========================

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
                    Icons.sell_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Tags',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 3),

                      Text(
                        'See what people say about you',
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

            // =========================
            // PREVIEW TAG
            // =========================

            Wrap(
              spacing: 8,
              runSpacing: 8,

              children: tags.take(4).map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),

                  decoration: BoxDecoration(
                    color: const Color(0xFF292929),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),

                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 15),

            // =========================
            // JUMLAH TAG
            // =========================

            Text(
              '${tags.length} tags',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ======================================================
// ALL TAGS PAGE
// ======================================================

class AllTagsPage extends StatelessWidget {
  final List<String> tags;

  const AllTagsPage({
    super.key,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // =========================
      // APP BAR
      // =========================

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
          'My Tags',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      // =========================
      // ALL TAGS
      // =========================

      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          30,
        ),

        itemCount: tags.length,

        itemBuilder: (context, index) {
          final tag = tags[index];

          return Container(
            width: double.infinity,

            margin: const EdgeInsets.only(
              bottom: 12,
            ),

            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 17,
            ),

            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(15),

              border: Border.all(
                color: Colors.grey.shade800,
                width: 1,
              ),
            ),

            child: Row(
              children: [
                // =========================
                // ICON TAG
                // =========================

                Container(
                  width: 42,
                  height: 42,

                  decoration: BoxDecoration(
                    color: const Color(0xFF333333),
                    borderRadius:
                        BorderRadius.circular(11),
                  ),

                  child: const Icon(
                    Icons.sell_outlined,
                    color: Colors.white,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 14),

                // =========================
                // NAMA TAG
                // =========================

                Expanded(
                  child: Text(
                    tag,

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
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