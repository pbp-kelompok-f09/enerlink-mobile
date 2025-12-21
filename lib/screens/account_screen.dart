import 'package:flutter/material.dart';
import '../services/api_client.dart';
import '../widgets/bottom_navbar.dart';

class AccountScreenMobile extends StatefulWidget {
  const AccountScreenMobile({super.key});

  @override
  State<AccountScreenMobile> createState() => _AccountScreenMobileState();
}

class _AccountScreenMobileState extends State<AccountScreenMobile> with WidgetsBindingObserver {
  int bottomIndex = 3;
  bool? isLoggedIn;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadLoginState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadLoginState();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadLoginState() async {
    final loggedIn = await ApiClient.isLoggedIn();
    if (!mounted) return;
    setState(() => isLoggedIn = loggedIn);
  }

  void _onBottomNavTapped(int index) {
    if (index == bottomIndex) return;
    
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/community');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/venues');
        break;
      case 3:
        // Already on account
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.person_outline, size: 80, color: Colors.white70),
        const SizedBox(height: 16),
        const Text(
          'Welcome to Enerlink',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Login or register to access your account',
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2563EB),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Login'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Register'),
          ),
        ),
      ],
    );

    return Scaffold(
      bottomNavigationBar: BottomNavbar(
        selectedIndex: bottomIndex,
        onItemTapped: (i) {
          setState(() => bottomIndex = i);
          if (i == 0) Navigator.pushReplacementNamed(context, '/');
          if (i == 1) Navigator.pushNamed(context, '/community');
          if (i == 2) Navigator.pushNamed(context, '/venues');
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF2563EB), Color(0xFF0EA5E9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                color: Colors.white.withAlpha((255 * 0.15).round()),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: content,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}