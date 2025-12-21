import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../models/admin_venue_model.dart';
import '../services/admin_dashboard_service.dart';

class EditVenueScreen extends StatefulWidget {
  final AdminVenue venue;
  const EditVenueScreen({super.key, required this.venue});

  @override
  State<EditVenueScreen> createState() => _EditVenueScreenState();
}

class _EditVenueScreenState extends State<EditVenueScreen> {
  final _formKey = GlobalKey<FormState>();
  final AdminDashboardService _service = AdminDashboardService();

  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _priceController;

  Uint8List? _webImage;
  String? _filename;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.venue.name);
    _addressController = TextEditingController(text: widget.venue.address);
    // Bersihkan format harga
    _priceController = TextEditingController(text: widget.venue.price.replaceAll(RegExp(r'[^0-9]'), ''));
  }

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
      appBar: AppBar(title: const Text("Edit Venue")),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                child: _webImage != null
                    ? Image.memory(_webImage!, fit: BoxFit.cover)
                    : (widget.venue.imageUrl.isNotEmpty 
                        ? Image.network(widget.venue.imageUrl, fit: BoxFit.cover)
                        : const Icon(Icons.add_a_photo, size: 50, color: Colors.grey)),
              ),
            ),
            const Center(child: Padding(padding: EdgeInsets.all(8.0), child: Text("Tap gambar untuk mengganti"))),
            
            TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: "Nama Venue")),
            const SizedBox(height: 10),
            TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: "Alamat")),
            const SizedBox(height: 10),
            TextFormField(controller: _priceController, decoration: const InputDecoration(labelText: "Harga")),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  // --- PERBAIKAN DI SINI (Ganti nama fungsi) ---
                  final success = await _service.editVenue( // Pakai editVenue, BUKAN editVenueWithImage
                    request,
                    widget.venue.id,
                    {
                      'name': _nameController.text,
                      'address': _addressController.text,
                      'price': _priceController.text,
                    },
                    imageBytes: _webImage, 
                    filename: _filename,
                  );

                  if (!context.mounted) return;
                  if (success) {
                    Navigator.pop(context, true);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Venue updated!")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed update.")));
                  }
                }
              },
              child: const Text("Save Changes"),
            )
          ],
        ),
      ),
    );
  }
}