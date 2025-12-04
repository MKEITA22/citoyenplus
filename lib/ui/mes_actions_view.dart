import 'dart:io';
import 'package:flutter/material.dart';
import 'package:on_mec/models/post_model.dart';

class MesActionsView extends StatelessWidget {
  final List<PostModel> posts; // ⚡ Liste des posts passée depuis l’accueil

  const MesActionsView({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    // 🔥 Récupérer uniquement les signalements + tri du plus récent
    final List<PostModel> mesSignalements =
        posts.where((p) => p.type == "signalement").toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mes actions",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: mesSignalements.isEmpty
          ? Center(
              child: Text(
                "Aucune action signalée pour le moment 👀",
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: mesSignalements.length,
              itemBuilder: (context, index) {
                final post = mesSignalements[index];

                final tagsList =
                    post.tags != null && post.tags!.isNotEmpty
                        ? post.tags!.split(",")
                        : [];
                final themeTag = tagsList.length >= 2
                    ? tagsList[1].trim()
                    : "Incivisme";

                return _actionItem(
                  image: post.imagePath,
                  theme: themeTag,
                  description: post.description.isNotEmpty
                      ? post.description
                      : "Aucun détail fourni.",
                  date: post.createdAt,
                  statut: "Actif",
                  statutColor: Colors.green,
                );
              },
            ),
    );
  }

  // --------------------------------------------------
  // 🔥 Carte d’une action signalée
  // --------------------------------------------------
  Widget _actionItem({
    required String image,
    required String theme,
    required String description,
    required DateTime date,
    required String statut,
    required Color statutColor,
  }) {
    ImageProvider imgProvider;

    if (image.startsWith("assets/")) {
      imgProvider = AssetImage(image);
    } else if (image.startsWith("http")) {
      imgProvider = NetworkImage(image);
    } else {
      imgProvider = FileImage(File(image));
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image(
              image: imgProvider,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 14),
          // Texte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thème
                Text(
                  theme,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                // Description
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Date + Statut
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${date.day}/${date.month}/${date.year}",
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    Text(
                      statut,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: statutColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
