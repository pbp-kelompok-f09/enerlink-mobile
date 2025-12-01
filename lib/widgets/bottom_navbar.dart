import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavbar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_rounded),
            label: 'Comm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stadium_rounded),
            label: 'Venues',
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
