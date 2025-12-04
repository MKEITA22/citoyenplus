import 'dart:io';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final String username;
  final String imagePath;
  final int likes;
  final int comments;
  final String tag;
  final String description;

  const PostCard({
    super.key,
    required this.username,
    required this.imagePath,
    required this.likes,
    required this.comments,
    required this.tag,
    this.description = "",
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int likeCount;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    likeCount = widget.likes;
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
      if (likeCount < 0) likeCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> displayTags =
        widget.tag.split(', ').map((e) => e.trim()).toList();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tags
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 6,
              children: displayTags.map((t) {
                List<Color> colors;

                switch (t) {
                  case "Action Citoyenne":
                    colors = [Color(0xFFFF7F00), Color(0xFF1556B5)];
                    break;
                  default:
                    colors = [Colors.blue, Colors.purple];
                }

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: colors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    t,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/user.jpg'),
                ),
                const SizedBox(width: 10),
                Text(
                  widget.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Icon(Icons.more_vert),
              ],
            ),
          ),

          // Image
          SizedBox(
            height: 220,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              child: widget.imagePath.startsWith("assets/")
                  ? Image.asset(widget.imagePath, fit: BoxFit.cover)
                  : Image.file(File(widget.imagePath), fit: BoxFit.cover),
            ),
          ),

          // Description
          if (widget.description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Text(widget.description),
            ),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.black,
                    size: 28,
                  ),
                  onPressed: toggleLike,
                ),
                IconButton(
                  icon: const Icon(Icons.mode_comment_outlined, size: 26),
                  onPressed: () {},
                ),
                const Spacer(),
              ],
            ),
          ),

          // Likes
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              "Aimé par $likeCount personnes",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // Commentaires
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Text(
              "Voir les ${widget.comments} commentaires",
              style: const TextStyle(color: Colors.grey),
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
