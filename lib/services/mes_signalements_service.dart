import 'dart:convert';
import 'package:citoyen_plus/models/signalement.dart';
import 'package:http/http.dart' as http;

class MesSignalementsService {
  static Future<List<SignalementModel>> fetchMesSignalements(
      String token, String citoyenId) async {
    final response = await http.get(
      Uri.parse('https://admin.mec-ci.org/api/v1/signalement-citoyen'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> data = jsonResponse['data'];

      // ✅ Filtre uniquement les signalements de l'utilisateur connecté
      return data
          .map((json) => SignalementModel.fromJson(json))
          .where((s) => s.citoyenId == citoyenId)
          .toList()
        ..sort((a, b) {
          final dateA = a.createdAt ?? DateTime(0);
          final dateB = b.createdAt ?? DateTime(0);
          return dateB.compareTo(dateA); // du plus récent au plus ancien
        });
    } else {
      throw Exception(
          'Erreur lors de la récupération: ${response.body}');
    }
  }
}