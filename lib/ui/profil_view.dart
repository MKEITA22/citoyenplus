import 'package:flutter/material.dart';
import 'login.dart';

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Gradient gradient;

  const GradientIcon({
    required this.icon,
    required this.size,
    required this.gradient,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Icon(icon, size: size, color: Colors.white),
    );
  }
}

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  String name = '';
  String email = '';
  String phone = '';
  String avatar = 'assets/default_avatar.png';

  final LinearGradient mecGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF7F00), Color(0xFF1556B5)],
  );

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mon Profil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF1556B5),
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(radius: 60, backgroundImage: AssetImage(avatar)),

            const SizedBox(height: 20),

            inputField(
              label: "Nom complet",
              value: name,
              onChanged: (v) => setState(() => name = v),
            ),
            inputField(
              label: "E-mail",
              value: email,
              onChanged: (v) => setState(() => email = v),
            ),
            inputField(
              label: "Téléphone",
              value: phone,
              onChanged: (v) => setState(() => phone = v),
            ),
           

            const SizedBox(height: 25),

            // Bouton enregistrer
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: mecGradient,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Profil mis à jour")));
                },
                child: const Text(
                  "Enregistrer",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Bouton Déconnexion
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.red.shade300),
              ),
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => LoginView()),
                    (route) => false,
                  );
                },
                icon: Icon(Icons.logout, color: Colors.red.shade400),
                label: Text(
                  "Déconnexion",
                  style: TextStyle(color: Colors.red.shade400, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  /// Champ personnalisé
  Widget inputField({
    required String label,
    required String value,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            maxLines: maxLines,
            controller: TextEditingController(text: value),
            onChanged: onChanged,
            decoration: InputDecoration(border: InputBorder.none),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
