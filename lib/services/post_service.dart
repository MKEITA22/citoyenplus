import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';



Future<PostModel> createArticle(String title, String excerpt, String content, String token, {required DateTime date}) async {
  final response = await http.post(
    Uri.parse('https://admin.mec-ci.org/api/v1/actualites'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $token",
    },
    body: jsonEncode(<String, String>{
      'title': title,
      'excerpt': excerpt,
      'content': content,
      'date': date.toIso8601String(),
    }),
  );
  // 🔥 DEBUG
  // print("STATUS CODE: ${response.statusCode}");
  // print("RESPONSE BODY: ${response.body}");
  // print("RESPONSE HEADERS: ${response.headers}");

  if (response.statusCode == 200 || response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return PostModel.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    
    throw Exception('Failed to create article. Status: ${response.statusCode}, Body: ${response.body}');
  }
}


