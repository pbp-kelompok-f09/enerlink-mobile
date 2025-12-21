import 'package:flutter/material.dart';
import '../widgets/appbar.dart';

class PrivacyScreenMobile extends StatelessWidget {
  const PrivacyScreenMobile({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MobileNavbar(title: 'Privacy Policy'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text('Kebijakan Privasi (mobile)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Ringkasan kebijakan privasi versi mobile.'),
        ],
      ),
    );
  }
}