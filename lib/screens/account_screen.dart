import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/bottom_bar.dart';

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
      _loadLoginState(); // refresh when returning
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => isLoggedIn = prefs.getBool('isLoggedIn') ?? false);

    // Jika sudah login, langsung buka dashboard
    if (isLoggedIn == true && mounted) {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    if (!mounted) return;
    setState(() => isLoggedIn = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out')));
  }

  @override
  Widget build(BuildContext context) {
    final content = isLoggedIn == true
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 12),
              ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: const Text('Welcome back!'),
                subtitle: const Text('Manage your account and activities'),
                trailing: ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                  child: const Text('Open Dashboard'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: _logout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Welcome, Guest', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8),
              const Text('Sign in or create an account to access your dashboard.', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      icon: const Icon(Icons.login),
                      label: const Text('Login'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/register'),
                      icon: const Icon(Icons.app_registration),
                      label: const Text('Register'),
                    ),
                  ),
                ],
              ),
            ],
          );

    return Scaffold(
      bottomNavigationBar: MobileBottomNav(
        currentIndex: bottomIndex,
        onTap: (i) {
          setState(() => bottomIndex = i);
          if (i == 0) {
            Navigator.pushReplacementNamed(context, '/');
          } else if (i == 1) {
            Navigator.pushNamed(context, '/community'); // placeholder bisa kembali
          } else if (i == 2) {
            Navigator.pushNamed(context, '/venues'); // placeholder bisa kembali
          } else if (i == 3) {
            // already here
          }
        },
      ),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(16), child: content)),
    );
  }
}