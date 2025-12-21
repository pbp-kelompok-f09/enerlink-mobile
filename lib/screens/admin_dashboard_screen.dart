import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import '../providers/admin_dashboard_provider.dart';
import '../models/admin_dashboard_model.dart';
import 'manage_users_screen.dart';
import 'manage_communities_screen.dart';
import 'manage_venues_screen.dart';
import 'package:enerlink_mobile/services/api_service.dart';
import 'package:enerlink_mobile/services/api_client.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final request = context.read<CookieRequest>();
      final provider = context.read<AdminDashboardProvider>();
      provider.loadStats(request);
    });
  }

  Future<void> _logout() async {
    await ApiClient.logout();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/account', (r) => false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logged out')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF3F51B5);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Admin Dashboard",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            IconButton(
              tooltip: 'Logout',
              onPressed: _logout,
              icon: const Icon(Icons.logout, color: Colors.redAccent),
            ),
          ],
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.grey[50],
      body: Consumer<AdminDashboardProvider>(
        builder: (context, prov, _) {
          if (prov.loading)
            return const Center(child: CircularProgressIndicator());

          final s = prov.stats;
          if (s == null) {
            return Center(
              child: ElevatedButton(
                onPressed: () => prov.loadStats(context.read<CookieRequest>()),
                child: const Text("Muat Ulang Data"),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // === HEADER DATE ===
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Admin Dashboard",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Overview for ${s.generatedAt}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                // === 1. STATS CARDS (GRID 5 ITEMS) ===
                // Tetap pakai ini karena informatif
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildStatCard(
                      "Total Venues",
                      s.totalVenues.toString(),
                      Colors.blue.shade50,
                      Colors.blue.shade800,
                    ),
                    _buildStatCard(
                      "Total Users",
                      s.totalUsers.toString(),
                      Colors.green.shade50,
                      Colors.green.shade800,
                    ),
                    _buildStatCard(
                      "Communities",
                      s.totalCommunities.toString(),
                      Colors.yellow.shade50,
                      Colors.yellow.shade900,
                    ),
                    _buildStatCard(
                      "Events",
                      s.totalEvents.toString(),
                      Colors.purple.shade50,
                      Colors.purple.shade800,
                    ),
                    _buildStatCard(
                      "Bookings",
                      s.totalBookings.toString(),
                      Colors.red.shade50,
                      Colors.red.shade800,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // === 2. RECENT VENUES (LIST HORIZONTAL - BALIK LAGI) ===
                if (s.recentVenues.isNotEmpty) ...[
                  const Text(
                    "Recent Venues",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 240, // Tinggi area scroll
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal, // Scroll Samping
                      itemCount: s.recentVenues.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        return _buildVenueCard(s.recentVenues[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // === 3. ACTIVE COMMUNITIES (LIST HORIZONTAL - BALIK LAGI) ===
                if (s.activeCommunities.isNotEmpty) ...[
                  const Text(
                    "Active Communities",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: s.activeCommunities.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        return _buildCommunityCard(s.activeCommunities[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                // === 4. ADMIN SUMMARY (TETAP ADA) ===
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Admin Summary",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildSummaryRow("Venues", s.totalVenues.toString()),
                      _buildSummaryRow("Users", s.totalUsers.toString()),
                      _buildSummaryRow(
                        "Communities",
                        s.totalCommunities.toString(),
                      ),
                      _buildSummaryRow("Events", s.totalEvents.toString()),
                      _buildSummaryRow("Bookings", s.totalBookings.toString()),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // === 5. QUICK ACTIONS ===
                const Text(
                  "Quick Actions",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildActionButtons(
                        label: "Manage Users",
                        color: const Color(0xFF2962FF),
                        icon: Icons.people,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManageUsersScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildActionButtons(
                        label: "Manage Communities",
                        color: const Color(0xFF2E7D32),
                        icon: Icons.groups,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ManageCommunitiesScreen(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildActionButtons(
                        label: "Manage Venues",
                        color: const Color(0xFFF9A825),
                        icon: Icons.stadium,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ManageVenuesScreen(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildStatCard(
    String title,
    String value,
    Color bgColor,
    Color textColor,
  ) {
    // Ukuran tetap responsif setengah layar
    double cardWidth = (MediaQuery.of(context).size.width - 32 - 12) / 2;

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 2),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVenueCard(VenueItem venue) {
    // Kita kasih WIDTH FIX (180) lagi biar pas di scroll horizontal
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                color: Colors.grey.shade200,
                child: venue.imageUrl.isNotEmpty
                    ? Image.network(
                        venue.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) =>
                            const Icon(Icons.broken_image, color: Colors.grey),
                      )
                    : const Icon(Icons.image, size: 40, color: Colors.grey),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  venue.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                // Chips Categories (Horizontal scrollable if too many)
                Center(child: _buildCategoryChips(venue.category)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityCard(CommunityItem community) {
    // Kita kasih WIDTH FIX (140)
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
              ),
              child: community.thumbnail.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        community.thumbnail,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) =>
                            const Icon(Icons.groups, color: Colors.grey),
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.groups,
                        color: Colors.grey.shade400,
                        size: 40,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 10),

          // --- PERBAIKAN DI SINI ---

          // 1. Tampilkan JUDUL (Nama Komunitas)
          Text(
            community.title, // <--- Pakai .title (Bukan sportCategory)
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ), // Font agak dibesarin dikit
          ),

          const SizedBox(height: 4),

          // 2. Tampilkan Kategori (Yang sudah diparsing biar gak singkatan)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _parseCategory(
                community.sportCategory,
              ), // <--- Pakai fungsi helper biar 'FL' jadi 'Futsal'
              style: TextStyle(
                fontSize: 9,
                color: Colors.green.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
      ),
    );
  }

  Widget _buildCategoryChips(String rawCategory) {
    String cleanString = rawCategory.replaceAll('[', '').replaceAll(']', '');
    List<String> categories = cleanString.split(',');
    // Ambil max 2 biar gak overflow di kartu kecil
    var displayCategories = categories.take(1).toList();
    if (categories.length > 1)
      displayCategories.add("+${categories.length - 1}");

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4,
      runSpacing: 2,
      children: displayCategories.map((cat) {
        String label = cat.trim();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: Colors.blue.shade800,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- HELPER BUAT UBAH SINGKATAN JADI TEKS ---
  // Taruh ini di paling bawah (dekat _buildCategoryChips)
  String _parseCategory(String code) {
    switch (code.toUpperCase()) {
      case 'FL':
        return 'Futsal';
      case 'BD':
        return 'Badminton';
      case 'BT':
        return 'Basket';
      case 'GF':
        return 'Golf'; // Asumsi GS = Golf atau Gym
      case 'TN':
        return 'Tennis';
      case 'PD':
        return 'Padel';
      case 'MS':
        return 'Mini Soccer';
      case 'ES':
        return 'E-Sports';
      // Tambahkan kode lain sesuai database Django kamu
      default:
        return code; // Kalau kode gak dikenal, tampilkan apa adanya
    }
  }
}
