import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:enerlink_mobile/models/community.dart';
import 'package:enerlink_mobile/screens/community_detail.dart';
import 'dart:convert';

class CommunityJoinConfirmationPage extends StatefulWidget {
  final Community community;

  const CommunityJoinConfirmationPage({
    super.key,
    required this.community,
  });

  @override
  State<CommunityJoinConfirmationPage> createState() => _CommunityJoinConfirmationPageState();
}

class _CommunityJoinConfirmationPageState extends State<CommunityJoinConfirmationPage> {
  bool _isLoading = false;

  Future<void> _joinCommunity() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final request = context.read<CookieRequest>();

      print('Attempting to join community ${widget.community.pk}');

      final response = await request.postJson(
        'http://127.0.0.1:8000/community/${widget.community.pk}/join-flutter/',
        jsonEncode({}),
      );

      print('Join response: $response');
      print('Response type: ${response.runtimeType}');

      // Handle different response types
      dynamic parsedResponse;
      if (response is String) {
        try {
          parsedResponse = jsonDecode(response);
        } catch (e) {
          print('Failed to parse response as JSON: $e');
          throw Exception('Server returned invalid JSON response: $response');
        }
      } else if (response is Map<String, dynamic>) {
        parsedResponse = response;
      } else {
        throw Exception('Unexpected response type: ${response.runtimeType}');
      }

      print('Parsed join response: $parsedResponse');

      if (parsedResponse['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Berhasil bergabung dengan ${widget.community.fields.title}!')),
        );
        // Navigate to community detail page instead of just popping
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CommunityDetailPage(community: widget.community),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(parsedResponse['message'] ?? 'Gagal bergabung')),
        );
      }
    } catch (e) {
      print('Error joining community: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final fields = widget.community.fields;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Gabung ${fields.title}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF2563EB)),
                  label: const Text(
                    'Kembali ke Daftar Komunitas',
                    style: TextStyle(color: Color(0xFF2563EB)),
                  ),
                ),

                const SizedBox(height: 16),

                // Community Info Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cover Image
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: fields.coverUrls != null && fields.coverUrls!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: fields.coverUrls!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: const Center(child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                height: 200,
                                color: const Color(0xFF0D47A1),
                                child: Center(
                                  child: Text(
                                    fields.title.isNotEmpty ? fields.title[0].toUpperCase() : 'C',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 200,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  fields.title.isNotEmpty ? fields.title[0].toUpperCase() : 'C',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                      ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              fields.title,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Stats
                            Row(
                              children: [
                                _buildStatItem(
                                  Icons.group,
                                  '${fields.totalMembers ?? 0} Anggota',
                                ),
                                const SizedBox(width: 24),
                                _buildStatItem(
                                  Icons.calendar_today,
                                  'Dibuat ${_formatDateTime(fields.createdAt)}',
                                ),
                                const SizedBox(width: 24),
                                _buildStatItem(
                                  Icons.category,
                                  fields.sportCategory,
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Description
                            Container(
                              padding: const EdgeInsets.only(top: 24),
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: Colors.grey, width: 1),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Tentang Komunitas',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    fields.description,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                      height: 1.6,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Benefits Section
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Dengan Bergabung, Anda Akan:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildBenefitItem('Mengikuti kegiatan dan event yang diselenggarakan komunitas'),
                                  _buildBenefitItem('Bertemu dengan ${fields.totalMembers ?? 0} anggota lainnya yang memiliki minat sama'),
                                  _buildBenefitItem('Mendapatkan notifikasi kegiatan terbaru'),
                                  _buildBenefitItem('Akses ke diskusi dan informasi komunitas'),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            // Action Buttons
                            Column(
                              children: [
                                // Join Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _joinCommunity,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 4,
                                      shadowColor: Colors.green.withOpacity(0.3),
                                    ),
                                    child: const Text(
                                      'Ya, Saya Ingin Bergabung',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // View Detail Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CommunityDetailPage(community: widget.community),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0D47A1),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 4,
                                      shadowColor: const Color(0xFF0D47A1).withOpacity(0.3),
                                    ),
                                    child: const Text(
                                      'Lihat Detail Lengkap',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Cancel Button
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      side: const BorderSide(color: Colors.grey, width: 2),
                                    ),
                                    child: const Text(
                                      'Batalkan',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildStatItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'TBA';
    return '${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month - 1];
  }
}