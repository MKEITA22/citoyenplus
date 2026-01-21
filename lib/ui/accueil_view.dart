import 'dart:io';
import 'package:flutter/material.dart';
import 'package:citoyen_plus/ui/entete.dart';
import 'package:citoyen_plus/ui/livre_pdf_view.dart';
import '../models/post.dart';
import '../models/signalement.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

/// ---------------------------
/// POST CARD
/// ---------------------------
class PostCard extends StatefulWidget {
  final String username;
  final String imagePath;
  final int likes;
  final int comments;
  final String tag;
  final String description;

  const PostCard({
    super.key,
    required this.username,
    required this.imagePath,
    required this.likes,
    required this.comments,
    required this.tag,
    this.description = "",
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int likeCount;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    likeCount = widget.likes;
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
      if (likeCount < 0) likeCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> displayTags = widget.tag
        .split(',')
        .map((e) => e.trim())
        .toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tags
          if (displayTags.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 6,
                children: displayTags.map((t) {
                  List<Color> colors;
                  switch (t) {
                    case "Action Citoyenne":
                      colors = [Color(0xFFFF7F00), Color(0xFF1556B5)];
                      break;
                    default:
                      colors = [Colors.blue, Colors.purple];
                  }
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      t,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/user.jpg'),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                const Icon(Icons.more_vert),
              ],
            ),
          ),

          // Image
          SizedBox(
            height: 220,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              child: _buildImage(widget.imagePath),
            ),
          ),

          // Description
          if (widget.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Text(widget.description),
            ),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.black,
                    size: 28,
                  ),
                  onPressed: toggleLike,
                ),
                IconButton(
                  icon: const Icon(Icons.mode_comment_outlined, size: 26),
                  onPressed: () {},
                ),
                const Spacer(),
              ],
            ),
          ),

          // Likes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              "Aimé par $likeCount personnes",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // Commentaires
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Text(
              "Voir les ${widget.comments} commentaires",
              style: const TextStyle(color: Colors.grey),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildImage(String path) {
    if (path.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Center(child: Icon(Icons.broken_image)),
      );
    }

    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[200],
          child: const Center(child: Icon(Icons.broken_image)),
        ),
      );
    } else {
      final file = File(path);
      if (!file.existsSync()) {
        return Container(
          color: Colors.grey[200],
          child: const Center(child: Icon(Icons.broken_image)),
        );
      }
      return Image.file(
        file,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[200],
          child: const Center(child: Icon(Icons.broken_image)),
        ),
      );
    }
  }
}

/// ---------------------------
/// ACCUEIL VIEW
/// ---------------------------
class AccueilView extends StatefulWidget {
  const AccueilView({super.key});

  @override
  State<AccueilView> createState() => _AccueilViewState();
}

class _AccueilViewState extends State<AccueilView> {
  List<PostModel> posts = [];
  List<SignalementModel> signalements = [];
  bool isLoadingPosts = true;
  bool isLoadingSignalements = true;

  final TextEditingController _searchCtrl = TextEditingController();
  late List<Map<String, String>> filteredDocuments;

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
    _loadPosts();
    _loadSignalements();
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

  Future<void> _loadPosts() async {
    try {
      final token = await AuthService.getToken();
      if (token == null || token.isEmpty) {
        setState(() => isLoadingPosts = false);
        return;
      }
      final result = await ApiService.fetchPosts(token);
      setState(() {
        posts = result;
        isLoadingPosts = false;
      });
    } catch (e) {
     
      setState(() => isLoadingPosts = false);
    }
  }

  Future<void> _loadSignalements() async {
    try {
      final token = await AuthService.getToken() ?? 'USER_TOKEN_ICI';
      final result = await ApiService.fetchSignalements(token);
      setState(() {
        signalements = result;
        isLoadingSignalements = false;
      });
    } catch (e) {
     
      setState(() => isLoadingSignalements = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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

              // Recherche
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

              // Liste des PDF
              filteredDocuments.isEmpty
                  ? SizedBox(
                      height: 380,
                      child: Center(
                        child: Text(
                          "Aucun document trouvé",
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
              const Text(
                "Derniers signalements",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              isLoadingSignalements
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: signalements.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final p = posts[index];
                        return PostCard(
                          username: p.username ?? "Citoyen",
                          imagePath: p.imageUrl ?? '',
                          likes: p.likes,
                          comments: p.comments,
                          tag: (p.tags), // assure un fallback
                          description: p.description,
                        );
                      },
                    ),

              const SizedBox(height: 20),
              const Text(
                "Derniers posts",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              isLoadingPosts
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: posts.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final p = posts[index];
                        return PostCard(
                          username: p.username ?? "Citoyen",
                          imagePath: p.imageUrl ?? '',
                          likes: p.likes,
                          comments: p.comments,
                          tag: p.tags,
                          description: p.description ,
                        );
                      },
                    ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
