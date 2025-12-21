import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../models/admin_community_model.dart';
import '../services/admin_dashboard_service.dart';

class EditCommunityScreen extends StatefulWidget {
  final AdminCommunity community;
  const EditCommunityScreen({super.key, required this.community});

  @override
  State<EditCommunityScreen> createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends State<EditCommunityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = AdminDashboardService();

  late String _title;
  late String _city;
  late String _description;
  late String _category;

  // List Kategori (Sesuaikan dengan Django choices di backend)
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
  void initState() {
    super.initState();
    // Inisialisasi data dari objek community yang ada
    _title = widget.community.title;
    _city = widget.community.city;
    _description = ""; // Deskripsi bisa dikosongkan jika belum ada di model
    _category = widget.community.sportCategory; 
    
    // Validasi kategori agar tidak crash jika kode di DB tidak ada di list lokal
    bool valid = _categories.any((c) => c['value'] == _category);
    if (!valid) _category = 'FL'; 
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Community", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2E7D32), // Hijau senada Dashboard
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Bagian Gambar dihapus demi efisiensi
            const Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFFE8F5E9),
                child: Icon(Icons.groups, size: 40, color: Color(0xFF2E7D32)),
              ),
            ),
            const SizedBox(height: 24),

            TextFormField(
              initialValue: _title,
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
                    initialValue: _city,
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
              initialValue: _description,
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
                  
                  // Mengirim data teks saja melalui service post biasa
                  final success = await _service.editCommunity(
                    request, 
                    widget.community.id,
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
                        const SnackBar(content: Text("Komunitas berhasil diperbarui!"))
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Gagal memperbarui komunitas."))
                      );
                    }
                  }
                }
              },
              child: const Text(
                "Simpan Perubahan", 
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
              ),
            ),
          ],
        ),
      ),
    );
  }
}