import 'dart:convert';
import 'package:http/http.dart' as http ;

import '../models/categorie_signalement_model.dart';

Future<List<CategorieSignalementModel>> fetchAllCategories(String token) async {
    final response = await http.get(
    Uri.parse('https://admin.mec-ci.org/api/v1/categorie-signalement'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = jsonDecode(response.body);

    return jsonResponse
        .map((json) => CategorieSignalementModel.fromJson(json))
        .toList();
  } else {
    throw Exception(
        'Erreur lors de la récupération des categories signalements: ${response.body}');
  }
}
