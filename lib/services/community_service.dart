import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart';
import '../models/community.dart';

class CommunityService {
  static String get baseUrl =>
      "https://vazha-khayri-enerlink-tk.pbp.cs.ui.ac.id/community";

  // Get all communities (JSON)
  static Future<List<Community>> getCommunities() async {
    try {
      final headers = await ApiClient.getAuthHeaders();
      final url = "$baseUrl/json/";

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((d) => Community.fromJson(d)).toList();
      } else {
        throw Exception('Failed to load communities: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error connecting to backend: $e');
    }
  }

  // Join a community
  // Note: The backend view for flutter join is `join_community_flutter`
  // path('<uuid:community_id>/join-flutter/', views.join_community_flutter, name='join_community_flutter'),
  static Future<bool> joinCommunity(String communityId) async {
    try {
      final headers = await ApiClient.getAuthHeaders();
      final url = "$baseUrl$communityId/join-flutter/";

      final response = await http.post(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'success';
      } else {
        return false;
      }
    } catch (e) {
      print("Error joining community: $e");
      return false;
    }
  }
}
