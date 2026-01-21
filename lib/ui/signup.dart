// ignore: unused_element
// ignore: unused_element
import 'package:flutter/material.dart';

import 'login.dart';

import 'package:citoyen_plus/services/auth_service.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController fullnameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  bool isLoading = false;
  bool hidePassword = true;

  Future<void> handleCreateAccountView() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final result = await AuthService.signup(
      name: fullnameCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      password: passwordCtrl.text.trim(),
    );

    setState(() => isLoading = false);

    if (result["success"]) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Compte créé avec succès"),
          backgroundColor: Colors.green,
        ),
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result["message"]),
          backgroundColor: Colors.red,
        ),
      );
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
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25),

              TextFormField(
                controller: fullnameCtrl,
                decoration: const InputDecoration(
                  labelText: "Nom complet",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? "Nom et prénoms requis" : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.contains("@") ? null : "Email invalide",
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: phoneCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Téléphone",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.length < 10 ? "Numéro invalide" : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: passwordCtrl,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => hidePassword = !hidePassword),
                  ),
                ),
                validator: (v) =>
                    v!.length < 6 ? "Min. 6 caractères" : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: confirmPasswordCtrl,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  labelText: "Confirmer mot de passe",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => hidePassword = !hidePassword),
                  ),
                ),
                validator: (v) {
                  if (v!.length < 6) {
                    return "Min. 6 caractères";
                  }
                  if (v != passwordCtrl.text) {
                    return "Les mots de passe ne correspondent pas";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleCreateAccountView,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Créer mon compte",
                          style: TextStyle(fontSize: 16),
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
