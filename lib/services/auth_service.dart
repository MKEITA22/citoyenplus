import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'https://mec-ci.org/api/v1';

  // INSCRIPTION
  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/auth/register");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "fullname": name,
          "email": email,
          "phone": phone,
          "password": password,
        }),
      );

      if (!response.headers['content-type']!.contains('application/json')) {
        return {"success": false, "message": "Réponse invalide du serveur"};
      }

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Sauvegarde du token si existant
        if (data['token'] != null) {
          await saveToken(data['token']);
        }
        return {"success": true, "data": data};
      } else {
        return {
          "success": false,
          "message": data["message"] ?? "Erreur lors de l'inscription",
        };
      }
    } catch (_) {
      return {
        "success": false,
        "message": "Erreur réseau, réessaie encore 🙏🏾",
      };
    }
  }

  // CONNEXION
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse("$baseUrl/auth/login");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"email": email, "password": password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['token'] != null) {
          await saveToken(data['token']);
        }
        return {"success": true, "data": data};
      } else {
        return {
          "success": false,
          "message": data["message"] ?? "Email ou mot de passe incorrect",
        };
      }
    } catch (e) {
      return {"success": false, "message": "Impossible de se connecter"};
    }
  }

  // 🔑 MÉTHODES DE GESTION DU TOKEN
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
