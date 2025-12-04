import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:on_mec/ui/login.dart';
import 'package:on_mec/widgets/inputfield.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullnameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  bool isLoading = false;


  //   APPEL API — INSCRIPTION
  Future<void> registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    if (passwordCtrl.text.trim() != confirmPasswordCtrl.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Les mots de passe ne correspondent pas ❗")),
      );
      return;
    }

    setState(() => isLoading = true);

    final url = Uri.parse("https://api.mec-ci.org/api/v1/auth/register");

    final Map<String, dynamic> data = {
      "fullname": fullnameCtrl.text.trim(),
      "email": emailCtrl.text.trim(),
      "phone": phoneCtrl.text.trim(),
      "password": passwordCtrl.text.trim(),
    };

    try {
      final response = await http.post(
        url,
        headers: {
          "accept": "application/json",
          "Content-Type": "application/json",
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Compte créé avec succès")),
        );

        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (_) => const LoginView()),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Échec de l'inscription. Vérifiez vos informations.",
            ),
          ),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erreur de connexion. Vérifiez votre réseau ❗"),
        ),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Créer un compte",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),

              inputField(
                controller: fullnameCtrl,
                label: "Nom complet",
                icon: Icons.person,
                validator: (v) => v!.isEmpty ? "Nom requis" : null,
              ),

              const SizedBox(height: 20),

              inputField(
                controller: emailCtrl,
                label: "Email",
                icon: Icons.email_outlined,
                keyboard: TextInputType.emailAddress,
                validator: (v) => v!.contains("@") ? null : "Email invalide",
              ),

              const SizedBox(height: 20),

              inputField(
                controller: phoneCtrl,
                label: "Téléphone",
                icon: Icons.phone,
                keyboard: TextInputType.phone,
                validator: (v) => v!.length < 8 ? "Numéro invalide" : null,
              ),

              const SizedBox(height: 20),

              inputField(
                controller: passwordCtrl,
                label: "Mot de passe",
                icon: Icons.lock_outline,
                keyboard: TextInputType.visiblePassword,
                validator: (v) => v!.length < 6 ? "Min. 6 caractères" : null,
              ),

              const SizedBox(height: 20),

              inputField(
                controller: confirmPasswordCtrl,
                label: "Confirmer le mot de passe",
                icon: Icons.lock_person_outlined,
                keyboard: TextInputType.visiblePassword,
                validator: (v) => v!.isEmpty ? "Répète le mot de passe" : null,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Créer le compte",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Déjà un compte ? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginView()),
                      );
                    },
                    child: const Text(
                      "Se connecter",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
