import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  final String title;
  final String content;
  final String? imageUrl;
  final String? username;
  final String? avatarUrl;
  final String? timeAgo;
  final String? excerpt;

  const PostCard({
    super.key,
    required this.title,
    required this.content,
    this.imageUrl,
    this.username,
    this.avatarUrl,
    this.timeAgo,
    this.excerpt,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _expanded = false;

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature arrivent bientôt 🚀'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = widget.username ?? 'Citoyen +';
    final timeAgo = widget.timeAgo ?? "À l'instant";
    final initial = username[0].toUpperCase();
    final bool hasMore = widget.content.length > 120;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Header ──────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 8, 8),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF7F00), Color(0xFF1556B5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: widget.avatarUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  widget.avatarUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _initiale(initial),
                                ),
                              )
                            : _initiale(initial),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13.5,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        timeAgo,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, color: Colors.black54),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // ── Image ────────────────────────────────────────────────────
          if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                widget.imageUrl!,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    height: 200,
                    color: Colors.grey[100],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),

          // ── Actions (désactivées) ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
            child: Row(
              children: [
                _ActionBtn(
                  icon: Icons.favorite_border,
                  onTap: () => _showComingSoon(context, 'Les likes'),
                ),
                const SizedBox(width: 14),
                _ActionBtn(
                  icon: Icons.mode_comment_outlined,
                  onTap: () => _showComingSoon(context, 'Les commentaires'),
                ),
                const SizedBox(width: 14),
                _ActionBtn(
                  icon: Icons.near_me_outlined,
                  onTap: () => _showComingSoon(context, 'Le partage'),
                ),
                const Spacer(),
                _ActionBtn(
                  icon: Icons.bookmark_border,
                  onTap: () => _showComingSoon(context, 'La sauvegarde'),
                ),
              ],
            ),
          ),

          // ── Titre + Contenu ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre en gras
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14.5,
                    color: Colors.black87,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),

                // Contenu avec "voir plus"
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 250),
                  crossFadeState: _expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: Text(
                    widget.content,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: Colors.black87,
                      height: 1.45,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  secondChild: Text(
                    widget.content,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: Colors.black87,
                      height: 1.45,
                    ),
                  ),
                ),

                // Bouton voir plus / voir moins
                if (hasMore)
                  GestureDetector(
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _expanded ? 'voir moins' : 'voir plus',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _initiale(String letter) {
    return Center(
      child: Text(
        letter,
        style: const TextStyle(
          color: Color(0xFF1556B5),
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
    );
  }
}

// ── Bouton action ────────────────────────────────────────────────────────────
class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 26, color: Colors.black87),
    );
  }
}