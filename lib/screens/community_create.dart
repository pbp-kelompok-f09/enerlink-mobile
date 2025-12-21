import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class CommunityCreatePage extends StatefulWidget {
  const CommunityCreatePage({super.key});

  @override
  State<CommunityCreatePage> createState() => _CommunityCreatePageState();
}

class _CommunityCreatePageState extends State<CommunityCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _cityController = TextEditingController();
  final _coverUrlController = TextEditingController();
  final _maxMembersController = TextEditingController();

  String? _selectedCategory;
  bool _isLoading = false;  

  final Map<String, Map<String, dynamic>> _sportCategories = {
    'SB': {'name': 'Sepak Bola', 'icon': Icons.sports_soccer},
    'BT': {'name': 'Basket', 'icon': Icons.sports_basketball},
    'BD': {'name': 'Bulu Tangkis', 'icon': Icons.sports_tennis}, // Using tennis as badminton icon
    'BL': {'name': 'Bola Voli', 'icon': Icons.sports_volleyball},
    'PD': {'name': 'Padel', 'icon': Icons.sports_baseball},
    'ES': {'name': 'E-Sport', 'icon': Icons.sports_esports},
    'FS': {'name': 'Fitness', 'icon': Icons.fitness_center},
    'FL': {'name': 'Futsal', 'icon': Icons.sports_soccer},
    'GF': {'name': 'Golf', 'icon': Icons.sports_golf},
    'HY': {'name': 'Hockey', 'icon': Icons.sports_hockey},
    'MS': {'name': 'Mini Soccer', 'icon': Icons.sports_soccer},
    'PC': {'name': 'Pickleball', 'icon': Icons.sports_baseball},
    'TM': {'name': 'Tenis Meja', 'icon': Icons.sports_tennis},
    'TS': {'name': 'Tenis', 'icon': Icons.sports_tennis},
    'VL': {'name': 'Bola Voli', 'icon': Icons.sports_volleyball},
    'LN': {'name': 'Lainnya', 'icon': Icons.sports},
  };

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
    _coverUrlController.dispose();
    _maxMembersController.dispose();
    super.dispose();
  }

  Future<void> _createCommunity() async {
    // Manual validation for sport category
    if (_selectedCategory == null || _selectedCategory!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih jenis olahraga terlebih dahulu')),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final request = context.read<CookieRequest>();

      // Prepare form data as JSON string
      final jsonData = jsonEncode({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'city': _cityController.text,
        'sport_category': _selectedCategory ?? '',
        'cover_urls': _coverUrlController.text.isNotEmpty ? _coverUrlController.text : '',
        'max_members': _maxMembersController.text.isNotEmpty ? _maxMembersController.text : '0',
      });

      print('Sending JSON data: $jsonData');

      final response = await request.postJson(
        'http://127.0.0.1:8000/community/create-flutter/',
        jsonData,
      );

      print('Raw response: $response');
      print('Response type: ${response.runtimeType}');

      // Handle different response types
      dynamic parsedResponse;
      if (response is String) {
        try {
          // Try to parse as JSON string
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

      print('Parsed response: $parsedResponse');

      if (parsedResponse['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Komunitas berhasil dibuat!')),
        );
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(parsedResponse['message'] ?? 'Gagal membuat komunitas')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Buat Komunitas Baru',
          style: TextStyle(
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0D47A1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.group,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Buat Komunitas Baru',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Isi informasi lengkap untuk membuat komunitas',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Form Card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                        // Nama Komunitas
                        const Text(
                          'Nama Komunitas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            hintText: 'Masukkan nama komunitas',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama komunitas tidak boleh kosong';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Deskripsi
                        const Text(
                          'Deskripsi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            hintText: 'Jelaskan tentang komunitas ini...',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Deskripsi tidak boleh kosong';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 20),

                        // Kota dan Kategori Row
                        Row(
                          children: [
                            // Kota
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Kota',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _cityController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[50],
                                      hintText: 'Contoh: Jakarta',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Kota tidak boleh kosong';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Jenis Olahraga
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Jenis Olahraga',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Sport Category Grid Selection
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      childAspectRatio: 1.2,
                                    ),
                                    itemCount: _sportCategories.length,
                                    itemBuilder: (context, index) {
                                      final categoryKey = _sportCategories.keys.elementAt(index);
                                      final category = _sportCategories[categoryKey]!;
                                      final isSelected = _selectedCategory == categoryKey;

                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedCategory = categoryKey;
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isSelected ? const Color(0xFF0D47A1) : Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: isSelected ? const Color(0xFF0D47A1) : Colors.grey[300]!,
                                              width: 2,
                                            ),
                                            boxShadow: isSelected
                                                ? [
                                                    BoxShadow(
                                                      color: const Color(0xFF0D47A1).withOpacity(0.3),
                                                      blurRadius: 8,
                                                      offset: const Offset(0, 4),
                                                    )
                                                  ]
                                                : null,
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                category['icon'],
                                                size: 32,
                                                color: isSelected ? Colors.white : const Color(0xFF0D47A1),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                category['name'],
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: isSelected ? Colors.white : Colors.black87,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  if (_selectedCategory == null)
                                    Container(
                                      margin: const EdgeInsets.only(top: 8),
                                      child: const Text(
                                        'Pilih jenis olahraga',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Foto Sampul
                        const Text(
                          'Foto Sampul',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Masukkan URL gambar atau kosongkan',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _coverUrlController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            hintText: 'https://example.com/image.jpg',
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Batas Anggota
                        const Text(
                          'Batas Anggota',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _maxMembersController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                            hintText: 'Kosongkan jika tidak ada batas',
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: const BorderSide(color: Colors.grey, width: 2),
                                ),
                                child: Text(
                                  'Batal',
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _createCommunity,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D47A1),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                  shadowColor: const Color(0xFF0D47A1).withOpacity(0.3),
                                ),
                                child: const Text(
                                  'Buat Komunitas',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
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
          ),
    );
  }
}