import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'notifications_view.dart';
import 'profil_view.dart';



// Widget pour les icônes avec dégradé
class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Gradient gradient;

  const GradientIcon({
    required this.icon,
    required this.size,
    required this.gradient,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Icon(icon, size: size, color: Colors.white),
    );
  }
}

class EntetePersonalise extends StatelessWidget implements PreferredSizeWidget {
  const EntetePersonalise({super.key});

  // Dégradé officiel MEC
  final LinearGradient mecGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF7F00), Color(0xFF1556B5)],
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: false,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0, top: 8, bottom: 8),
        child: Image.asset('assets/logo_MEC_1.png', height: 25, width: 25),
      ),
      actions: [
        // Bouton Profil (avec passage de user)
        IconButton(
          icon: GradientIcon(
            icon: Icons.person,
            size: 32,
            gradient: mecGradient,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilView(), //  PASSAGE OK !
              ),
            );
          },
        ),

        // Notifications
        Transform.rotate(
          angle: -30 * math.pi / 180,
          child: IconButton(
            icon: GradientIcon(
              icon: Icons.send_outlined,
              size: 32,
              gradient: mecGradient,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationView(),
                ),
              );
            },
          ),
        ),

        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
