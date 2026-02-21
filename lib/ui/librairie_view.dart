import 'package:flutter/material.dart';
import 'detail_page.dart';
import 'regions_page.dart';
import 'livre_pdf_view.dart';

class LibrairieView extends StatefulWidget {
  const LibrairieView({super.key});

  @override
  State<LibrairieView> createState() => _LibrairieViewState();
}

class _LibrairieViewState extends State<LibrairieView>
    with SingleTickerProviderStateMixin {
  static const _orange = Color(0xFFFF7F00);
  static const _blue = Color(0xFF1556B5);

  final List<Map<String, String>> documents = [
    {"titre": "BUDGET CITOYEN", "couverture": "assets/budget2021.png", "description": "", "pdf": "assets/BUDGET-CITOYEN.pdf"},
    {"titre": "BUDGET CITOYEN 2024", "couverture": "assets/budget2024.png", "description": "", "pdf": "assets/BUDGET-CITOYEN_2024.pdf"},
    {"titre": "BUDGET CITOYEN 2025", "couverture": "assets/budget2025.png", "description": "", "pdf": "assets/BUDGET-CITOYEN_2025.pdf"},
    {"titre": "CNDH", "couverture": "assets/cndh.png", "description": "Les droits catégoriels et leur mise en œuvre en Côte d'Ivoire", "pdf": "assets/CNDH.pdf"},
    {"titre": "CODE D'ETHIQUE ET DE DEONTOLOGIE DGBF", "couverture": "assets/code_ethique.png", "description": "", "pdf": "assets/dgbf.pdf"},
  ];

  late List<Map<String, String>> filteredDocuments;
  final TextEditingController searchCtrl = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    filteredDocuments = List<Map<String, String>>.from(documents);
    searchCtrl.addListener(() => filterDocuments(searchCtrl.text));
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void filterDocuments(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      filteredDocuments = q.isEmpty
          ? List<Map<String, String>>.from(documents)
          : documents.where((doc) {
              return (doc['titre'] ?? '').toLowerCase().contains(q) ||
                  (doc['description'] ?? '').toLowerCase().contains(q);
            }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Librairie',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.black87, letterSpacing: -0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  'Découvrez les ressources citoyennes',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
                const SizedBox(height: 16),

                // ── Barre de recherche ─────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, size: 20, color: Colors.grey[400]),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: searchCtrl,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Rechercher un document...",
                            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                          ),
                        ),
                      ),
                      if (searchCtrl.text.isNotEmpty)
                        GestureDetector(
                          onTap: () { searchCtrl.clear(); filterDocuments(''); },
                          child: Icon(Icons.close, size: 18, color: Colors.grey[400]),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Tabs ───────────────────────────────────────────────
                Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: _orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black54,
                    labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                    tabs: const [
                      Tab(text: 'Bibliothèque'),
                      Tab(text: 'Informations'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Contenu ────────────────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBibliotheque(),
                _buildInformations(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Bibliothèque ──────────────────────────────────────────────────────────
  Widget _buildBibliotheque() {
    if (filteredDocuments.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text("Aucun document trouvé", style: TextStyle(color: Colors.grey[400], fontSize: 15)),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        mainAxisExtent: 260, // ✅ hauteur fixe par cellule — pas d'overflow
      ),
      itemCount: filteredDocuments.length,
      itemBuilder: (context, i) {
        final doc = filteredDocuments[i];
        return GestureDetector(
          onTap: () {
            final pdfPath = doc['pdf'] ?? '';
            if (pdfPath.isNotEmpty) {
              Navigator.push(context, MaterialPageRoute(builder: (_) => LivrePdfView(pdf: pdfPath)));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PDF introuvable')));
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      doc['couverture'] ?? '',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[100],
                        child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                      ),
                    ),
                  ),
                ),
                // Texte
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc['titre'] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: Colors.black87),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if ((doc['description'] ?? '').isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Text(
                          doc['description'] ?? '',
                          style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Informations ──────────────────────────────────────────────────────────
  Widget _buildInformations() {
    final cards = [
      {
        "title": "Présentation du pays",
        "subtitle": "Capitale, langue, population, monnaie et géographie.",
        "icon": Icons.public,
        "color": _orange,
        "emoji": "🌍",
        "onTap": () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailPage(
          title: "Présentation du pays",
          details: "La Côte d'Ivoire est située en Afrique de l'Ouest.\n\nCapitale économique : Abidjan\nCapitale politique : Yamoussoukro\nLangue officielle : français\nPopulation : environ 26 millions\nMonnaie : Franc CFA",
        ))),
      },
      {
        "title": "Régions",
        "subtitle": "Le pays est divisé en 31 régions aux cultures variées.",
        "icon": Icons.map_outlined,
        "color": _blue,
        "emoji": "🗺️",
        "onTap": () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegionsPage(
          title: "Régions de la Côte d'Ivoire",
          regions: ["Abidjan", "Bouaké", "San Pedro", "Korhogo"],
        ))),
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        final Color color = card["color"] as Color;
        return GestureDetector(
          onTap: card["onTap"] as VoidCallback?,
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withOpacity(0.15), width: 1.5),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Row(
              children: [
                // Icône
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(card["emoji"] as String, style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 16),
                // Texte
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card["title"] as String,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: color,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        card["subtitle"] as String,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500], height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Flèche
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_forward_ios, size: 12, color: color),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}