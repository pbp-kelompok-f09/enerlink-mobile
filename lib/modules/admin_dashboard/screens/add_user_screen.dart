import 'dart:typed_data'; // Tambah ini
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Tambah ini
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../services/admin_dashboard_service.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final AdminDashboardService _service = AdminDashboardService();

  // Controllers
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _walletController = TextEditingController();
  
  String _selectedRole = "US"; // Default User

  // --- VARIABEL GAMBAR ---
  Uint8List? _webImage;
  String? _filename;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var f = await image.readAsBytes();
      setState(() {
        _webImage = f;
        _filename = image.name;
      });
    }
  }
  // -----------------------

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New User"),
        backgroundColor: const Color(0xFF2962FF),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // --- UI INPUT GAMBAR ---
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: _webImage != null ? MemoryImage(_webImage!) : null,
                      child: _webImage == null 
                        ? const Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                        : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _pickImage,
                    child: const Text("Upload Foto Profil"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // -----------------------

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Full Name", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Harus diisi" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Username", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Harus diisi" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Harus diisi" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Harus diisi" : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: const InputDecoration(labelText: "Role", border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(value: "US", child: Text("User (Regular)")),
                DropdownMenuItem(value: "AC", child: Text("Admin Community")),
                DropdownMenuItem(value: "DEV", child: Text("Developer")),
              ],
              onChanged: (val) => setState(() => _selectedRole = val!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _walletController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Initial Wallet Balance", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2962FF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // Pastikan wallet diisi angka, kalau kosong jadi 0
                  String walletVal = _walletController.text.isEmpty ? "0" : _walletController.text;

                  final success = await _service.addUser(
                    request, 
                    {
                      'name': _nameController.text,
                      'username': _usernameController.text,
                      'email': _emailController.text,
                      'password': _passwordController.text,
                      'role': _selectedRole,
                      'wallet': walletVal, // Kirim String
                    },
                    imageBytes: _webImage, // Kirim File
                    filename: _filename
                  );

                  if (!context.mounted) return;
                  if (success) {
                    Navigator.pop(context, true); // Kembali & refresh
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User berhasil dibuat!")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal membuat user.")));
                  }
                }
              },
              child: const Text("Create User", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}