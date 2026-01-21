class PostModel {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String? imageUrl;
  final String? username;
  final int likes;
  final int comments;
  final String tags;
  final String? type;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    this.imageUrl,
    this.username,
    this.likes = 0,
    this.comments = 0,
    this.tags = "Post",
    this.type,
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'] ?? '',
      username: json['username'] ?? 'Citoyen',
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      tags: json['tags'] ?? 'Post',
      type: json['type'],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }

  // Getter pour l'image à utiliser dans PostCard
  String get imagePath => imageUrl != null && imageUrl!.isNotEmpty
      ? imageUrl!
      : 'assets/default.png'; // image par défaut si aucune image

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'image': imageUrl,
      'username': username,
      'likes': likes,
      'comments': comments,
      'tags': tags,
      'type': type,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
