import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:enerlink_mobile/models/community.dart';
import 'package:enerlink_mobile/widgets/community_card.dart';

class CommunityListPage extends StatefulWidget {
  const CommunityListPage({super.key});

  @override
  State<CommunityListPage> createState() => _CommunityListPageState();
}

class _CommunityListPageState extends State<CommunityListPage> {
  Future<List<Community>> _loadCommunities() async {
    // URL to the Django backend API
    // Use 10.0.2.2 for Android Emulator to access localhost
    // Use your machine's LAN IP for physical devices
    String url = '${dotenv.env["BACKEND_URL"]}/community/json/';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return communityFromJson(response.body);
      } else {
        throw Exception(
          'Failed to load communities. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error connecting to backend: $e');
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
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Create Community feature coming soon!"),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Community>>(
        future: _loadCommunities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
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
                      "Error loading communities:\n${snapshot.error}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No communities available."));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return CommunityCard(community: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}
