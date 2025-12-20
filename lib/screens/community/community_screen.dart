import 'package:enerlink_mobile/screens/main_screen.dart';
import 'package:enerlink_mobile/screens/not_found_screen.dart';
import 'package:flutter/material.dart';

// Placeholder screens for consistency
class CommunityScreenMobile extends StatelessWidget {
  const CommunityScreenMobile({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Community (TODO)')));
}

class VenuesScreenMobile extends StatelessWidget {
  const VenuesScreenMobile({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Venues (TODO)')));
}

class AccountScreenMobile extends StatelessWidget {
  const AccountScreenMobile({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Account (Login/Register/Logout TODO)')));
}

class EnerlinkMobileRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const MainScreenMobile());
      case '/community':
        return MaterialPageRoute(builder: (_) => const CommunityScreenMobile());
      case '/venues':
        return MaterialPageRoute(builder: (_) => const VenuesScreenMobile());
      case '/account':
        return MaterialPageRoute(builder: (_) => const AccountScreenMobile());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundScreenMobile());
    }
  }
}