import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignupTestScreen extends StatefulWidget {
  const SignupTestScreen({super.key});

  @override
  State<SignupTestScreen> createState() => _SignupTestScreenState();
}

class _SignupTestScreenState extends State<SignupTestScreen> {
  
  Future<void> userRegisterModel() async {
    final url = Uri.parse("https://api.mec-ci.org/api/v1/auth/register");

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': 'jean@gmail.com',
        'password': 'Password01@',
        'fullname': 'Jean Dupont',
        'phone': '+33123456789',
      }),
    );


    if (response.statusCode == 200) {
      print("Utilisateur créé avec succès");
    } else {
      print("❌ FAILED");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Créer un compte",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => userRegisterModel(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Créer un compte",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
