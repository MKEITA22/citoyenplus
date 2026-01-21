class SignalementModel {
  final int id;
  final int userId;
  final String description;
  final String? categorie;
  final String? imageUrl;
  final DateTime createdAt;
  final String statut;

  SignalementModel({
    required this.id,
    required this.userId,
    required this.description,
    this.categorie,
    this.imageUrl,
    required this.createdAt,
    required this.statut,
  });

  factory SignalementModel.fromJson(Map<String, dynamic> json) {
    return SignalementModel(
      id: json['id'],
      userId: json['user_id'],
      description: json['description'],
      categorie: json['categorie'],
      imageUrl: json['image'],
      statut: json['statut'] ?? 'Actif',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  get categoriesignalement => null;

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'categorie': categorie,
    };
  }
}
