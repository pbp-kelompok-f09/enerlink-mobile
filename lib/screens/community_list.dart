import 'package:flutter/material.dart';
import 'package:enerlink_mobile/models/community.dart';
import 'package:enerlink_mobile/widgets/community_card.dart';
import 'package:enerlink_mobile/screens/community_create.dart';
import 'package:enerlink_mobile/screens/community_join_confirmation.dart';
import 'package:enerlink_mobile/services/api_client.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommunityListPage extends StatefulWidget {
  const CommunityListPage({super.key});

  @override
  State<CommunityListPage> createState() => _CommunityListPageState();
}

class _CommunityListPageState extends State<CommunityListPage> {
  String _searchQuery = '';
  String? _selectedCategory;
  String? _selectedCity;
  List<Community> _communities = [];
  bool _isLoading = true;
  String? _error;

  // Daftar opsi filter
  final List<String> _sportCategories = ['PD', 'SB', 'BT', 'BD', 'BL'];
  final List<String> _cities = ['Jakarta', 'Depok', 'Tangerang', 'Bekasi'];

  @override
  void initState() {
    super.initState();
    _checkLoginAndLoadCommunities();
  }

  Future<void> _checkLoginAndLoadCommunities() async {
    final loggedIn = await ApiClient.isLoggedIn();
    if (!loggedIn && mounted) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }
    _loadCommunities();
  }

  Future<void> _loadCommunities() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final headers = await ApiClient.getAuthHeaders();
      final url =
          "https://vazha-khayri-enerlink-tk.pbp.cs.ui.ac.id/community/json/";

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode != 200) {
        throw Exception('Failed to load communities: ${response.statusCode}');
      }

      final List<dynamic> data = json.decode(response.body);

      List<Community> communities = [];
      for (var d in data) {
        if (d != null) {
          communities.add(Community.fromJson(d));
        }
      }

      // Apply filters
      List<Community> filtered = communities.where((community) {
        final fields = community.fields;

        // Search filter
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          if (!fields.title.toLowerCase().contains(query) &&
              !fields.description.toLowerCase().contains(query)) {
            return false;
          }
        }

        // Category filter
        if (_selectedCategory != null && _selectedCategory!.isNotEmpty) {
          if (fields.sportCategory != _selectedCategory) {
            return false;
          }
        }

        // City filter
        if (_selectedCity != null && _selectedCity!.isNotEmpty) {
          if (fields.city.toLowerCase() != _selectedCity!.toLowerCase()) {
            return false;
          }
        }

        return true;
      }).toList();

      if (mounted) {
        setState(() {
          _communities = filtered;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _applyFilters() {
    _loadCommunities();
  }

  void _clearFilters() {
    setState(() {
      _searchQuery = '';
      _selectedCategory = null;
      _selectedCity = null;
    });
    _loadCommunities();
  }

  Future<void> _joinCommunity(Community community) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CommunityJoinConfirmationPage(community: community),
      ),
    );
    if (result == true) {
      // Refresh list if join was successful
      _loadCommunities();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Communities',
          style: TextStyle(
            color: Color(0xFF0D47A1),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0D47A1)),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add_circle,
              color: Color(0xFF0D47A1),
              size: 28,
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CommunityCreatePage(),
                ),
              );
              if (result == true) {
                // Refresh list if community was created successfully
                _loadCommunities();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Section
          Container(
            color: Colors.grey[50],
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search Input
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search communities...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  onSubmitted: (_) => _applyFilters(),
                ),
                const SizedBox(height: 12),

                // Filter Row
                Row(
                  children: [
                    // Sport Category Filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Sport Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        value: _selectedCategory,
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All Categories'),
                          ),
                          ..._sportCategories.map(
                            (category) => DropdownMenuItem(
                              value: category,
                              child: Text(category),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),

                    // City Filter
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'City',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        value: _selectedCity,
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All Cities'),
                          ),
                          ..._cities.map(
                            (city) => DropdownMenuItem(
                              value: city,
                              child: Text(city),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCity = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _applyFilters,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D47A1),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Search'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _clearFilters,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Clear'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Create Community Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CommunityCreatePage(),
                    ),
                  );
                  if (result == true) {
                    // Refresh list if community was created successfully
                    _loadCommunities();
                  }
                },
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'Buat Komunitas Baru',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xFF0D47A1).withOpacity(0.3),
                ),
              ),
            ),
          ),

          // Results Count
          if (!_isLoading && _error == null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Found ${_communities.length} communit${_communities.length == 1 ? 'y' : 'ies'}',
                style: const TextStyle(color: Colors.grey),
              ),
            ),

          // Community List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Error loading communities:\n$_error",
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  )
                : _communities.isEmpty
                ? const Center(child: Text("No communities available."))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _communities.length,
                    itemBuilder: (context, index) {
                      final community = _communities[index];
                      final isJoined = false;

                      return CommunityCard(
                        community: community,
                        isJoined: isJoined,
                        onJoinTap: () => _joinCommunity(community),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
