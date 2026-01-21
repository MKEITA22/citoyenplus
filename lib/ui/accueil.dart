import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'accueil_view.dart';
import 'ai_chat_view.dart';
import 'ajouter_view.dart';
import 'librairie_view.dart';
import 'quiz_view.dart';

// DÉGRADÉE ICON

import '../services/api_service.dart';


class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Gradient gradient;

  const GradientIcon({
    super.key,
    required this.icon,
    required this.size,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) =>
          gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Icon(icon, size: size, color: Colors.white),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  int selectedIndex = 0;
  final String userToken = "TOKEN_UTILISATEUR_ICI";

  final List<Widget> pages = const [
    AccueilView(),
    QuizView(),
    AjouterView(),
    LibrairieView(),
    AiChatView(),
  ];

  final Gradient mecGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF7F00), Color(0xFF1556B5)],
  );

  void onItemTapped(int index) {
    if (index == 2) {
      showAddOptions();
    } else {
      setState(() => selectedIndex = index);
    }
  }

  void showAddOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Que souhaites-tu faire ?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              leading:
                  const Icon(Icons.volunteer_activism, color: Colors.green),
              title: const Text("Ajouter une action citoyenne"),
              onTap: () {
                Navigator.pop(context);
                showAddPost();
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.emoji_events, color: Colors.orange),
              title: const Text("Signaler une action citoyenne"),
              onTap: () {
                Navigator.pop(context);
                showSignalementSheet();
              },
            ),
          ],
        ),
      ),
    );
  }

  void showAddPost() {
    final descCtrl = TextEditingController();
    String? imagePath;
    bool isPicking = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (_, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text("Créer une action citoyenne",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  if (isPicking) return;
                  isPicking = true;
                  final img =
                      await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (img != null) {
                    setModalState(() => imagePath = img.path);
                  }
                  isPicking = false;
                },
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: imagePath == null
                      ? const Icon(Icons.add_a_photo,
                          size: 50, color: Colors.grey)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(File(imagePath!), fit: BoxFit.cover),
                        ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: descCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Décris ton action citoyenne...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15)),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: () async {
                  if (descCtrl.text.trim().isEmpty || imagePath == null) return;

                  try {
                    await ApiService.createPost(
                      token: userToken,
                      description: descCtrl.text.trim(),
                      imagePath: imagePath!, title: '',
                    );
                    if (!mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Action publiée ✅")),
                    );
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Erreur 😓")),
                    );
                  }
                },
                icon: const Icon(Icons.send),
                label: const Text("Publier"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showSignalementSheet() {
    final themes = [
      "Pollution / Déchets",
      "Corruption / Détournement",
      "Violence / Insécurité",
      "Incivisme routier",
      "Atteinte aux biens publics",
      "Harcèlement / Discrimination",
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: themes.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(themes[i]),
          onTap: () {
            Navigator.pop(context);
            showSignalementDetails(themes[i]);
          },
        ),
      ),
    );
  }

  void showSignalementDetails(String theme) {
    final descCtrl = TextEditingController();
    String? imagePath;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (_, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Signaler : $theme",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  final img =
                      await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (img != null) {
                    setModalState(() => imagePath = img.path);
                  }
                },
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: imagePath == null
                      ? const Icon(Icons.add_a_photo,
                          size: 50, color: Colors.grey)
                      : Image.file(File(imagePath!), fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                    hintText: "Décris le signalement"),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  if (descCtrl.text.trim().isEmpty || imagePath == null) return;

                  try {
                    await ApiService.createSignalement(
                      token: userToken,
                      categorie: theme,
                      description: descCtrl.text.trim(),
                      imagePath: imagePath!,
                    );
                    if (!mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Signalement envoyé ✅")),
                    );
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Erreur 😓")),
                    );
                  }
                },
                icon: const Icon(Icons.send),
                label: const Text("Envoyer"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: GradientIcon(
                  icon: Icons.dashboard_rounded,
                  size: 26,
                  gradient: mecGradient),
              label: "Accueil"),
          BottomNavigationBarItem(
              icon: GradientIcon(
                  icon: Icons.psychology_alt_rounded,
                  size: 26,
                  gradient: mecGradient),
              label: "Quiz"),
          BottomNavigationBarItem(
              icon: GradientIcon(
                  icon: Icons.add_circle_rounded,
                  size: 30,
                  gradient: mecGradient),
              label: "Ajouter"),
          BottomNavigationBarItem(
              icon: GradientIcon(
                  icon: Icons.menu_book_rounded,
                  size: 26,
                  gradient: mecGradient),
              label: "Librairie"),
          BottomNavigationBarItem(
              icon: GradientIcon(
                  icon: Icons.smart_toy_rounded,
                  size: 26,
                  gradient: mecGradient),
              label: "IA"),
        ],
      ),
    );
  }
}
