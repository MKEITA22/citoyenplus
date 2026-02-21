import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../models/signalement.dart';


class ApiService {
  static const String baseUrl = 'https://admin.mec-ci.org/api/v1';  

  static Map<String, String> headers(String token) => {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  // GET ACTUALITE
  static Future<List<PostModel>> fetchPosts(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/actualites/{id}'),
      headers: headers(token),
    );

    final data = jsonDecode(response.body);

    return (data['data'] as List)
        .map((e) => PostModel.fromJson(e))
        .toList();
  }

  // GET SIGNALEMENTS
  static Future<List<SignalementModel>> fetchSignalements(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/signalement-citoyen'),
      headers: headers(token),
    );

    final data = jsonDecode(response.body);

    return (data['data'] as List)
        .map((e) => SignalementModel.fromJson(e))
        .toList();
  }

  // CREER ACTUALITE
  static Future<bool> createPost({
    required String token,
    required String title,
    required String description,
    File? image, required String imagePath,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/actualites'),
    );

    request.headers.addAll(headers(token));
    request.fields['title'] = title;
    request.fields['description'] = description;

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
      ));
    }

    final response = await request.send();
    return response.statusCode == 201;
  }

  // CREER SIGNALEMENT
  static Future<bool> createSignalement({
    required String token,
    required String description,
    required String categorie,
    File? image, required String imagePath,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/signalement-CITOYEN'),
    );

    request.headers.addAll(headers(token));
    request.fields['description'] = description;
    request.fields['categorie'] = categorie;

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
      ));
    }

    final response = await request.send();
    return response.statusCode == 201;
  }

  // 🔹 Récupérer les signalements
  static Future<List<SignalementModel>> fetchAllSignalements(String token) async {
    final url = Uri.parse('$baseUrl/signalement-citoyen');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => SignalementModel.fromJson(e)).toList();
    } else {
      throw Exception('Erreur chargement signalements');
    }
  }
}


