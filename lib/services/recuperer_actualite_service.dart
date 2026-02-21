import 'dart:convert';
import 'package:citoyen_plus/models/post.dart';
import 'package:http/http.dart' as http;

class RecupererActualiteService {
  static Future<List<PostModel>> fetchAllPosts(String token) async {
    final response = await http.get(
      Uri.parse('https://admin.mec-ci.org/api/v1/actualites'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    //print('📥 POSTS STATUS : ${response.statusCode}');
    //print('📥 POSTS BODY   : ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      final List<dynamic> postsJson = jsonResponse['data'];
      return postsJson.map((json) => PostModel.fromJson(json)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des posts: ${response.body}');
    }
  }
}