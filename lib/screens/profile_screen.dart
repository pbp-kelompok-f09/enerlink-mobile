import 'package:flutter/material.dart';

class ProfileScreenMobile extends StatelessWidget {
  const ProfileScreenMobile({super.key});

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
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Edit Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      const CircleAvatar(radius: 32, backgroundImage: AssetImage('lib/assets/images/noProfile.jpg')),
                      const SizedBox(height: 12),
                      TextFormField(decoration: const InputDecoration(labelText: 'Display Name')),
                      const SizedBox(height: 10),
                      TextFormField(decoration: const InputDecoration(labelText: 'Email')),
                      const SizedBox(height: 10),
                      TextFormField(decoration: const InputDecoration(labelText: 'Username')),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(onPressed: () {/* TODO: save to API */}, child: const Text('Save')),
                      ),
                      const SizedBox(height: 8),
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Back')),
                    ],
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