import 'package:flutter/material.dart';
import 'package:on_mec/ui/detail_page.dart';

class RegionsPage extends StatelessWidget {
  final String title;
  final List<String> regions;

  const RegionsPage({super.key, required this.title, required this.regions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFFFF7F00), // charte graphique
      ),
      body: ListView.builder(
        itemCount: regions.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(regions[index]),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () {
                // Ici tu peux afficher une page avec les détails du district ou région
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(
                      title: regions[index],
                      details: "Informations détaillées sur ${regions[index]}...",
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
