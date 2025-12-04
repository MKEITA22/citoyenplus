class QuizModel {
  final int id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String category;
  final DateTime createdAt;

  QuizModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.category,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'],
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctIndex: json['correct_index'] ?? 0,
      category: json['category'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "question": question,
        "options": options,
        "correct_index": correctIndex,
        "category": category,
        "created_at": createdAt.toIso8601String(),
      };
}
