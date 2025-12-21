import 'package:pbp_django_auth/pbp_django_auth.dart';
// Import kedua model yang kita punya
import '../models/admin_dashboard_model.dart';
import '../models/admin_user_model.dart'; 
import '../models/admin_venue_model.dart';
import '../models/admin_community_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_client.dart'; // Import ApiClient

class AdminDashboardService {
  
  // 1. Fungsi Ambil Statistik (Untuk Dashboard Utama)
  Future<AdminDashboardStats> fetchStats(CookieRequest request) async {
    final String url = '${ApiClient.baseUrl}/admin-dashboard/api/stats/';
    
    final response = await request.get(url);

    return AdminDashboardStats.fromJson(response);
  }

  // 2. Fungsi Ambil Daftar User (Ini yang tadi ERROR karena belum ada)
  Future<List<AdminUser>> fetchUsers(CookieRequest request) async {
    final String url = '${ApiClient.baseUrl}/admin-dashboard/api/users/';
    
    final response = await request.get(url);

    // Konversi JSON List menjadi List<AdminUser>
    List<AdminUser> listUsers = [];
    for (var d in response) {
      if (d != null) {
        listUsers.add(AdminUser.fromJson(d));
      }
    }
    return listUsers;
  }

  // Fungsi Hapus User
  Future<bool> deleteUser(CookieRequest request, int userId) async {
    final String url = '${ApiClient.baseUrl}/admin-dashboard/api/users/delete/$userId/';
    
    try {
      final response = await request.post(url, {});
      // Cek status code atau response. Biasanya kalau redirect (302) dianggap sukses di PBP
      return true; 
    } catch (e) {
      return false;
    }
  }

  // --- VENUE SERVICES ---
  Future<List<AdminVenue>> fetchVenues(CookieRequest request) async {
    final String url = '${ApiClient.baseUrl}/admin-dashboard/api/venues/';
    final response = await request.get(url);
    List<AdminVenue> list = [];
    for (var d in response) {
      if (d != null) list.add(AdminVenue.fromJson(d));
    }
    return list;
  }

  Future<bool> deleteVenue(CookieRequest request, String venueId) async {
    final String url = '${ApiClient.baseUrl}/admin-dashboard/api/venues/delete/$venueId/';
    try {
      final response = await request.post(url, {});
      return response['status'] == 'success';
    } catch (e) {
      return false;
    }
  }

  // --- COMMUNITY SERVICES ---
  Future<List<AdminCommunity>> fetchCommunities(CookieRequest request) async {
    final String url = '${ApiClient.baseUrl}/admin-dashboard/api/communities/';
    final response = await request.get(url);
    List<AdminCommunity> list = [];
    for (var d in response) {
      if (d != null) list.add(AdminCommunity.fromJson(d));
    }
    return list;
  }

  Future<bool> deleteCommunity(CookieRequest request, String communityId) async {
    final String url = '${ApiClient.baseUrl}/admin-dashboard/api/communities/delete/$communityId/';
    try {
      final response = await request.post(url, {});
      return response['status'] == 'success';
    } catch (e) {
      return false;
    }
  }

  // --- EDIT ACTIONS ---

  // --- VENUE WITH IMAGE ---

  Future<bool> addVenueWithImage(CookieRequest request, Map<String, String> data, {List<int>? imageBytes, String? filename}) async {
    final String url = '${ApiClient.baseUrl}/admin-dashboard/api/venues/add/';
    return _sendMultipartRequest(request, url, data, imageBytes, filename);
  }

  // Tambahkan/Ganti editVenue
  Future<bool> editVenue(CookieRequest request, String venueId, Map<String, String> data, {List<int>? imageBytes, String? filename}) async {
    final String url = '${ApiClient.baseUrl}/admin-dashboard/api/venues/edit/$venueId/';
    return _sendMultipartRequest(request, url, data, imageBytes, filename);
  }

  // --- HELPER KHUSUS UPLOAD GAMBAR ---
  // Taruh ini di bagian paling bawah class, sebelum kurung tutup '}'
  Future<bool> _sendMultipartRequest(CookieRequest request, String url, Map<String, String> fields, List<int>? fileBytes, String? filename) async {
    try {
      var uri = Uri.parse(url);
      var multipartRequest = http.MultipartRequest('POST', uri);

      // 1. Masukkan data teks
      multipartRequest.fields.addAll(fields);

      // 2. Masukkan File Gambar (jika ada)
      if (fileBytes != null) {
        String fName = filename ?? "upload.jpg";
        multipartRequest.files.add(
          http.MultipartFile.fromBytes(
            'image', // Key ini harus sama dengan di Django
            fileBytes,
            filename: fName,
          ),
        );
      }

      // 3. Masukkan Headers Auth
      multipartRequest.headers.addAll(request.headers);

      // 4. Kirim Request
      final streamedResponse = await multipartRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Gagal Upload: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error Multipart Request: $e");
      return false;
    }
  }

  // 1. Add Community (Kembali ke POST biasa)
  Future<bool> addCommunity(CookieRequest request, Map<String, dynamic> data) async {
    final String url = '${ApiClient.baseUrl}/admin-dashboard/api/communities/add/';
    try {
      final response = await request.post(url, data);
      return response['status'] == 'success';
    } catch (e) {
      return false;
    }
  }

  // 2. Edit Community (Kembali ke POST biasa)
  Future<bool> editCommunity(CookieRequest request, String id, Map<String, dynamic> data) async {
    final String url = '${ApiClient.baseUrl}/admin-dashboard/api/communities/edit/$id/';
    try {
      final response = await request.post(url, data);
      return response['status'] == 'success';
    } catch (e) {
      return false;
    }
  }

  // Ganti editUser lama dengan yang ini
  Future<bool> editUser(CookieRequest request, int id, Map<String, String> data, {List<int>? imageBytes, String? filename}) async {
    // Sesuaikan URL dengan punyamu (misal: https://vazha-khayri-enerlink.pbp.cs.ui.ac.id/admin-dashboard/api/users/edit/$id/)
    final String url = '${ApiClient.baseUrl}/admin-dashboard/api/users/edit/$id/';
    return _sendMultipartRequest(request, url, data, imageBytes, filename);
  }

  // --- ADD ACTIONS ---

  // Update fungsi addUser jadi support gambar
  Future<bool> addUser(CookieRequest request, Map<String, String> data, {List<int>? imageBytes, String? filename}) async {
    final String url = '${ApiClient.baseUrl}/admin-dashboard/api/users/add/';
    // Gunakan helper _sendMultipartRequest yang sudah kita buat sebelumnya
    return _sendMultipartRequest(request, url, data, imageBytes, filename);
  }

  // Ganti addVenue lama dengan yang ini
  Future<bool> addVenue(CookieRequest request, Map<String, String> data, {List<int>? imageBytes, String? filename}) async {
    final String url = '${ApiClient.baseUrl}/admin-dashboard/api/venues/add/';
    return _sendMultipartRequest(request, url, data, imageBytes, filename);
  }

  Future<bool> updateUserWithImage(CookieRequest request, int userId, Map<String, String> data, {List<int>? imageBytes, String? filename}) async {
    // URL Endpoint
    final String url = '${ApiClient.baseUrl}/admin-dashboard/api/users/update/$userId/';
    
    // Karena pbp_django_auth mungkin belum support full multipart dengan mudah,
    // Kita bisa gunakan pendekatan hybrid atau request manual jika perlu.
    // TAPI, CookieRequest biasanya punya method buat ini atau kita pakai http biasa dengan header cookie.
    
    // Cara Paling Aman (Manual Multipart Request):
    var uri = Uri.parse(url);
    var multipartRequest = http.MultipartRequest('POST', uri);

    // 1. Masukkan data teks (Fields)
    multipartRequest.fields.addAll(data);

    // 2. Masukkan File Gambar (jika ada)
    if (imageBytes != null && filename != null) {
      multipartRequest.files.add(
        http.MultipartFile.fromBytes(
          'image', // Key ini harus sama dengan di Django (request.FILES['image'])
          imageBytes,
          filename: filename,
        ),
      );
    }
    
    // 3. Masukkan Headers & Cookies (PENTING BIAR GAK 403)
    // Ambil headers dari CookieRequest yang sedang login
    multipartRequest.headers.addAll(request.headers); 

    try {
      final streamedResponse = await multipartRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        return true;
      } else {
        print("Gagal upload: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error Multipart: $e");
      return false;
    }
  }
}