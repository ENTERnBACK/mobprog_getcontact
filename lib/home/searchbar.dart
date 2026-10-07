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
    Contact(name: 'Caca', phone: '08781234567'),
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
      backgroundColor: Colors.white,

      // =========================
      // APP BAR
      // =========================
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'GetContact',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.black,
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

            // SEARCH BAR
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                onChanged: _runFilter,
                decoration: const InputDecoration(
                  hintText: 'Cari nama atau nomor...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // RECENT SEARCHES
            const Text(
              'Recent Searches',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // LIST KONTAK
            Expanded(
              child: filteredContacts.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = filteredContacts[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 5,
                            ),

                            // FOTO / INISIAL
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                contact.name[0],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),

                            // NAMA
                            title: Text(
                              contact.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            // NOMOR
                            subtitle: Text(
                              contact.phone,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),

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

      // =========================
      // BOTTOM NAVIGATION
      // =========================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          // Nanti kita sambungkan ke halaman lain
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}