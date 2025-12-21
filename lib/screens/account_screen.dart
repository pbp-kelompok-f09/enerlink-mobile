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

  Future<void> _logout() async {
    await ApiClient.logout();
    if (!mounted) return;
    setState(() => isLoggedIn = false);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out')));
  }

  @override
  Widget build(BuildContext context) {
    // 🔄 CHANGED: Simplified content layout
    final content = isLoggedIn == true
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // 🔄 CHANGED: Minimize height
            children: [
              const Text('Account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 12),
              ListTile(
                contentPadding: EdgeInsets.zero, // 🔄 CHANGED: Remove extra padding
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: const Text('Welcome back!'),
                subtitle: const Text('Manage your account'),
              ),
              const SizedBox(height: 8),
              // 🔄 CHANGED: Full width button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
                  icon: const Icon(Icons.dashboard),
                  label: const Text('Open Dashboard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // 🔄 CHANGED: Full width logout button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // 🔄 CHANGED: Minimize height
            children: [
              const Text('Account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8),
              const Text('Login atau buat akun untuk akses dashboard.', style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 16),
              // 🔄 CHANGED: Stack buttons vertically, full width
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2563EB)),
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
          child: Center( // 🔄 CHANGED: Center the card
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400), // 🔄 CHANGED: Limit max width
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20), // 🔄 CHANGED: Consistent padding
                    child: content,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}