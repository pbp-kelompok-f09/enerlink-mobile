import 'package:flutter/material.dart';
import 'routes.dart';

void main() {
  runApp(const EnerlinkApp());
}

class EnerlinkApp extends StatelessWidget {
  const EnerlinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryBlue = Color(0xFF2563EB);
    const yellow = Color(0xFFFACC15);

    return MaterialApp(
      title: 'Enerlink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: primaryBlue,
          onPrimary: Colors.white,
          secondary: yellow,
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          background: Color(0xFF0EA5E9),
          onBackground: Colors.white,
          surface: Colors.white,
          onSurface: Color(0xFF111827),
        ),
        scaffoldBackgroundColor: const Color(0xFF0EA5E9),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.white),
        ),
        // FIX: CardThemeData (not CardTheme)
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          shadowColor: Color(0x26000000), // ~15% black
        ),
        navigationBarTheme: const NavigationBarThemeData(
          backgroundColor: Color(0xFF0EA5E9),
          indicatorColor: Color(0x33FFFFFF),
          labelTextStyle: MaterialStatePropertyAll(TextStyle(color: Colors.white)),
          iconTheme: MaterialStatePropertyAll(IconThemeData(color: Colors.white)),
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: EnerlinkMobileRouter.onGenerateRoute,
    );
  }
}