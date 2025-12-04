import 'package:flutter/material.dart';
import 'package:on_mec/ui/mes_actions_view.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: ListView(
        padding: EdgeInsets.all(16),
        children: [

          // 🔥 Notification : Like reçu
          _notifItem(
            title: "Nouvelle interaction ❤️",
            subtitle: "Mireille a liké ton post.",
            icon: Icons.favorite,
          ),

          // 🔥 Notification : Commentaire reçu
          _notifItem(
            title: "Nouveau commentaire 💬",
            subtitle: "Omar a commenté ton post.",
            icon: Icons.mode_comment_outlined,
          ),

          // 🔥 BOUTON : Liste des actions
          GestureDetector(
            onTap: () {
              // 👉 Navigation (à brancher)
              Navigator.push(context, MaterialPageRoute(builder: (_) => MesActionsView(posts: [],)));
            },
            child: _notifItem(
              title: "Mes actions citoyennes 📝",
              subtitle: "Consulte tes signalements et leur statut.",
              icon: Icons.list_alt_rounded, // Icône dédié
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF7F00), // orange On_Mec
                  Color(0xFF1556B5), // bleu On_Mec
                ],
              ),
            ),
          ),

          SizedBox(height: 12),

          // 👉 Anciennes notifications (toujours affichées)
          _notifItem(
            title: "Nouvelle mise à jour 👀",
            subtitle: "Une nouvelle version de l’application est disponible.",
            icon: Icons.system_update,
          ),
          _notifItem(
            title: "Nouveau message 💬",
            subtitle: "Tu as reçu une réponse dans ton chat IA.",
            icon: Icons.chat_bubble_outline,
          ),
          _notifItem(
            title: "Badge débloqué 🏅",
            subtitle: "Bravo, tu viens d’obtenir un nouveau badge !",
            icon: Icons.emoji_events_outlined,
          ),
          _notifItem(
            title: "Rappel 🔔",
            subtitle: "N’oublie pas ta session d’apprentissage du jour.",
            icon: Icons.notifications_active_outlined,
          ),
        ],
      ),
    );
  }

  // 🍀 Widget notification stylé
  Widget _notifItem({
    required String title,
    required String subtitle,
    required IconData icon,
    Gradient? gradient, // Permet d'utiliser plusieurs styles
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          // 🌈 Icône stylé (gradient si défini)
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: gradient ??
                  LinearGradient(
                    colors: [
                      Color(0xFF007AFF),
                      Color(0xFF00D4FF),
                    ],
                  ),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),

          SizedBox(width: 16),

          // Texte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
