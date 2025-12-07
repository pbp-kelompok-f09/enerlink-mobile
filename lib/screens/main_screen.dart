import 'package:flutter/material.dart';
import '../widgets/appbar.dart';
import '../widgets/bottom_bar.dart';

class MainScreenMobile extends StatefulWidget {
  const MainScreenMobile({super.key});
  @override
  State<MainScreenMobile> createState() => _MainScreenMobileState();
}

class _MainScreenMobileState extends State<MainScreenMobile> {
  int bottomIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MobileNavbar(title: ''),
      bottomNavigationBar: MobileBottomNav(
        currentIndex: bottomIndex,
        onTap: (i) {
          setState(() => bottomIndex = i);
          if (i == 0) {/* already here: Home */}
          if (i == 1) Navigator.pushReplacementNamed(context, '/community'); // placeholder
          if (i == 2) Navigator.pushReplacementNamed(context, '/venues');    // placeholder
          if (i == 3) Navigator.pushReplacementNamed(context, '/account');   // user dashboard
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Landing mobile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Konten ringkas versi mobile.'),
        ],
      ),
    );
  }
}