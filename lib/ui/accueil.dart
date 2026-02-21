import 'package:citoyen_plus/ui/accueil_view.dart';
import 'package:citoyen_plus/ui/mes_actions_view.dart';
import 'package:citoyen_plus/ui/notifications_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/categorie_signalement_model.dart';
import '../services/post_service.dart';
import '../widgets/signalement_sheet.dart';
import 'ai_chat_view.dart';
import 'ajouter_view.dart';
import 'librairie_view.dart';
import 'quiz_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  // ✅ Index étendu :
  // 0 = Accueil, 1 = Quiz, 2 = (bouton +), 3 = Librairie, 4 = IA
  // 5 = Notifications, 6 = MesActions (cachés de la navbar)
  int selectedIndex = 0;

  List<CategorieSignalementModel> categories = [];

  late final List<Widget> pages = [
    AccueilView(onNotificationPressed: () => goTo(5)),
    QuizView(),
    AjouterView(),
    LibrairieView(),
    AiChatView(),
    NotificationView(
      onMesActionsPressed: () => goTo(6),
    ),
    MesActionsView(posts: const [], onBackPressed: () => goTo(5)),
  ];

  void goTo(int index) {
    setState(() => selectedIndex = index);
  }

  void onItemTapped(int index) {
    if (index == 2) {
      showAddOptions();
    } else {
      setState(() => selectedIndex = index);
    }
  }

  // Retourne l'index navbar correspondant (5 et 6 → pas d'onglet sélectionné)
  int get _navIndex {
    if (selectedIndex <= 4) return selectedIndex;
    return 0; // accueil sélectionné par défaut quand on est sur notif/actions
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
            const Text(
              "Que souhaites-tu faire ?",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.volunteer_activism, color: Colors.green),
              title: const Text("Poster une action citoyenne"),
              onTap: () {
                Navigator.pop(context);
                showAddPost();
              },
            ),
            ListTile(
              leading: const Icon(Icons.emoji_events, color: Colors.orange),
              title: const Text("Signaler une action citoyenne"),
              onTap: () {
                Navigator.pop(context);
                showSignalementSheet(context, (newSignalement) {
                  setState(() {});
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void showAddPost() {
    final TextEditingController titreController = TextEditingController();
    final TextEditingController excerptController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    bool _isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (_, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(
            24, 24, 24,
            MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // ── Barre de drag ─────────────────────────────────────
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              // ── Titre ─────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF7F00), Color(0xFF1556B5)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Poster une actualité',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Champ Titre ───────────────────────────────────────
              _buildField(titreController, 'Titre', Icons.title_rounded),
              const SizedBox(height: 14),

              // ── Champ Extrait ─────────────────────────────────────
              _buildField(excerptController, 'Extrait / Résumé', Icons.short_text_rounded),
              const SizedBox(height: 14),

              // ── Champ Contenu ─────────────────────────────────────
              TextField(
                controller: contentController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Contenu de l'actualité...",
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 60),
                    child: Icon(Icons.article_outlined, color: Color(0xFF1556B5), size: 20),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Color(0xFF1556B5), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 24),

              // ── Bouton publier ────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF7F00), Color(0xFF1556B5)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: _isLoading ? null : () async {
                      if (titreController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Le titre est obligatoire")),
                        );
                        return;
                      }
                      setModalState(() => _isLoading = true);
                      final prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString("token") ?? "";
                      if (token.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Token manquant. Connecte-toi d'abord.")),
                        );
                        setModalState(() => _isLoading = false);
                        return;
                      }
                      try {
                        final newPost = await createArticle(
                          titreController.text,
                          excerptController.text,
                          contentController.text,
                          token,
                          date: DateTime.now(),
                        );
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("✅ '${newPost.title}' publié avec succès !"),
                            backgroundColor: const Color(0xFF34C759),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                        setState(() {});
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Erreur: \$e"),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        setModalState(() => _isLoading = false);
                      }
                    },
                    child: _isLoading
                        ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send_rounded, color: Colors.white, size: 18),
                              SizedBox(width: 8),
                              Text('Publier', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                            ],
                          ),
                  ),
                ),
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
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded, size: 26, color: Colors.orange),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology_alt_rounded, size: 26, color: Colors.orange),
            label: "Quiz",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_rounded, size: 30, color: Colors.orange),
            label: "Ajouter",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded, size: 26, color: Colors.orange),
            label: "Librairie",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_rounded, size: 26, color: Colors.orange),
            label: "IA",
          ),
        ],
      ),
    );
  }
  // ── Helper champ de saisie ───────────────────────────────────────────────
  Widget _buildField(TextEditingController ctrl, String hint, IconData icon) {
    return TextField(
      controller: ctrl,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF1556B5), size: 20),
        filled: true,
        fillColor: const Color(0xFFF8F9FF),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF1556B5), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

}