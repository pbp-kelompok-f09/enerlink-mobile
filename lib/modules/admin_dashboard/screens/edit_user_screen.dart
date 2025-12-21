import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/admin_user_model.dart'; // Pastikan import model ini ada
import '../services/admin_dashboard_service.dart';

class EditUserScreen extends StatefulWidget {
  final AdminUser user; // Kita terima objek user utuh

  const EditUserScreen({super.key, required this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final AdminDashboardService _service = AdminDashboardService();

  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _walletController;
  
  // Variabel untuk Gambar
  Uint8List? _webImage;
  String? _filename;

  @override
  void initState() {
    super.initState();
    // Isi data awal dari widget.user
    _nameController = TextEditingController(text: widget.user.name);
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    // Bersihkan format wallet biar cuma angka
    String cleanWallet = widget.user.wallet.replaceAll(RegExp(r'[^0-9]'), '');
    _walletController = TextEditingController(text: cleanWallet);
  }

  // Fungsi Pilih Gambar
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

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit User Data"),
        backgroundColor: const Color(0xFF2962FF),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // --- BAGIAN FOTO PROFIL ---
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey.shade300,
                      // Tampilkan gambar baru jika ada, kalau tidak kosongkan/pakai inisial
                      backgroundImage: _webImage != null ? MemoryImage(_webImage!) : null,
                      child: _webImage == null 
                        ? const Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                        : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _pickImage,
                    child: const Text("Ganti Foto Profil"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // ---------------------------

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nama Lengkap", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: "Username", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _walletController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Wallet (Rp)", border: OutlineInputBorder()),
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
                  // Kirim data ke Service
                  final success = await _service.updateUserWithImage(
                    request,
                    widget.user.id,
                    {
                      'name': _nameController.text,
                      'username': _usernameController.text,
                      'email': _emailController.text,
                      'wallet': _walletController.text,
                    },
                    imageBytes: _webImage, // File gambar
                    filename: _filename,
                  );

                  if (!context.mounted) return;
                  if (success) {
                    Navigator.pop(context, true); // Kembali & Refresh
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User berhasil diupdate!")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal update user.")));
                  }
                }
              },
              child: const Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }
}