import 'dart:convert';
import 'package:citoyen_plus/models/signalement.dart';
import 'package:http/http.dart' as http;

class RecupererSignalementService {
  static Future<List<SignalementModel>> fetchAllSignalement(String token) async {
    final response = await http.get(
      Uri.parse('https://admin.mec-ci.org/api/v1/signalement-citoyen'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Si ton API renvoie { data: [...] }
      final List<dynamic> postsJson = jsonResponse['data'];

      return postsJson.map((json) => SignalementModel.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des signalements: ${response.body}');
    }
  }
}

