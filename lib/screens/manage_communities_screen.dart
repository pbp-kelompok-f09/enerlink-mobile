import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../models/admin_community_model.dart';
import '../services/admin_dashboard_service.dart';
// Import Screen Baru
import 'add_community_screen.dart';
import 'edit_community_screen.dart';

class ManageCommunitiesScreen extends StatefulWidget {
  const ManageCommunitiesScreen({super.key});

  @override
  State<ManageCommunitiesScreen> createState() => _ManageCommunitiesScreenState();
}

class _ManageCommunitiesScreenState extends State<ManageCommunitiesScreen> {
  final AdminDashboardService _service = AdminDashboardService();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Manage Communities", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2E7D32),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<AdminCommunity>>(
        future: _service.fetchCommunities(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada komunitas."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // --- BAGIAN YANG DIGANTI: THUMBNAIL FIX (Line 54-65) ---
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.groups, 
                          color: Colors.green, 
                          size: 30
                        ),
                      ),
                      const SizedBox(width: 14),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text("${item.city} • ${item.sportCategory}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.person, size: 14, color: Colors.grey[600]),
                                const SizedBox(width: 4),
                                Text("${item.memberCount} Members", style: const TextStyle(fontSize: 12)),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(4)),
                                  child: Text(item.status, style: TextStyle(fontSize: 10, color: Colors.green.shade800, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      // TOMBOL EDIT (Navigasi ke EditCommunityScreen)
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.amber),
                        onPressed: () async {
                          final refresh = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditCommunityScreen(community: item),
                            ),
                          );
                          if (refresh == true) setState(() {});
                        },
                      ),
                      
                      // TOMBOL DELETE
                      IconButton(
                        onPressed: () => _showDeleteDialog(item, request),
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
      
      // TOMBOL ADD (Floating Action Button)
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final refresh = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCommunityScreen()),
          );
          if (refresh == true) setState(() {});
        },
        label: const Text("Add Community", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xFF2E7D32),
      ),
    );
  }

  void _showDeleteDialog(AdminCommunity item, CookieRequest request) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Komunitas?"),
        content: Text("Yakin ingin menghapus ${item.title}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _service.deleteCommunity(request, item.id);
      if (!mounted) return;
      if (success) {
        setState(() {}); 
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Komunitas berhasil dihapus!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal menghapus komunitas.")));
      }
    }
  }
}