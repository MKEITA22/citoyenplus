import 'dart:convert';
import 'dart:io';
import 'package:citoyen_plus/models/signalement.dart';
import 'package:http/http.dart' as http;

Future<SignalementModel> createSignalement({
  required String titre,
  required String description,
  required String categorieId,
  required String adresse,
  required double latitude,
  required double longitude,
  required String token,
  File? photo,
}) async {
  final uri = Uri.parse('https://admin.mec-ci.org/api/v1/signalement-citoyen');

  if (photo != null) {
    // ── Debug photo ────────────────────────────────────────────────────────
    //print('📸 Photo path     : ${photo.path}');
    //print('📸 Photo exists   : ${await photo.exists()}');
    //print('📸 Photo size     : ${await photo.length()} bytes');

    // ── Envoi multipart ────────────────────────────────────────────────────
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['titre'] = titre
      ..fields['description'] = description
      ..fields['categorieId'] = categorieId
      ..fields['adresse'] = adresse
      ..fields['latitude'] = latitude.toString()
      ..fields['longitude'] = longitude.toString()
      // ⚠️ Si ça ne marche pas avec 'photo', essaie 'image' ou 'file'
      ..files.add(await http.MultipartFile.fromPath('photo', photo.path));

    //print('📤 Champs envoyés : ${request.fields}');
    //print('📤 Fichiers       : ${request.files.map((f) => f.filename)}');

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    //print('📥 STATUS CODE    : ${response.statusCode}');
    //print('📥 RESPONSE BODY  : ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SignalementModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Échec création signalement. Status: ${response.statusCode}, Body: ${response.body}',
      );
    }
  } else {
    // ── Envoi JSON simple (sans photo) ─────────────────────────────────────
    //print('📤 Envoi sans photo');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'titre': titre,
        'description': description,
        'categorieId': categorieId,
        'adresse': adresse,
        'latitude': latitude,
        'longitude': longitude,
      }),
    );

    //print('📥 STATUS CODE    : ${response.statusCode}');
    //print('📥 RESPONSE BODY  : ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return SignalementModel.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    } else {
      throw Exception(
        'Échec création signalement. Status: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }
}