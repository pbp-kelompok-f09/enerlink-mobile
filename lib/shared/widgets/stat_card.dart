import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String title;
  final int value;

  const StatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text("$value", style: const TextStyle(fontSize: 22)),
          ],
        ),
      ),
    );
  }
}