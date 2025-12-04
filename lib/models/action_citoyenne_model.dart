class ActionCitoyenneModel {
  final int? id;
  final String description;
  final String image;
  final String tags; // ex: "Action Citoyenne"
  final int likes;
  final int comments;
  final int userId;
  final DateTime createdAt;

  ActionCitoyenneModel({
    this.id,
    required this.description,
    required this.image,
    required this.tags,
    required this.likes,
    required this.comments,
    required this.userId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ActionCitoyenneModel.fromJson(Map<String, dynamic> json) {
    return ActionCitoyenneModel(
      id: json['id'],
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      tags: json['tags'] ?? 'Action Citoyenne',
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      userId: json['user_id'] ?? 0,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "image": image,
        "tags": tags,
        "likes": likes,
        "comments": comments,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
      };
}
