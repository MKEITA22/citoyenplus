import 'package:flutter/material.dart';
import 'entete.dart';
import 'quizquestions.dart';

const _orange = Color(0xFFFF7F00);
const _blue = Color(0xFF1556B5);

class QuizView extends StatelessWidget {
  const QuizView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        "icon": Icons.flag_circle_outlined,
        "title": "Citoyenneté",
        "desc": "Droits et devoirs du citoyen.",
        "color": _orange,
      },
      {
        "icon": Icons.directions_car_outlined,
        "title": "Code de la route",
        "desc": "Règles de conduite et sécurité.",
        "color": _blue,
      },
      {
        "icon": Icons.public_outlined,
        "title": "Côte d'Ivoire",
        "desc": "Histoire, culture et symboles 🇨🇮.",
        "color": _orange,
      },
      {
        "icon": Icons.gavel_outlined,
        "title": "Institutions",
        "desc": "Fonctionnement de l'État.",
        "color": _blue,
      },
      {
        "icon": Icons.scale_outlined,
        "title": "Droits humains",
        "desc": "Libertés et droits fondamentaux.",
        "color": _orange,
      },
      {
        "icon": Icons.handshake_outlined,
        "title": "Civisme et valeurs",
        "desc": "Vivre-ensemble et paix sociale.",
        "color": _blue,
      },
    ];

    return Scaffold(
      appBar: EntetePersonalise(),
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Titre ────────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.psychology_alt_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Choisis ton quiz",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text("🧠", style: TextStyle(fontSize: 22)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                "6 thèmes disponibles · 10 questions chacun",
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
              const SizedBox(height: 20),

              // ── Grille ───────────────────────────────────────────────
              Expanded(
                child: GridView.builder(
                  itemCount: categories.length,
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 3 / 3.6,
                  ),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final Color color = cat["color"];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Quizquestions(
                              categorie: cat["title"],
                              questions: getQuestionsPourCategorie(cat["title"]),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: color.withOpacity(0.15), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icône dans un cercle coloré
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(cat["icon"], size: 30, color: color),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              cat["title"],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: color,
                                letterSpacing: -0.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 6),
                            Expanded(
                              child: Text(
                                cat["desc"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: Colors.grey[500],
                                  height: 1.4,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Indicateur "10 questions"
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "10 questions",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> getQuestionsPourCategorie(String categorie) {
  switch (categorie) {
    case "Citoyenneté":
      return [
        {"question": "Quel est le symbole de la République de Côte d'Ivoire ?", "options": ["L'aigle", "L'éléphant", "Le lion", "La gazelle"], "correct": 1},
        {"question": "Quel est le rôle principal d'un citoyen dans son pays ?", "options": ["Observer", "Participer à la vie publique", "Critiquer", "Ignorer les lois"], "correct": 1},
        {"question": "Quel document prouve la nationalité ivoirienne ?", "options": ["Le passeport", "La carte nationale d'identité", "Le permis de conduire", "L'acte de naissance"], "correct": 1},
        {"question": "Que signifie le mot civisme ?", "options": ["Le respect des lois et des règles", "L'amour du football", "La défense de sa tribu", "La liberté totale"], "correct": 0},
        {"question": "Quel est le devoir d'un citoyen lors des élections ?", "options": ["Voter", "Voyager", "Dormir", "Protester"], "correct": 0},
        {"question": "Quel est le régime politique de la Côte d'Ivoire ?", "options": ["Monarchie", "République", "Dictature", "Fédération"], "correct": 1},
        {"question": "Que représente le drapeau ivoirien ?", "options": ["L'unité", "Les richesses du pays", "Les régions", "Les partis politiques"], "correct": 1},
        {"question": "Que signifie être responsable ?", "options": ["Assumer ses actes", "Faire ce qu'on veut", "Suivre les autres", "Refuser les règles"], "correct": 0},
        {"question": "Quel est le rôle de la Constitution ?", "options": ["Régler les matchs", "Fixer les lois fondamentales", "Organiser les fêtes", "Choisir le président"], "correct": 1},
        {"question": "Que favorise le respect des lois ?", "options": ["Le désordre", "La paix sociale", "La division", "Le chaos"], "correct": 1},
      ];
    case "Code de la route":
      return [
        {"question": "Que signifie un feu rouge ?", "options": ["Avancer", "Ralentir", "S'arrêter", "Klaxonner"], "correct": 2},
        {"question": "Que fait-on avant de dépasser un véhicule ?", "options": ["On accélère fort", "On vérifie les rétroviseurs", "On klaxonne seulement", "On ferme les yeux"], "correct": 1},
        {"question": "Quel est le côté de circulation en Côte d'Ivoire ?", "options": ["Gauche", "Droite", "Milieu", "Aucun"], "correct": 1},
        {"question": "Que signifie un panneau triangulaire rouge ?", "options": ["Danger", "Stationnement", "Interdiction", "Fin de route"], "correct": 0},
        {"question": "Quelle est la vitesse maximale en agglomération ?", "options": ["30 km/h", "50 km/h", "80 km/h", "100 km/h"], "correct": 1},
        {"question": "Que faut-il porter à moto ?", "options": ["Une casquette", "Un casque", "Une chemise", "Une écharpe"], "correct": 1},
        {"question": "Que signifie un panneau bleu rond ?", "options": ["Obligation", "Danger", "Interdiction", "Signal d'arrêt"], "correct": 0},
        {"question": "Que faire si un piéton traverse ?", "options": ["Accélérer", "S'arrêter", "Klaxonner", "Ignorer"], "correct": 1},
        {"question": "Quelle est la priorité sur une route sans panneau ?", "options": ["Celui de droite", "Celui de gauche", "Celui qui klaxonne", "Celui qui roule vite"], "correct": 0},
        {"question": "Quel document doit-on toujours avoir en voiture ?", "options": ["Carte grise", "Facture d'achat", "Passeport", "Bulletin de notes"], "correct": 0},
      ];
    case "Côte d'Ivoire":
      return [
        {"question": "Quelle est la capitale politique de la Côte d'Ivoire ?", "options": ["Abidjan", "Bouaké", "Yamoussoukro", "Korhogo"], "correct": 2},
        {"question": "En quelle année la Côte d'Ivoire a-t-elle obtenu son indépendance ?", "options": ["1958", "1960", "1962", "1970"], "correct": 1},
        {"question": "Qui fut le premier président de la Côte d'Ivoire ?", "options": ["Laurent Gbagbo", "Henri Konan Bédié", "Félix Houphouët-Boigny", "Alassane Ouattara"], "correct": 2},
        {"question": "Quel est le plat national ivoirien ?", "options": ["Le foutou", "Le garba", "Le kédjénou", "L'attiéké-poisson"], "correct": 3},
        {"question": "Quelle est la devise nationale ?", "options": ["Travail – Famille – Patrie", "Union – Discipline – Travail", "Paix – Unité – Progrès", "Force – Courage – Foi"], "correct": 2},
        {"question": "Quel est le plus grand stade du pays ?", "options": ["Stade Houphouët-Boigny", "Stade de la Paix", "Stade Alassane Ouattara d'Ebimpé", "Stade Gagnoa"], "correct": 2},
        {"question": "Quel est le fleuve le plus long du pays ?", "options": ["Bandama", "Comoé", "Sassandra", "Cavally"], "correct": 0},
        {"question": "Combien de districts compte la Côte d'Ivoire ?", "options": ["12", "14", "31", "19"], "correct": 2},
        {"question": "Quel est le surnom d'Abidjan ?", "options": ["La belle des lagunes", "La ville lumière", "La cité du cacao", "La capitale de l'Afrique de l'Ouest"], "correct": 0},
        {"question": "Quel est l'hymne national de la Côte d'Ivoire ?", "options": ["L'Abidjanaise", "Paix et Unité", "L'Ivoirienne", "Notre Patrie"], "correct": 0},
      ];
    case "Institutions":
      return [
        {"question": "Quelle institution veille au respect de la Constitution ?", "options": ["La CEI", "Le Conseil Constitutionnel", "Le Sénat", "Le Gouvernement"], "correct": 1},
        {"question": "Quel est le rôle principal de l'Assemblée Nationale ?", "options": ["Faire les lois", "Contrôler les frontières", "Nommer le président", "Organiser les élections"], "correct": 0},
        {"question": "Combien de pouvoirs composent l'État ivoirien ?", "options": ["2", "3", "4", "5"], "correct": 1},
        {"question": "Qui nomme le Premier ministre en Côte d'Ivoire ?", "options": ["Le peuple", "Le Président de la République", "Le Sénat", "La CEI"], "correct": 1},
        {"question": "Quelle institution organise les élections ?", "options": ["CPI", "ONU", "CEI", "Conseil Constitutionnel"], "correct": 2},
        {"question": "Quelle est la plus haute juridiction du pays ?", "options": ["Cour d'appel", "Cour suprême", "Tribunal de première instance", "Conseil d'État"], "correct": 1},
        {"question": "Quel est le rôle de la Cour des comptes ?", "options": ["Contrôler les finances publiques", "Juger les citoyens", "Créer les lois", "Organiser les élections"], "correct": 0},
        {"question": "Quel est le mandat du Président ivoirien ?", "options": ["3 ans", "4 ans", "5 ans", "6 ans"], "correct": 2},
        {"question": "Où siège le Sénat ivoirien ?", "options": ["Abidjan", "Bouaké", "Yamoussoukro", "Korhogo"], "correct": 2},
        {"question": "Qui représente l'État dans les régions ?", "options": ["Le Maire", "Le Gouverneur", "Le Préfet de région", "Le Député"], "correct": 2},
      ];
    case "Droits humains":
      return [
        {"question": "Quel est le premier droit de tout être humain ?", "options": ["Le droit à la santé", "Le droit à la vie", "Le droit au travail", "Le droit à l'éducation"], "correct": 1},
        {"question": "Quel texte protège les droits humains en Côte d'Ivoire ?", "options": ["Le Code civil", "La Constitution", "Le Code du travail", "Le Code pénal"], "correct": 1},
        {"question": "Qui veille à la protection des droits de l'Homme ?", "options": ["ONU", "CNDH", "CEI", "Assemblée Nationale"], "correct": 1},
        {"question": "Quel est le rôle du CNDH ?", "options": ["Promouvoir et protéger les droits de l'Homme", "Organiser les élections", "Rédiger les lois", "Gérer les finances"], "correct": 0},
        {"question": "Quel document international protège les droits humains ?", "options": ["La Déclaration universelle des droits de l'Homme", "La Charte africaine du sport", "Le traité de Versailles", "Le Code électoral"], "correct": 0},
        {"question": "Le droit à l'éducation s'applique à :", "options": ["Seulement aux enfants", "Tous les citoyens", "Les fonctionnaires", "Les étrangers uniquement"], "correct": 1},
        {"question": "Quel droit est garanti à toute personne arrêtée ?", "options": ["Le droit d'être entendue par un juge", "Le droit de garder le silence total", "Le droit de fuir", "Le droit de refuser tout jugement"], "correct": 0},
        {"question": "Les droits humains sont :", "options": ["Optionnels", "Universels et inaliénables", "Nationaux", "Héréditaires"], "correct": 1},
        {"question": "Le droit d'expression permet :", "options": ["De dire ce qu'on veut en respectant la loi", "D'insulter les autres", "De mentir en public", "De menacer les institutions"], "correct": 0},
        {"question": "Quel groupe est protégé par des droits spécifiques ?", "options": ["Les enfants et les femmes", "Les hommes riches", "Les stars de foot", "Les politiciens"], "correct": 0},
      ];
    case "Civisme et valeurs":
      return [
        {"question": "Qu'est-ce que le civisme ?", "options": ["Le respect des lois et du bien commun", "L'amour du sport", "L'obéissance à un chef", "La liberté totale"], "correct": 0},
        {"question": "Quelle valeur favorise la paix dans une société ?", "options": ["La tolérance", "La haine", "La jalousie", "La division"], "correct": 0},
        {"question": "Jeter les ordures dans une poubelle, c'est un acte de :", "options": ["Malpropreté", "Civisme", "Paresse", "Protestation"], "correct": 1},
        {"question": "Que doit faire un bon citoyen pendant les élections ?", "options": ["Voter dans le calme", "Faire campagne dans la rue", "Refuser le scrutin", "Protester violemment"], "correct": 0},
        {"question": "Le respect du drapeau national est un signe de :", "options": ["Civisme et patriotisme", "Désintérêt", "Rébellion", "Ignorance"], "correct": 0},
        {"question": "Quelle valeur est importante pour vivre ensemble ?", "options": ["Le respect", "L'égoïsme", "La moquerie", "La violence"], "correct": 0},
        {"question": "Rendre service à son voisin est un acte de :", "options": ["Civisme", "Solidarité", "Paresse", "Colère"], "correct": 1},
        {"question": "Être ponctuel montre :", "options": ["Le respect du temps", "Le désordre", "La paresse", "Le mépris"], "correct": 0},
        {"question": "Pourquoi doit-on respecter les autorités ?", "options": ["Parce qu'elles représentent la loi", "Parce qu'on a peur", "Pour gagner de l'argent", "Par obligation"], "correct": 0},
        {"question": "Quelle est une valeur fondamentale de la société ivoirienne ?", "options": ["La fraternité", "La tricherie", "Le mensonge", "L'indifférence"], "correct": 0},
      ];
    default:
      return [{"question": "Quiz en construction", "options": ["Option 1", "Option 2", "Option 3", "Option 4"], "correct": 0}];
  }
}