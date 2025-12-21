import 'dart:typed_data'; // Tambah ini
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Tambah ini
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../services/admin_dashboard_service.dart';

class AddVenueScreen extends StatefulWidget {
  const AddVenueScreen({super.key});

  @override
  State<AddVenueScreen> createState() => _AddVenueScreenState();
}

class _AddVenueScreenState extends State<AddVenueScreen> {
  final _formKey = GlobalKey<FormState>();
  final AdminDashboardService _service = AdminDashboardService();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();
  // _imageController KITA HAPUS karena diganti Image Picker
  
  String _selectedCategory = "Futsal"; 
  final List<String> _categories = ["Futsal", "Badminton", "Basketball", "Mini Soccer", "Padel", "Tennis", "Golf", "Volley"];

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

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Venue"),
        backgroundColor: const Color(0xFFF9A825),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // --- INPUT GAMBAR (BARU) ---
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _webImage != null
                    ? Image.memory(_webImage!, fit: BoxFit.cover)
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                          Text("Tap to upload venue image", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            // ---------------------------

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Venue Name", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Harus diisi" : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(labelText: "Category", border: OutlineInputBorder()),
              items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _selectedCategory = val!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: "Address", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Harus diisi" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price per Session", prefixText: "Rp ", border: OutlineInputBorder()),
              validator: (v) => v!.isEmpty ? "Harus diisi" : null,
            ),
            const SizedBox(height: 24),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF9A825),
                padding: const EdgeInsets.symmetric(vertical: 16),
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // PANGGIL SERVICE (UPDATE)
                  final success = await _service.addVenue(
                    request, 
                    {
                      'name': _nameController.text,
                      'category': _selectedCategory,
                      'address': _addressController.text,
                      'price': _priceController.text, // Kirim String langsung!
                      'description': 'Venue baru', // Default description
                    },
                    imageBytes: _webImage, // Kirim file
                    filename: _filename
                  );

                  if (!context.mounted) return;
                  if (success) {
                    Navigator.pop(context, true);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Venue berhasil dibuat!")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal membuat venue.")));
                  }
                }
              },
              child: const Text("Create Venue", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}