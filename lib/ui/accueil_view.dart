import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/signalement.dart';
import '../services/recuperer_signalement_service.dart';
import '../widgets/post_card.dart';
import '../widgets/signalement_card.dart';
import '../ui/entete.dart';
import '../ui/livre_pdf_view.dart';
import '../models/post.dart';
import '../services/recuperer_actualite_service.dart';

class AccueilView extends StatefulWidget {
  final VoidCallback? onNotificationPressed;

  const AccueilView({super.key, this.onNotificationPressed});

  @override
  State<AccueilView> createState() => _AccueilViewState();
}

class _AccueilViewState extends State<AccueilView> {
  final TextEditingController _searchCtrl = TextEditingController();
  late List<Map<String, String>> filteredDocuments;

  Future<List<PostModel>> _futurePosts = Future.value([]);
  Future<List<SignalementModel>> _futureSignalements = Future.value([]);

  String userToken = "";

  final List<Map<String, String>> documents = [
    {
      "titre": "BUDGET CITOYEN",
      "couverture": "assets/budget2021.png",
      "description": "",
      "pdf": "assets/BUDGET-CITOYEN.pdf",
    },
    {
      "titre": "BUDGET CITOYEN 2024",
      "couverture": "assets/budget2024.png",
      "description": "",
      "pdf": "assets/BUDGET-CITOYEN_2024.pdf",
    },
    {
      "titre": "BUDGET CITOYEN 2025",
      "couverture": "assets/budget2025.png",
      "description": "",
      "pdf": "assets/BUDGET-CITOYEN_2025.pdf",
    },
    {
      "titre": "CNDH",
      "couverture": "assets/cndh.png",
      "description":
          "Les droits catégoriels et leur mise en œuvre en Côte d'Ivoire",
      "pdf": "assets/CNDH.pdf",
    },
    {
      "titre": "CODE D'ETHIQUE ET DE DEONTOLOGIE DGBF",
      "couverture": "assets/code_ethique.png",
      "description": "",
      "pdf": "assets/dgbf.pdf",
    },
  ];

  @override
  void initState() {
    super.initState();
    filteredDocuments = List<Map<String, String>>.from(documents);
    _searchCtrl.addListener(() => filterDocuments(_searchCtrl.text));
    _loadData();
  }

  // ✅ Un seul appel SharedPreferences pour tout charger
  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1)  return 'À l\'instant';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24)   return '${diff.inHours} h';
    if (diff.inDays < 7)     return '${diff.inDays} j';
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString("token") ?? "";
    if (!mounted) return;
    setState(() {
      _futurePosts = RecupererActualiteService.fetchAllPosts(userToken);
      _futureSignalements =
          RecupererSignalementService.fetchAllSignalement(userToken);
    });
  }

  void filterDocuments(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        filteredDocuments = List<Map<String, String>>.from(documents);
      } else {
        filteredDocuments = documents.where((doc) {
          final titre = (doc['titre'] ?? '').toLowerCase();
          final desc = (doc['description'] ?? '').toLowerCase();
          return titre.contains(q) || desc.contains(q);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EntetePersonalise(
        onNotificationPressed: widget.onNotificationPressed,
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: const Color(0xFFFF7F00),
        child: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Bienvenue sur Citoyen +",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Comprendre les institutions et connaître ses droits, c'est le premier pas vers une société plus juste.",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 20),

              // ── Recherche ──────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(45),
                  border: Border.all(
                    color: const Color(0xFFDDDDDD),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, size: 35),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Rechercher un document",
                        ),
                      ),
                    ),
                    if (_searchCtrl.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchCtrl.clear();
                          filterDocuments('');
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Explore les bases de la citoyenneté ivoirienne.",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // ── Liste des PDF (scroll horizontal) ─────────────────────
              SizedBox(
                height: 340,
                child: filteredDocuments.isEmpty
                    ? Center(
                        child: Text(
                          "Aucun document trouvé",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredDocuments.length,
                        itemBuilder: (context, i) {
                          final doc = filteredDocuments[i];
                          return GestureDetector(
                            onTap: () {
                              final pdfPath = doc['pdf'] ?? '';
                              if (pdfPath.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) =>
                                        LivrePdfView(pdf: pdfPath),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('PDF introuvable'),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: 190,
                              margin: const EdgeInsets.only(right: 20),
                              clipBehavior: Clip.hardEdge,
                              decoration: const BoxDecoration(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 235,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.asset(
                                        doc["couverture"] ?? '',
                                        fit: BoxFit.cover,
                                        errorBuilder: (c, e, s) => Container(
                                          height: 235,
                                          color: Colors.grey[200],
                                          child: const Center(
                                            child: Icon(Icons.broken_image),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    doc["titre"] ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    doc["description"] ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[700],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 20),

              // ── SIGNALEMENTS ──────────────────────────────────────────
              const Text(
                "Derniers signalements",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<SignalementModel>>(
                future: _futureSignalements,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  }
                  final signalements = snapshot.data ?? [];
                  if (signalements.isEmpty) {
                    return const Center(
                      child: Text('Aucun signalement disponible'),
                    );
                  }
                  // Hauteur généreuse pour absorber le "voir plus"
                  return SizedBox(
                    height: 380,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: signalements.length,
                      itemBuilder: (context, index) {
                        final s = signalements[index];
                        return SizedBox(
                          width: 260,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 14),
                            child: SignalementCard(
                              nom: s.titre,
                              description: s.description,
                              photoUrl: s.photo,
                              statut: s.statut,
                              categorie: s.categorieNom,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // ── POSTS ─────────────────────────────────────────────────
              const Text(
                "Derniers posts",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<PostModel>>(
                future: _futurePosts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  }
                  final posts = snapshot.data ?? [];
                  if (posts.isEmpty) {
                    return const Center(child: Text('Aucun post disponible'));
                  }
                  // ✅ Column à la place du ListView imbriqué
                  return Column(
                    children: posts.map((post) {
                      return PostCard(
                        title: post.title,
                        content: post.content,
                        timeAgo: _timeAgo(post.date),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
        ),
      ),
    );
  }
}