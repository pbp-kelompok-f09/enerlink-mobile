import 'package:enerlink_mobile/screens/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:enerlink_mobile/screens/main_screen.dart';
import 'package:enerlink_mobile/screens/auth/login_screen.dart';
import 'package:enerlink_mobile/screens/admin_dashboard_screen.dart'; // Import AdminDashboardScreen
import 'screens/auth/register_screen.dart';
import 'screens/account_screen.dart';
import 'screens/profile_screen.dart';
// import 'package:enerlink_mobile/screens/community_list.dart'; // No longer needed if we reuse MainScreenMobile

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
            child: Text(
              note,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
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
        return MaterialPageRoute(builder: (context) => MainScreenMobile());
      case '/community': 
        return MaterialPageRoute(
          builder: (context) => const MainScreenMobile(initialIndex: 1),
        );
      case '/venues': // placeholder
        return MaterialPageRoute(
          builder: (context) => const MainScreenMobile(initialIndex: 2),
        );
      case '/account': // Account (guest: login/register; logged-in: dashboard)
        return MaterialPageRoute(
          builder: (context) => const AccountScreenMobile(),
        );
      case '/dashboard': // alias
        return MaterialPageRoute(
          builder: (context) => const MainScreenMobile(initialIndex: 3),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (context) => const LoginScreenMobile(),
        );
      case '/register':
        return MaterialPageRoute(
          builder: (context) => const RegisterScreenMobile(),
        );
      case '/profile':
        return MaterialPageRoute(
          builder: (context) => const ProfileScreenMobile(),
        );
      case '/admin':
        return MaterialPageRoute(
          builder: (context) => const AdminDashboardScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const NotFoundScreenMobile(),
        );
    }
  }
}
