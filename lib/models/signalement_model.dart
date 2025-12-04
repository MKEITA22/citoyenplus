class SignalementModel {
  final int? id;
  final String description;
  final String image; // url or local path
  final String tags; // comma separated
  final String status;
  final DateTime createdAt;
  final int userId;

  SignalementModel({
    this.id,
    required this.description,
    this.image = "",
    this.tags = "",
    this.status = "Actif",
    DateTime? createdAt,
    required this.userId,
  }) : createdAt = createdAt ?? DateTime.now();

  factory SignalementModel.fromJson(Map<String, dynamic> json) {
    return SignalementModel(
      id: json['id'],
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      tags: json['tags'] ?? '',
      status: json['status'] ?? 'Actif',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      userId: json['user_id'] ?? json['userId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "description": description,
        "image": image,
        "tags": tags,
        "status": status,
        "user_id": userId,
      };
}
