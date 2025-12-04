class PostModel {
  String username;
  String imagePath;
  int likes;
  int comments;
  String type;
  String description;
  String? tags;

  PostModel({
    required this.username,
    required this.imagePath,
    required this.likes,
    required this.comments,
    required this.type,
    required this.description,
    this.tags,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      username: json['username'] ?? 'Utilisateur',
      imagePath: json['image'] ?? '',
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      tags: json['tags'],
    );
  }

  get createdAt => null;
}
