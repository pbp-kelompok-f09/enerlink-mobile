import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart'; // Jangan lupa import ini!
import '../services/admin_dashboard_service.dart';
import '../models/admin_dashboard_model.dart';

class AdminDashboardProvider extends ChangeNotifier {
  AdminDashboardStats? _stats;
  bool _loading = false;
  String? _errorMessage; // Tambahan: Biar bisa nampilin error di UI kalau gagal

  AdminDashboardStats? get stats => _stats;
  bool get loading => _loading;
  String? get errorMessage => _errorMessage;

  final _service = AdminDashboardService();

  // UBAH PARAMETER: Dari (String token) menjadi (CookieRequest request)
  Future<void> loadStats(CookieRequest request) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Panggil service dengan parameter request
      _stats = await _service.fetchStats(request);
    } catch (e) {
      debugPrint(e.toString());
      _errorMessage = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}