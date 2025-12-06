import 'package:flutter/material.dart';
import 'detail_page.dart';
import 'regions_page.dart';
import 'livre_pdf_view.dart';

class LibrairieView extends StatefulWidget {
  const LibrairieView({super.key});

  @override
  State<LibrairieView> createState() => _LibrairieViewState();
}

class _LibrairieViewState extends State<LibrairieView> {
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
          "Les droits catégoriels et leur mise en œuvre en Côte d’Ivoire",
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
  final TextEditingController searchCtrl = TextEditingController();

  bool showBibliotheque = true; // Toggle Bibliothèque / Informations

  @override
  void initState() {
    super.initState();
    filteredDocuments = List<Map<String, String>>.from(documents);
    searchCtrl.addListener(() => filterDocuments(searchCtrl.text));
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  void filterDocuments(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        filteredDocuments = List<Map<String, String>>.from(documents);
      } else {
        filteredDocuments = documents.where((doc) {
          final title = (doc['titre'] ?? '').toLowerCase();
          final desc = (doc['description'] ?? '').toLowerCase();
          return title.contains(q) || desc.contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Barre de recherche
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(45),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 30, color: Colors.grey),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: searchCtrl,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Rechercher un document...",
                      ),
                    ),
                  ),
                  if (searchCtrl.text.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchCtrl.clear();
                        filterDocuments('');
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Toggle Bibliothèque
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  // Bibliothèque
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => showBibliotheque = true),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: showBibliotheque
                              ? const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFF7F00),
                                    Color(0xFF1556B5),
                                  ],
                                )
                              : null,
                          color: showBibliotheque ? null : Colors.transparent,
                          boxShadow: showBibliotheque
                              ? [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 3),
                                  ),
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Bibliothèque",
                          style: TextStyle(
                            color: showBibliotheque
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Informations
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => showBibliotheque = false),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: !showBibliotheque
                              ? const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFF7F00),
                                    Color(0xFF1556B5),
                                  ],
                                )
                              : null,
                          color: !showBibliotheque ? null : Colors.transparent,
                          boxShadow: !showBibliotheque
                              ? [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 3),
                                  ),
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 3),
                                  ),
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Informations",
                          style: TextStyle(
                            color: !showBibliotheque
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            //Contenu principal
            Expanded(
              child: showBibliotheque
                  ? buildBibliotheque()
                  : buildInformations(),
            ),
          ],
        ),
      ),
    );
  }

  // Bibliothèque
  Widget buildBibliotheque() {
    if (filteredDocuments.isEmpty) {
      return const Center(child: Text("Aucun document trouvé "));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisExtent: 300,
      ),
      itemCount: filteredDocuments.length,
      itemBuilder: (context, i) {
        final doc = filteredDocuments[i];
        return GestureDetector(
          onTap: () {
            final pdfPath = doc['pdf'] ?? '';
            if (pdfPath.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => LivrePdfView(pdf: pdfPath)),
              );
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('PDF introuvable')));
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  doc['couverture'] ?? '',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                doc['titre'] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                doc['description'] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ],
          ),
        );
      },
    );
  }

  // Informations Côte d'Ivoire
  Widget buildInformations() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        infoCard(
          title: "Présentation du pays",
          subtitle:
              "La Côte d’Ivoire est située en Afrique de l’Ouest, avec Abidjan comme capitale économique et Yamoussoukro comme capitale politique.",
          gradientColors: [Color(0xFFFF7F00), Color(0xFF1556B5)],
          icon: Icons.public,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailPage(
                  title: "Présentation du pays",
                  details:
                      "La Côte d’Ivoire est située en Afrique de l’Ouest. \n\nCapitale économique : Abidjan \nCapitale politique : Yamoussoukro \nLangue officielle : français \nPopulation : environ 26 millions \nMonnaie : Franc CFA",
                ),
              ),
            );
          },
        ),
        infoCard(
          title: "Régions",
          subtitle:
              "Le pays est divisé en 31 régions, chacune avec ses caractéristiques et sa culture locale.",
          gradientColors: [Color(0xFF1556B5), Color(0xFFFF7F00)],
          icon: Icons.map,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RegionsPage(
                  title: "Régions de la Côte d'Ivoire",
                  regions: ["Abidjan", "Bouaké", "San Pedro", "Korhogo"],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Card stylisée réutilisable
  Widget infoCard({
    required String title,
    required String subtitle,
    required List<Color> gradientColors,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: gradientColors.last.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(color: Colors.white70),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
        ),
      ),
    );
  }
}
