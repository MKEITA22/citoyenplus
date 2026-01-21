class QuizModel {
  final int id;
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuizModel({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswer: json['correct_answer'],
    );
  }
}
