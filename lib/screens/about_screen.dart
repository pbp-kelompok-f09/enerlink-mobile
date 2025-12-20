import 'package:flutter/material.dart';
import '../widgets/appbar.dart';

class AboutScreenMobile extends StatelessWidget {
  const AboutScreenMobile({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MobileNavbar(title: 'About'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Tentang Enerlink (mobile)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Ringkasan konten About versi mobile.'),
        ],
      ),
    );
  }
}