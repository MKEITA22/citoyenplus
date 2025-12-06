import 'package:flutter/material.dart';

class Quizquestions extends StatefulWidget {
  final String categorie;
  final List<Map<String, dynamic>> questions;

  const Quizquestions({
    super.key,
    required this.categorie,
    required this.questions,
  });

  @override
  State<Quizquestions> createState() => QuizPageState();
}

class QuizPageState extends State<Quizquestions> {
  int questionIndex = 0;
  int score = 0;
  int? selectedAnswer;

  void nextQuestion() {
    if (selectedAnswer == widget.questions[questionIndex]['correct']) {
      score++;
    }
    if (questionIndex < widget.questions.length - 1) {
      setState(() {
        questionIndex++;
        selectedAnswer = null;
      });
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Quiz terminé !"),
          content: Text(
            "Tu as obtenu $score / ${widget.questions.length} bonnes réponses !",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // fermer le dialog
                Navigator.pop(context); // retour à la page précédente
              },
              child: const Text("Retour"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[questionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categorie),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${questionIndex + 1}/${widget.questions.length}",
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              question['question'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ...List.generate(4, (i) {
              final isSelected = selectedAnswer == i;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAnswer = i;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.orangeAccent.withOpacity(0.2)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? Colors.orangeAccent
                          : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    question['options'][i],
                    style: TextStyle(
                      fontSize: 16,
                      color: isSelected ? Colors.orangeAccent : Colors.black,
                    ),
                  ),
                ),
              );
            }),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: selectedAnswer != null ? nextQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Suivant",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
