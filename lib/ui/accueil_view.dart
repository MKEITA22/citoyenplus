import 'package:flutter/material.dart';
import 'package:on_mec/ui/entete.dart';
import 'package:on_mec/ui/livre_pdf_view.dart';
import 'package:on_mec/ui/post_card.dart';

class AccueilView extends StatefulWidget {
  const AccueilView({super.key});

  @override
  State<AccueilView> createState() => _AccueilViewState();
}

// Liste des tags PDF (inchangé)
List<String> tags = ["Environnement", "Incivisme", "Sécurité", "Signalement"];

// modèle de post

class PostModel {
  final String username;
  final String imagePath;
  int likes; // dynamique
  final int comments;
  final String type;
  final String tags;
  final String description;
  final DateTime createdAt; // DATE

  PostModel({
    required this.username,
    required this.imagePath,
    required this.likes,
    required this.comments,
    required this.type,
    this.tags = "",
    this.description = "",
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

//  Liste des posts

final List<PostModel> posts = [
  PostModel(
    username: "Utilisateur 1",
    imagePath: "assets/cndh.png",
    likes: 120,
    comments: 15,
    type: "signalement",
    tags: "Signalement, Incivisme",
    description: "",
  ),
  PostModel(
    username: "Mireille Kouassi",
    imagePath: "assets/cndh.png",
    likes: 80,
    comments: 9,
    type: "action",
    description: "Belle action citoyenne !",
  ),
  PostModel(
    username: "Omar Diallo",
    imagePath: "assets/cndh.png",
    likes: 233,
    comments: 40,
    type: "signalement",
    tags: "Sécurité",
    description: "",
  ),
];

class _AccueilViewState extends State<AccueilView> {
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

  late List<Map<String, String>> filteredDocuments;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredDocuments = List<Map<String, String>>.from(documents);
    _searchCtrl.addListener(() => filterDocuments(_searchCtrl.text));
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    // Tri du plus récent au plus ancien
    final orderedPosts = List<PostModel>.from(posts)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Scaffold(
      appBar: EntetePersonalise(),

      body: SingleChildScrollView(
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

              // BARRE DE RECHERCHE
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(45),
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

              // LISTE HORIZONTALE DES PDFS
              filteredDocuments.isEmpty
                  ? SizedBox(
                      height: 380,
                      child: Center(
                        child: Text(
                          "Aucun document trouvé ",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 380,
                      child: ListView.builder(
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

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 280,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),

                                      child: Image.asset(
                                        doc["couverture"] ?? '',
                                        fit: BoxFit.cover,
                                        width: double.infinity,

                                        errorBuilder: (c, e, s) => Container(
                                          height: 280,
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

              // CITATION
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Icon(
                        Icons.format_quote,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        "Le président de la République nomme le Premier ministre",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // LISTE DES POSTS TRIÉE
              ListView.builder(
                itemCount: orderedPosts.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                itemBuilder: (context, index) {
                  final p = orderedPosts[index];

                  return PostCard(
                    username: p.username,
                    imagePath: p.imagePath,
                    likes: p.likes,
                    comments: p.comments,
                    tag: p.type == "action" ? "Action Citoyenne" : p.tags,
                    description: p.description,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
