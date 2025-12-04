import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "https://api.mec-ci.org/api/v1";

  // ----------------------------
  // 🔹 AuthService intégré ici
  // ----------------------------
  static Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'accept': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('refreshToken', data['refresh_token']);
      return true;
    }
    return false;
  }

  static Future<bool> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refreshToken');

    if (refreshToken == null) return false;

    final url = Uri.parse('$baseUrl/auth/refresh-token');
    final response = await http.get(
      url,
      headers: {'accept': 'application/json', 'Authorization': 'Bearer $refreshToken'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await prefs.setString('token', data['token']);
      return true;
    } else {
      // Token invalide → logout
      await prefs.remove('token');
      await prefs.remove('refreshToken');
      return false;
    }
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ----------------------------
  // 🔹 Signalements
  // ----------------------------
  static Future<List<dynamic>> fetchSignalements() async {
    final response = await http.get(Uri.parse("$baseUrl/signalement-citoyen"));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur récupération signalements");
    }
  }

  static Future<Map<String, dynamic>> createSignalement(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/signalement-citoyen"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur création signalement");
    }
  }

  // ----------------------------
  // 🔹 Action citoyenne
  // ----------------------------
  static Future<Map<String, dynamic>> createAction(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse("$baseUrl/action-citoyenne"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erreur création action citoyenne");
    }
  }

  // ----------------------------
  // 🔹 Exemple d’endpoint protégé
  // ----------------------------
  static Future<Map<String, dynamic>?> getProtectedData() async {
    String? token = await getToken();
    if (token == null) return null;

    final url = Uri.parse('$baseUrl/users'); // endpoint protégé
    var response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'accept': 'application/json'},
    );

    // Token expiré → refresh
    if (response.statusCode == 401) {
      bool refreshed = await refreshToken();
      if (refreshed) {
        token = await getToken();
        response = await http.get(
          url,
          headers: {'Authorization': 'Bearer $token', 'accept': 'application/json'},
        );
      } else {
        return null;
      }
    }

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }
}
