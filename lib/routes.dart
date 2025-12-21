import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/dashboard/user_dashboard_screen.dart';
import 'screens/not_found_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/account_screen.dart';
import 'screens/profile_screen.dart';

class _EmptyScreen extends StatelessWidget {
  final String title;
  final String note;
  const _EmptyScreen({required this.title, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true, title: Text(title)),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(note, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
          ),
        ),
      ),
    );
  }
}

class EnerlinkMobileRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/': // Home (landing)
        return MaterialPageRoute(builder: (_) => MainScreenMobile());
      case '/community': // placeholder
        return MaterialPageRoute(builder: (_) => const _EmptyScreen(title: 'Community', note: 'TODO: Community belum tersedia'));
      case '/venues': // placeholder
        return MaterialPageRoute(builder: (_) => const _EmptyScreen(title: 'Venues', note: 'TODO: Venues belum tersedia'));
      case '/account': // Account (guest: login/register; logged-in: dashboard)
        return MaterialPageRoute(builder: (_) => const AccountScreenMobile());
      case '/dashboard': // alias
        return MaterialPageRoute(builder: (_) => const MainScreenMobile(initialIndex: 3));
      case '/forum':
        return MaterialPageRoute(builder: (_) => const MainScreenMobile(initialIndex: 4));
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreenMobile());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreenMobile());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreenMobile());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundScreenMobile());
    }
  }
}