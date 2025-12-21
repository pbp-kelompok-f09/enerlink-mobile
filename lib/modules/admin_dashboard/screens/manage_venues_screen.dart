import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../models/admin_venue_model.dart';
import '../services/admin_dashboard_service.dart';
import 'add_venue_screen.dart';
import 'edit_venue_screen.dart'; // <--- 1. Pastikan ini ada!

class ManageVenuesScreen extends StatefulWidget {
  const ManageVenuesScreen({super.key});

  @override
  State<ManageVenuesScreen> createState() => _ManageVenuesScreenState();
}

class _ManageVenuesScreenState extends State<ManageVenuesScreen> {
  final AdminDashboardService _service = AdminDashboardService();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Manage Venues", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF9A825),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<AdminVenue>>(
        future: _service.fetchVenues(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada venue."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final venue = snapshot.data![index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar Venue
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade200,
                          child: venue.imageUrl.isNotEmpty
                              ? Image.network(venue.imageUrl, fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.broken_image))
                              : const Icon(Icons.stadium, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 12),
                      
                      // Info Venue
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(venue.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            _buildCategoryChips(venue.category),
                            const SizedBox(height: 4),
                            Text(venue.address, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            const SizedBox(height: 6),
                            Text("Rp ${venue.price} / sesi", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green)),
                          ],
                        ),
                      ),

                      // --- TOMBOL EDIT (YANG DIPERBAIKI) ---
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.amber),
                        onPressed: () async {
                          // Navigasi ke EditVenueScreen (Bukan Dialog lagi)
                          final refresh = await Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => EditVenueScreen(venue: venue) // Kirim data venue
                            )
                          );
                          
                          // Refresh halaman jika balik dari edit
                          if (refresh == true) {
                            setState(() {});
                          }
                        },
                      ),
                      // -------------------------------------

                      IconButton(
                        onPressed: () => _showDeleteDialog(venue, request),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final refresh = await Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const AddVenueScreen())
          );
          if (refresh == true) {
            setState(() {});
          }
        },
        label: const Text("Add Venue", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xFFF9A825),
      ),
    );
    
  }

  void _showDeleteDialog(AdminVenue venue, CookieRequest request) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Venue?"),
        content: Text("Yakin ingin menghapus ${venue.name}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _service.deleteVenue(request, venue.id);
      if (!mounted) return;
      if (success) {
        setState(() {}); 
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Venue berhasil dihapus!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal menghapus venue.")));
      }
    }
  }

  // --- FUNGSI PARSING KATEGORI ---
  Widget _buildCategoryChips(String rawCategory) {
    // 1. Bersihkan kurung siku '[' dan ']'
    String cleanString = rawCategory.replaceAll('[', '').replaceAll(']', '');
    
    // 2. Pecah string berdasarkan koma ',' menjadi List
    List<String> categories = cleanString.split(',');

    // 3. Tampilkan sebagai Wrap (biar kalau banyak dia turun ke bawah)
    return Wrap(
      spacing: 6,    // Jarak horizontal antar kotak
      runSpacing: 4, // Jarak vertikal antar baris
      children: categories.map((cat) {
        String label = cat.trim(); // Hapus spasi berlebih
        if (label.isEmpty) return const SizedBox(); // Skip kalau kosong

        // Return Kotak Kecil (Badge)
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.lightBlue.shade50, // Warna background biru muda
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.blue.shade200, width: 0.5),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10, 
              color: Colors.blue.shade800, 
              fontWeight: FontWeight.w600
            ),
          ),
        );
      }).toList(),
    );
  }
}