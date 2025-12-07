import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreenMobile extends StatefulWidget {
  const LoginScreenMobile({super.key});

  @override
  State<LoginScreenMobile> createState() => _LoginScreenMobileState();
}

class _LoginScreenMobileState extends State<LoginScreenMobile> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    // TODO: call Django login API
    await Future.delayed(const Duration(milliseconds: 400));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/account');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged in')));
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 8,
              margin: const EdgeInsets.all(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            'lib/assets/images/blackBlueEnerlink.png',
                            height: 42,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Sign in to your Enerlink account',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _username,
                          decoration: const InputDecoration(labelText: 'Username'),
                          validator: (v) => v == null || v.isEmpty ? 'Username wajib diisi' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _password,
                          decoration: const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (v) => v == null || v.isEmpty ? 'Password wajib diisi' : null,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _submit,
                            child: _loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Sign in'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
                          child: const Text('Create an account'),
                        ),
                      ],
                    ),
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