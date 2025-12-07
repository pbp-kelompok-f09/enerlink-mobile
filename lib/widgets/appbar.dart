// ...existing code...
import 'package:flutter/material.dart';

class MobileNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  const MobileNavbar({super.key, required this.title, this.actions});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    // Untuk sekarang, navbar dihilangkan (tidak digunakan) => kembalikan SizedBox.shrink
    return PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: const SizedBox.shrink(),
    );
  }
}