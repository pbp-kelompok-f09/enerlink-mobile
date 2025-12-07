import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreenMobile extends StatefulWidget {
  const RegisterScreenMobile({super.key});

  @override
  State<RegisterScreenMobile> createState() => _RegisterScreenMobileState();
}

class _RegisterScreenMobileState extends State<RegisterScreenMobile> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _name.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_password.text != _confirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    setState(() => _loading = true);
    // TODO: call Django register API
    await Future.delayed(const Duration(milliseconds: 400));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/account');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created')));
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
                        // Header: logo + subtitle, centered dan rapat
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
                          'Create your Enerlink account',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 16),

                        // Form fields
                        TextFormField(
                          controller: _name,
                          decoration: const InputDecoration(labelText: 'Full Name'),
                          validator: (v) => v == null || v.isEmpty ? 'Nama wajib diisi' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _username,
                          decoration: const InputDecoration(labelText: 'Username'),
                          validator: (v) => v == null || v.isEmpty ? 'Username wajib diisi' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _email,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (v) => v == null || !v.contains('@') ? 'Email tidak valid' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _password,
                          decoration: const InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (v) => v == null || v.length < 6 ? 'Minimal 6 karakter' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _confirm,
                          decoration: const InputDecoration(labelText: 'Confirm Password'),
                          obscureText: true,
                          validator: (v) => v == null || v.length < 6 ? 'Minimal 6 karakter' : null,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _submit,
                            child: _loading
                                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Text('Register'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                          child: const Text('Already have an account? Sign in'),
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