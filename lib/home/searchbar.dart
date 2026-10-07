import 'package:flutter/material.dart';
import 'contacts.dart';

class ContactSearchPage extends StatefulWidget {
  const ContactSearchPage({super.key});

  @override
  State<ContactSearchPage> createState() => _ContactSearchPageState();
}

class _ContactSearchPageState extends State<ContactSearchPage> {
  List<Contact> filteredContacts = [];

// DUMMY RECENT SEARCHES
final List<Contact> recentContacts = [
  Contact(name: 'Andi', phone: '08123456789'),
  Contact(name: 'Caca', phone: '08818003442'),
  Contact(name: 'Fajar', phone: '082112345678'),
];

  @override
  void initState() {
    super.initState();

    // Awalnya tampilkan semua kontak
    filteredContacts = contacts;
  }

  // =========================
  // SEARCH CONTACT
  // =========================
  void _runFilter(String keyword) {
    List<Contact> results;

    if (keyword.isEmpty) {
      results = contacts;
    } else {
      results = contacts.where((contact) {
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
      backgroundColor: Colors.black,

      // =========================
      // APP BAR
      // =========================
      appBar: AppBar(
        backgroundColor: Colors.black,
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

            const SizedBox(height: 15),

            // =========================
            // LOGO CONTACTS
            // =========================
            const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.contacts,
                    color: Colors.white,
                    size: 55,
                  ),

                  SizedBox(height: 5),

                  Text(
                    'Contacts',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // =========================
            // BUTTON MY CONTACTS
            // =========================
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactsPage(),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 18,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.grey.shade700,
                    width: 1,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.contacts_outlined,
                      color: Colors.white,
                      size: 22,
                    ),

                    SizedBox(width: 12),

                    Text(
                      'My Contacts',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),

                    Spacer(),

                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

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
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // =========================
            // HASIL KONTAK
            // =========================
            Expanded(
              child: filteredContacts.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = filteredContacts[index];

                        return Container(
                          margin: const EdgeInsets.only(
                            bottom: 12,
                          ),
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

                            // FOTO / ICON KONTAK
                            leading: const CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xFF333333),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),

                            // NAMA
                            title: Text(
                              contact.name,
                              style: const TextStyle(
                                color: Colors.white,
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

                            // PANAH
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.grey,
                            ),

                            onTap: () {},
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


// ======================================================
// HALAMAN SEMUA CONTACTS
// ======================================================

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      // =========================
      // APP BAR CONTACTS
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
          'Contacts',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =========================
      // SEMUA CONTACT
      // =========================
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),

              leading: const CircleAvatar(
                radius: 25,
                backgroundColor: Color(0xFF333333),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),

              title: Text(
                contact.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                contact.phone,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}