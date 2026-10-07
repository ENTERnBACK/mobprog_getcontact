import 'package:flutter/material.dart';

// MODEL KONTAK
class Contact {
  final String name;
  final String phone;

  Contact({
    required this.name,
    required this.phone,
  });
}

class ContactSearchPage extends StatefulWidget {
  const ContactSearchPage({super.key});

  @override
  State<ContactSearchPage> createState() => _ContactSearchPageState();
}

class _ContactSearchPageState extends State<ContactSearchPage> {
  // DUMMY DATA
  final List<Contact> allContacts = [
    Contact(name: 'Andi', phone: '08123456789'),
    Contact(name: 'Budi', phone: '08567891234'),
    Contact(name: 'aca', phone: '08818003442'),
    Contact(name: 'Dedi', phone: '08987654321'),
  ];

  List<Contact> filteredContacts = [];

  @override
  void initState() {
    super.initState();
    filteredContacts = allContacts;
  }

  // FILTER SEARCH
  void _runFilter(String keyword) {
    List<Contact> results;

    if (keyword.isEmpty) {
      results = allContacts;
    } else {
      results = allContacts.where((contact) {
        return contact.name
                .toLowerCase()
                .contains(keyword.toLowerCase()) ||
            contact.phone.contains(keyword);
      }).toList();
    }

    setState(() {
      filteredContacts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // BACKGROUND DARK
      backgroundColor: const Color(0xFF000000),

      // =========================
      // APP BAR
      // =========================
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        elevation: 0,
        centerTitle: false,

        title: const Text(
          'GetContact',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.white,
            ),
          ),
        ],
      ),

      // =========================
      // BODY
      // =========================
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // =========================
            // SEARCH BAR
            // =========================
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(15),
              ),

              child: TextField(
                onChanged: _runFilter,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration: const InputDecoration(
                  hintText: 'Cari nama atau nomor...',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),

                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),

                  border: InputBorder.none,

                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // RECENT SEARCHES
            // =========================
            const Text(
              'Recent Searches',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            // =========================
            // LIST KONTAK
            // =========================
            Expanded(
              child: filteredContacts.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredContacts.length,

                      itemBuilder: (context, index) {
                        final contact = filteredContacts[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),

                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),

                            // FOTO / INISIAL
                            leading: CircleAvatar(
                              radius: 25,

                              backgroundColor:
                                  const Color(0xFF333333),

                              child: Text(
                                contact.name[0].toUpperCase(),

                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),

                            // NAMA
                            title: Text(
                              contact.name,

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),

                            // NOMOR
                            subtitle: Text(
                              contact.phone,

                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),

                            // ARROW
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
                            ),

                            onTap: () {
                              // Nanti bisa diarahkan ke detail contact
                            },
                          ),
                        );
                      },
                    )

                  : const Center(
                      child: Text(
                        'Kontak tidak ditemukan',

                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}