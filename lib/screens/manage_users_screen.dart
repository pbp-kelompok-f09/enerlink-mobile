import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import '../models/admin_user_model.dart';
import '../services/admin_dashboard_service.dart';
import 'add_user_screen.dart';
import 'edit_user_screen.dart'; 

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final AdminDashboardService _service = AdminDashboardService();

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Manage Users", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2962FF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<AdminUser>>(
        future: _service.fetchUsers(request),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada user."));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final user = snapshot.data![index];
              return _buildUserCard(user, request);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final refresh = await Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const AddUserScreen())
          );
          if (refresh == true) {
            setState(() {});
          }
        },
        label: const Text("Add User", style: TextStyle(color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xFF2962FF),
      ),
    );
  }

  // --- WIDGET KARTU USER (YANG SUDAH DIPERBAIKI) ---
  Widget _buildUserCard(AdminUser user, CookieRequest request) {
    // Tentukan Warna Badge Role
    Color badgeColor;
    Color badgeTextColor;
    if (user.role == "Developer") {
      badgeColor = Colors.purple.shade100;
      badgeTextColor = Colors.purple.shade800;
    } else if (user.role == "Admin Community") {
      badgeColor = Colors.green.shade100;
      badgeTextColor = Colors.green.shade800;
    } else {
      badgeColor = Colors.grey.shade200;
      badgeTextColor = Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.all(12), // Padding sedikit dikecilkan biar compact
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row Atas: Avatar + Info + Icons
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: user.profilePicture.isNotEmpty
                    ? NetworkImage(user.profilePicture)
                    : null,
                child: user.profilePicture.isEmpty
                    ? Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : "?",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                      )
                    : null, 
              ),
              const SizedBox(width: 12),
              
              // 2. Info Tengah (Nama, Role, Username)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    // Badge Role dipindah ke sini biar rapi
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(6)),
                      child: Text(user.role, style: TextStyle(color: badgeTextColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 4),
                    Text("@${user.username}", style: const TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),

              // 3. Icons Edit & Delete (Sejajar di Kanan Atas)
              Row(
                mainAxisSize: MainAxisSize.min, // Biar gak makan tempat
                children: [
                  IconButton(
                    padding: EdgeInsets.zero, // Biar icon rapat
                    constraints: const BoxConstraints(), // Hapus default constraint
                    icon: const Icon(Icons.edit, color: Colors.amber),
                    onPressed: () async {
                      final refresh = await Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => EditUserScreen(user: user)
                        )
                      );
                      if (refresh == true) setState(() {});
                    },
                  ),
                  const SizedBox(width: 16), // Jarak antar icon
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteDialog(user, request),
                  ),
                ],
              ),
            ],
          ),

          const Divider(height: 20, thickness: 0.5),

          // Row Bawah: Email & Wallet (Info Tambahan)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Email
              Flexible(
                child: Row(
                  children: [
                    const Icon(Icons.email_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(child: Text(user.email, style: const TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
              // Wallet
              Row(
                children: [
                  const Icon(Icons.account_balance_wallet_outlined, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text("Rp ${user.wallet}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(AdminUser user, CookieRequest request) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus User?"),
        content: Text("Yakin ingin menghapus ${user.username}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _service.deleteUser(request, user.id);
      if (!mounted) return;
      if (success) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User berhasil dihapus!")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal menghapus user.")));
      }
    }
  }
}