import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:on_mec/ui/accueil_view.dart';
import 'package:on_mec/ui/ai_chat_view.dart';
import 'package:on_mec/ui/ajouter_view.dart';
import 'package:on_mec/ui/librairie_view.dart';
import 'package:on_mec/ui/quiz_view.dart';

// GRADIENT ICON

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

// HOME ROOT

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

//  HOME STATE

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
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

  void _onItemTapped(int index) {
    if (index == 2) {
      _showAddOptions();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // BOTTOM SHEET DES CHOIX

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Que souhaites-tu faire ?",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(
                  Icons.volunteer_activism,
                  color: Colors.green,
                ),
                title: const Text("Ajouter une action citoyenne"),
                onTap: () {
                  Navigator.pop(context);
                  _showAddPost(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.emoji_events, color: Colors.orange),
                title: const Text("Signaler une action citoyenne"),
                onTap: () {
                  Navigator.pop(context);
                  _showSignalementSheet(context);
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  //  BOTTOM SHEET : AJOUT ACTION CITOYENNE

  bool isPicking = false;
  void _showAddPost(BuildContext context) {
    TextEditingController descriptionController = TextEditingController();
    String? pickedImagePath;

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20,
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // HEADER
                  Row(
                    children: [
                      const Text(
                        "Créer une action citoyenne",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // IMAGE
                  GestureDetector(
                    onTap: () async {
                      if (isPicking) return; // 🔥 empêche les double clics
                      isPicking = true;

                      try {
                        final ImagePicker picker = ImagePicker();
                        XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                        );

                        if (image != null) {
                          setModalState(() {
                            pickedImagePath = image.path;
                          });
                        }
                      } catch (e) {
                        debugPrint("Erreur picker: $e");
                      }

                      isPicking = false; // 🔥 on réactive le bouton
                    },

                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: pickedImagePath == null
                          ? const Center(
                              child: Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: Colors.grey,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                File(pickedImagePath!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // DESCRIPTION
                  TextField(
                    controller: descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Décris ton action citoyenne...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final desc = descriptionController.text.trim();

                        if (desc.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Ajoute une petite description de ton action 😉",
                              ),
                            ),
                          );
                          return;
                        }

                        if (pickedImagePath == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Ajoute une image pour ton action 📸",
                              ),
                            ),
                          );
                          return;
                        }

                        // AJOUT DU POST ACTION CITOYENNE
                        posts.insert(
                          0,
                          PostModel(
                            username: "Moi-même",
                            imagePath: pickedImagePath!,
                            likes: 0,
                            comments: 0,
                            type: "action",
                            description: desc,
                          ),
                        );

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Ton action citoyenne a été publiée"),
                          ),
                        );

                        setState(() {});
                      },

                      icon: const Icon(Icons.send),
                      label: const Text("Publier"),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // BOTTOM SHEET SIGNALEMENT

  void _showSignalementSheet(BuildContext context) {
    final List<Map<String, dynamic>> themes = [
      {
        "titre": "Pollution / Déchets",
        "icone": Icons.delete_forever,
        "couleur": Colors.green,
      },
      {
        "titre": "Corruption / Détournement",
        "icone": Icons.money_off,
        "couleur": Colors.redAccent,
      },
      {
        "titre": "Violence / Insécurité",
        "icone": Icons.security,
        "couleur": Colors.deepPurple,
      },
      {
        "titre": "Incivisme routier",
        "icone": Icons.directions_car,
        "couleur": Colors.orangeAccent,
      },
      {
        "titre": "Atteinte aux biens publics",
        "icone": Icons.account_balance,
        "couleur": Colors.blueAccent,
      },
      {
        "titre": "Harcèlement / Discrimination",
        "icone": Icons.warning_amber_rounded,
        "couleur": Colors.brown,
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Signaler une action d’incivisme",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              GridView.builder(
                shrinkWrap: true,
                itemCount: themes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.3,
                ),

                itemBuilder: (context, index) {
                  final theme = themes[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _showSignalementDetails(context, theme["titre"]);
                    },

                    child: Container(
                      decoration: BoxDecoration(
                        color: theme["couleur"].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: theme["couleur"], width: 1.5),
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            theme["icone"],
                            size: 40,
                            color: theme["couleur"],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            theme["titre"],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // DETAILS SIGNALEMENT

  void _showSignalementDetails(BuildContext context, String theme) {
    TextEditingController descCtrl = TextEditingController();
    String? pickedImagePath;
    bool isPicking = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),

      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20,
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    "Signaler : $theme",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 15),

                  GestureDetector(
                    onTap: () async {
                      if (isPicking) return;
                      isPicking = true;

                      final ImagePicker picker = ImagePicker();
                      XFile? img = await picker.pickImage(
                        source: ImageSource.gallery,
                      );

                      if (img != null) {
                        setModalState(() {
                          pickedImagePath = img.path;
                        });
                      }

                      isPicking = false;
                    },

                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: pickedImagePath == null
                          ? const Center(
                              child: Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: Colors.grey,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                File(pickedImagePath!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: descCtrl,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Décris brièvement l’action observée...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // BOUTON ENVOYER
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (pickedImagePath == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Ajoute une image pour le signalement",
                              ),
                            ),
                          );
                          return;
                        }

                        if (descCtrl.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Merci de décrire le signalement"),
                            ),
                          );
                          return;
                        }

                        //  AJOUT DU POST DANS LA LISTE
                        posts.insert(
                          0,
                          PostModel(
                            username: "Moi-même",
                            imagePath: pickedImagePath!,
                            likes: 0,
                            comments: 0,
                            type: "signalement",
                            tags: "Signalement, $theme",
                            description: descCtrl.text.trim(),
                          ),
                        );

                        Navigator.pop(context);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Signalement '$theme' publié"),
                          ),
                        );

                        setState(() {});
                      },

                      icon: const Icon(Icons.send),
                      label: const Text("Envoyer"),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  // BUILD HOME SCREEN
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        selectedFontSize: 12,
        unselectedFontSize: 12,

        items: [
          BottomNavigationBarItem(
            icon: GradientIcon(
              icon: Icons.dashboard_rounded,
              size: 26,
              gradient: mecGradient,
            ),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: GradientIcon(
              icon: Icons.psychology_alt_rounded,
              size: 26,
              gradient: mecGradient,
            ),
            label: "Quiz",
          ),
          BottomNavigationBarItem(
            icon: GradientIcon(
              icon: Icons.add_circle_rounded,
              size: 30,
              gradient: mecGradient,
            ),
            label: "Ajouter",
          ),
          BottomNavigationBarItem(
            icon: GradientIcon(
              icon: Icons.menu_book_rounded,
              size: 26,
              gradient: mecGradient,
            ),
            label: "Librairie",
          ),
          BottomNavigationBarItem(
            icon: GradientIcon(
              icon: Icons.smart_toy_rounded,
              size: 26,
              gradient: mecGradient,
            ),
            label: "IA",
          ),
        ],
      ),
    );
  }
}
