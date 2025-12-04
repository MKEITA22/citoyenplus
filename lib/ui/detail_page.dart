import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final String title;
  final String details;

  const DetailPage({super.key, required this.title, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFFF7F00), // couleur charte graphique
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          details,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
      ),
    );
  }
}
