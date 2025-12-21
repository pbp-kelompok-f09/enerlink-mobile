import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool isAdmin;

  const BottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.1).round()),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.groups_rounded),
            label: 'Comm',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.stadium_rounded),
            label: 'Venues',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          if (isAdmin)
            const BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings),
              label: 'Admin',
            ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: const Color(
          0xFFFFD700,
        ), // Enerlink Yellow for selected
        unselectedItemColor: Colors.white, // White for unselected
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed, // Required for more than 3 items
        backgroundColor: const Color(
          0xFF1976D2,
        ), // A blue from the landing page gradient
        onTap: onItemTapped,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
