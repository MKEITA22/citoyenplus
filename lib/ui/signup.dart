import 'package:flutter/material.dart';
import 'package:on_mec/ui/login.dart';
import 'package:on_mec/widgets/inputfield.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  State<CreateAccountView> createState() => CreateAccountViewState();
}

class CreateAccountViewState extends State<CreateAccountView> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController fullnameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController confirmPasswordCtrl = TextEditingController();

  bool isLoading = false;

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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginView()),
                    );
                  },
                  child: Text("Créer un compte"),
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
                        MaterialPageRoute(builder: (_) => LoginView()),
                      );
                    },
                    child: Text(
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
