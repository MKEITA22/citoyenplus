import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/signalement.dart';
import '../services/recuperer_signalement_service.dart';

class NotificationView extends StatefulWidget {
  final VoidCallback? onMesActionsPressed;
  const NotificationView({super.key, this.onMesActionsPressed});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Toutes', 'Récents', 'Résolus'];

  Future<List<SignalementModel>>? _futureSignalements;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    setState(() {
      _futureSignalements = RecupererSignalementService.fetchAllSignalement(token);
    });
  }

  List<SignalementModel> _filtered(List<SignalementModel> all) {
    switch (_selectedTab) {
      case 1: // Récents — moins de 7 jours
        final cutoff = DateTime.now().subtract(const Duration(days: 7));
        return all.where((s) => s.createdAt != null && s.createdAt!.isAfter(cutoff)).toList();
      case 2: // Résolus
        return all.where((s) => s.statut?.toUpperCase() == 'RÉSOLU' || s.statut?.toUpperCase() == 'RESOLU').toList();
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            // ── AppBar ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  const Text(
                    'Activité',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const Spacer(),
                  // Bouton Mes actions
                  GestureDetector(
                    onTap: widget.onMesActionsPressed,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.list_alt_rounded, color: Colors.white, size: 14),
                          SizedBox(width: 5),
                          Text('Mes actions', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Tabs ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: List.generate(_tabs.length, (i) {
                  final selected = _selectedTab == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTab = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: selected ? Colors.white : const Color(0xFF1C1C1C),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _tabs[i],
                        style: TextStyle(
                          color: selected ? Colors.black : Colors.white54,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 8),

            // ── Liste des signalements ────────────────────────────────────
            Expanded(
              child: FutureBuilder<List<SignalementModel>>(
                future: _futureSignalements,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFFFF7F00)),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.wifi_off, color: Colors.white38, size: 48),
                          const SizedBox(height: 12),
                          Text('Erreur de chargement', style: TextStyle(color: Colors.white38, fontSize: 14)),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: _load,
                            child: const Text('Réessayer', style: TextStyle(color: Color(0xFFFF7F00))),
                          ),
                        ],
                      ),
                    );
                  }

                  final all = snapshot.data ?? [];
                  final signalements = _filtered(all);

                  if (signalements.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.notifications_off_outlined, color: Colors.white24, size: 52),
                          SizedBox(height: 12),
                          Text('Aucune activité pour le moment', style: TextStyle(color: Colors.white38, fontSize: 14)),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _load,
                    color: const Color(0xFFFF7F00),
                    backgroundColor: const Color(0xFF1C1C1C),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: signalements.length,
                      itemBuilder: (context, index) {
                        final s = signalements[index];
                        return _SignalementNotifTile(signalement: s);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tile signalement ──────────────────────────────────────────────────────────

class _SignalementNotifTile extends StatefulWidget {
  final SignalementModel signalement;
  const _SignalementNotifTile({required this.signalement});

  @override
  State<_SignalementNotifTile> createState() => _SignalementNotifTileState();
}

class _SignalementNotifTileState extends State<_SignalementNotifTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.97,
      upperBound: 1.0,
    )..value = 1.0;
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  Color get _couleurStatut {
    switch (widget.signalement.statut?.toUpperCase() ?? '') {
      case 'NOUVEAU':   return const Color(0xFF1556B5);
      case 'EN_COURS':
      case 'EN COURS':  return const Color(0xFFFF7F00);
      case 'RÉSOLU':
      case 'RESOLU':    return const Color(0xFF34C759);
      case 'REJETÉ':
      case 'REJETE':    return const Color(0xFFFF2D55);
      default:          return Colors.grey;
    }
  }

  IconData get _iconeStatut {
    switch (widget.signalement.statut?.toUpperCase() ?? '') {
      case 'NOUVEAU':   return Icons.fiber_new_outlined;
      case 'EN_COURS':
      case 'EN COURS':  return Icons.hourglass_top_rounded;
      case 'RÉSOLU':
      case 'RESOLU':    return Icons.check_circle_outline;
      case 'REJETÉ':
      case 'REJETE':    return Icons.cancel_outlined;
      default:          return Icons.report_outlined;
    }
  }

  String get _timeAgo {
    final date = widget.signalement.createdAt;
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24)   return '${diff.inHours} h';
    if (diff.inDays < 7)     return '${diff.inDays} j';
    return '${date.day}/${date.month}/${date.year}';
  }

  bool get _isNew {
    final date = widget.signalement.createdAt;
    if (date == null) return false;
    return DateTime.now().difference(date).inHours < 24;
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.signalement;
    final couleur = _couleurStatut;
    final initial = (s.titre.isNotEmpty ? s.titre[0] : '?').toUpperCase();

    return GestureDetector(
      onTapDown: (_) => _ctrl.reverse(),
      onTapUp: (_) => _ctrl.forward(),
      onTapCancel: () => _ctrl.forward(),
      child: ScaleTransition(
        scale: _ctrl,
        child: Container(
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: _isNew ? const Color(0xFF1A1A1A) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            border: _isNew
                ? Border.all(color: Colors.white.withOpacity(0.05))
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Avatar / miniature ──────────────────────────────────
              Stack(
                children: [
                  // Photo du signalement ou initiale
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: s.photo != null && s.photo!.isNotEmpty
                        ? Image.network(
                            s.photo!,
                            width: 48, height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _avatarFallback(initial, couleur),
                          )
                        : _avatarFallback(initial, couleur),
                  ),
                  // Badge statut
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 18, height: 18,
                      decoration: BoxDecoration(
                        color: couleur,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF0A0A0A), width: 1.5),
                      ),
                      child: Icon(_iconeStatut, color: Colors.white, size: 10),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              // ── Contenu ─────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 13.5, color: Colors.white, height: 1.4),
                        children: [
                          TextSpan(
                            text: s.titre,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const TextSpan(
                            text: '  ',
                          ),
                          TextSpan(
                            text: s.description,
                            style: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w400, fontSize: 13),
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        // Catégorie — tronquée si trop longue
                        if (s.categorieNom != null && s.categorieNom!.isNotEmpty)
                          Flexible(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1556B5).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                s.categorieNom!,
                                style: const TextStyle(color: Color(0xFF5B8DEF), fontSize: 10, fontWeight: FontWeight.w600),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        if (s.categorieNom != null && s.categorieNom!.isNotEmpty)
                          const SizedBox(width: 6),
                        // Statut — taille fixe
                        Flexible(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: couleur.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              s.statut ?? 'NOUVEAU',
                              style: TextStyle(color: couleur, fontSize: 10, fontWeight: FontWeight.w700),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(_timeAgo, style: const TextStyle(color: Colors.white30, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Point non lu ─────────────────────────────────────────
              if (_isNew)
                Container(
                  width: 8, height: 8,
                  margin: const EdgeInsets.only(top: 4, left: 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF7F00),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatarFallback(String initial, Color couleur) {
    return Container(
      width: 48, height: 48,
      decoration: BoxDecoration(
        color: couleur.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: couleur.withOpacity(0.5), width: 1.5),
      ),
      child: Center(
        child: Text(initial, style: TextStyle(color: couleur, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}