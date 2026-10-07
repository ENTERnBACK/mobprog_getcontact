import 'package:flutter/material.dart';
import 'contacts.dart';
import '../chats/chats.dart';

class ContactSearchPage extends StatefulWidget {
  const ContactSearchPage({super.key});

  @override
  State<ContactSearchPage> createState() => _ContactSearchPageState();
}

class _ContactSearchPageState extends State<ContactSearchPage> {
  List<Contact> filteredContacts = [];
  bool isSearching = false;

  // =========================
  // DUMMY RECENT SEARCHES
  // =========================
  final List<Contact> recentContacts = [
    Contact(
      name: 'Andi',
      phone: '08123456789',
    ),
    Contact(
      name: 'Caca',
      phone: '08818003442',
    ),
    Contact(
      name: 'Fajar',
      phone: '082112345678',
    ),
  ];

  // =========================
  // DUMMY RECENT CALLS
  // =========================
  final List<Contact> recentCalls = [
    Contact(
      name: 'Budi',
      phone: '08567891234',
    ),
    Contact(
      name: 'Aerosol',
      phone: '08123456789',
    ),
    Contact(
      name: 'Dedi',
      phone: '08987654321',
    ),
  ];

  @override
  void initState() {
    super.initState();
    filteredContacts = [];
  }

  // =========================
  // SEARCH CONTACT
  // =========================
  void _runFilter(String keyword) {
    List<Contact> results;

    if (keyword.isEmpty) {
      results = [];
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
      isSearching = keyword.isNotEmpty;
    });
  }

  // =========================
  // BUKA DETAIL CONTACT
  // =========================
  void _openContactDetail(Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactDetailPage(
          name: contact.name,
          phone: contact.phone,
        ),
      ),
    );
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
      body: SingleChildScrollView(
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
            // MY CONTACTS
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

            // ======================================================
            // SEARCH RESULT / RECENT SEARCHES
            // ======================================================

            Text(
              isSearching ? 'Search Results' : 'Recent Searches',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            // =========================
            // SEARCH RESULT
            // =========================
            if (isSearching)
              filteredContacts.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredContacts.length,
                      itemBuilder: (context, index) {
                        final contact = filteredContacts[index];

                        return _contactCard(
                          contact,
                          () => _openContactDetail(contact),
                        );
                      },
                    )
                  : const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: Text(
                          'Kontak tidak ditemukan',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

            // =========================
            // RECENT SEARCHES
            // =========================
            if (!isSearching)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentContacts.length,
                itemBuilder: (context, index) {
                  final contact = recentContacts[index];

                  return _contactCard(
                    contact,
                    () => _openContactDetail(contact),
                  );
                },
              ),

            const SizedBox(height: 25),

            // =========================
            // RECENT CALLS
            // =========================
            if (!isSearching) ...[
              const Text(
                'Recent Calls',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: recentCalls.length,
                itemBuilder: (context, index) {
                  final contact = recentCalls[index];

                  return _callCard(
                    contact,
                    () => _openContactDetail(contact),
                  );
                },
              ),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // CARD RECENT SEARCHES / SEARCH RESULT
  // ======================================================

  Widget _contactCard(
    Contact contact,
    VoidCallback onTap,
  ) {
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

        onTap: onTap,

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
            fontSize: 16,
          ),
        ),

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
      ),
    );
  }

  // ======================================================
  // CARD RECENT CALLS
  // ======================================================

  Widget _callCard(
    Contact contact,
    VoidCallback onTap,
  ) {
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

        onTap: onTap,

        leading: const CircleAvatar(
          radius: 25,
          backgroundColor: Color(0xFF333333),

          child: Icon(
            Icons.call,
            color: Colors.white,
          ),
        ),

        title: Text(
          contact.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),

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

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactDetailPage(
                      name: contact.name,
                      phone: contact.phone,
                    ),
                  ),
                );
              },

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

              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }
}


// ======================================================
// HALAMAN DETAIL CONTACT
// ======================================================

class ContactDetailPage extends StatelessWidget {
  final String name;
  final String phone;

  const ContactDetailPage({
    super.key,
    required this.name,
    required this.phone,
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
          'Contact Detail',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // =========================
      // DETAIL
      // =========================
      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 30),

            // FOTO
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

            // NAMA
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            // NOMOR
            Text(
              phone,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            // =========================
            // CALL
            // =========================
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
                  ),
                ),

                onTap: () {},
              ),
            ),

            const SizedBox(height: 12),

            // =========================
            // MESSAGE
            // =========================
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
                  ),
                ),

                onTap: () {
                   Navigator.push(
          context,
        MaterialPageRoute(
          builder: (context) => const ChatScreen(),
        ),
      );
    },
  ),
),
              
             

            const SizedBox(height: 25),

            // =========================
            // TAGS
            // =========================
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

            const SizedBox(height: 10),

            const Align(
              alignment: Alignment.centerLeft,

              child: Wrap(
                spacing: 8,

                children: [
                  Chip(
                    label: Text('Teman'),
                  ),

                  Chip(
                    label: Text('Kuliah'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}