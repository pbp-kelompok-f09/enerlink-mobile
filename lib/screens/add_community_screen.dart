import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../services/admin_dashboard_service.dart';

class AddCommunityScreen extends StatefulWidget {
  const AddCommunityScreen({super.key});

  @override
  State<AddCommunityScreen> createState() => _AddCommunityScreenState();
}

class _AddCommunityScreenState extends State<AddCommunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = AdminDashboardService();

  String _title = "";
  String _city = "";
  String _description = "";
  String _category = "FL"; // Default Futsal

  // List Kategori (Sesuaikan dengan Django choices kamu)
  final List<Map<String, String>> _categories = [
    {'value': 'FL', 'label': 'Futsal'},
    {'value': 'BK', 'label': 'Basket'},
    {'value': 'BD', 'label': 'Badminton'},
    {'value': 'GF', 'label': 'Golf'},
    {'value': 'TN', 'label': 'Tennis'},
    {'value': 'PD', 'label': 'Padel'},
    {'value': 'MS', 'label': 'Mini Soccer'},
  ];

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Community", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2E7D32),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Bagian Image Picker dihapus demi efisiensi
            // Sebagai ganti, kita tampilkan Icon representatif
            const Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFFE8F5E9),
                child: Icon(Icons.groups, size: 40, color: Color(0xFF2E7D32)),
              ),
            ),
            const SizedBox(height: 24),

            TextFormField(
              decoration: const InputDecoration(
                labelText: "Nama Komunitas", 
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (v) => v!.isEmpty ? "Harus diisi" : null,
              onSaved: (v) => _title = v!,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Kota", 
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_city),
                    ),
                    validator: (v) => v!.isEmpty ? "Harus diisi" : null,
                    onSaved: (v) => _city = v!,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _category,
                    decoration: const InputDecoration(
                      labelText: "Kategori", 
                      border: OutlineInputBorder(),
                    ),
                    items: _categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat['value'],
                        child: Text(cat['label']!),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _category = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            TextFormField(
              decoration: const InputDecoration(
                labelText: "Deskripsi", 
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              onSaved: (v) => _description = v ?? "",
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  
                  // Kirim data teks saja melalui service post biasa
                  final success = await _service.addCommunity(
                    request, 
                    {
                      'title': _title,
                      'city': _city,
                      'sport_category': _category,
                      'description': _description,
                    },
                  );

                  if (context.mounted) {
                    if (success) {
                      Navigator.pop(context, true); // Kembali dan memicu refresh
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Komunitas Berhasil Dibuat!"))
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Gagal membuat komunitas."))
                      );
                    }
                  }
                }
              },
              child: const Text(
                "Simpan Komunitas", 
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
              ),
            ),
          ],
        ),
      ),
    );
  }
}