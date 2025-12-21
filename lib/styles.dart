import 'package:flutter/material.dart';

class EnerlinkStyles {
  // Background gradient seperti landing
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1E3A8A), // deep blue
      Color(0xFF2563EB), // primary blue
      Color(0xFF0EA5E9), // cyan-ish
    ],
  );

  // Panel info (notifikasi) semi-transparent
  static BoxDecoration infoPanel = BoxDecoration(
    color: Colors.white.withValues(alpha: 0.12),
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
  );

  // Tile biru (Communities, Forum)
  static BoxDecoration blueTile = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: const LinearGradient(
      colors: [Color(0xFF38BDF8), Color(0xFF2563EB)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    boxShadow: const [
      BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 8)),
    ],
  );

  // Tile kuning (Venues, Events)
  static BoxDecoration yellowTile = BoxDecoration(
    borderRadius: BorderRadius.circular(20),
    gradient: const LinearGradient(
      colors: [Color(0xFFFDE68A), Color(0xFFFACC15)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    boxShadow: const [
      BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 8)),
    ],
  );

  static TextStyle tileTitle = const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static TextStyle sectionTitle = const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w800,
  );
}