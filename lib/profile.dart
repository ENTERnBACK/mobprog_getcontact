import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 46,
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person, size: 54, color: Colors.white),
              ),
              const SizedBox(height: 14),

              const Text(
                'Elizabeth',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                '+62800xxxx',
                style: TextStyle(
                  fontSize: 13, 
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: buildTopActionCard(
                      title: '#19',
                      subtitle: 'My Tags',
                      titleColor: Colors.blue,
                      isIcon: false,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: buildTopActionCard(
                      title: '',
                      subtitle: 'My Profile Summary',
                      titleColor: Colors.blue,
                      isIcon: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              buildListCard(
                icon: Icons.cake_outlined,
                title: 'Add Your Birthday!',
                subtitle:
                    'Add your birthday for celebrations, congratulations, and gifts.',
                showChevron: true,
              ),
              const SizedBox(height: 12),

              buildMenuItem(
                icon: Icons.notifications,
                title: 'Notifications',
              ),
              const Divider(color: Colors.grey, height: 1),
              buildMenuItem(
                icon: Icons.visibility,
                title: 'Who Viewed My Profile',
              ),
              const Divider(color: Colors.grey, height: 1),
              buildMenuItem(
                icon: Icons.grid_view_rounded,
                title: 'Shortcuts',
              ),
              const Divider(color: Colors.grey, height: 1),
              buildMenuItem(
                icon: Icons.sms_failed_outlined,
                title: 'Spam SMS Protection',
              ),
              const Divider(color: Colors.grey, height: 1),
              buildMenuItem(
                icon: Icons.phone_disabled_outlined,
                title: 'Spam Call Settings',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNav(),
    );
  }

  Widget buildTopActionCard({
    required String title,
    required String subtitle,
    required Color titleColor,
    required bool isIcon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          if (isIcon)
            Icon(Icons.auto_awesome, color: titleColor, size: 22)
          else
            Text(
              title,
              style: TextStyle(
                color: titleColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool showChevron,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildIconBox(icon),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          if (showChevron)
            const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
        ],
      ),
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        children: [
          buildIconBox(icon),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 24),
        ],
      ),
    );
  }

  Widget buildIconBox(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget buildBottomNav() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      currentIndex: 3,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.call_outlined),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: 'Chat',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.verified_user_outlined),
          label: 'Protection',
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade800,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.menu, color: Colors.white, size: 20),
          ),
          label: 'Menu',
        ),
      ],
    );
  }
}