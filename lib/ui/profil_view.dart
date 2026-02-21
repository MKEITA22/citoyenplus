import 'package:flutter/material.dart';
import 'login.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  late TextEditingController fullnameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;

  bool isLoading = true;
  bool _isSaving = false;

  static const _orange = Color(0xFFFF7F00);
  static const _blue = Color(0xFF1556B5);
  static const _fillColor = Color(0xFFF8F9FF);

  @override
  void initState() {
    super.initState();
    fullnameCtrl = TextEditingController();
    emailCtrl = TextEditingController();
    phoneCtrl = TextEditingController();
    _loadProfile();
  }

  @override
  void dispose() {
    fullnameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final token = await AuthService.getToken("data");
      final data = await UserService.fetchProfile(token ?? '');
      if (!mounted) return;
      setState(() {
        fullnameCtrl.text = data['fullname'] ?? '';
        emailCtrl.text = data['email'] ?? '';
        phoneCtrl.text = data['phone'] ?? '';
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur chargement profil: $e')),
      );
    }
  }

  Future<void> _updateProfile() async {
    setState(() => _isSaving = true);
    try {
      final token = await AuthService.getToken("data");
      if (token == null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginView()));
        return;
      }
      final success = await UserService.updateProfile(
        token: token,
        name: fullnameCtrl.text,
        email: emailCtrl.text,
        phone: phoneCtrl.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(success ? '✅ Profil mis à jour avec succès' : 'Erreur lors de la mise à jour'),
        backgroundColor: success ? const Color(0xFF34C759) : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  InputDecoration _fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      prefixIcon: Icon(icon, color: _blue, size: 20),
      filled: true,
      fillColor: _fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _blue, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initiale = fullnameCtrl.text.isNotEmpty
        ? fullnameCtrl.text[0].toUpperCase()
        : '?';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Mon Profil', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black87)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Avatar initiale (pas de photo) ─────────────────────
                  Center(
                    child: Container(
                      width: 90, height: 90,
                      decoration: const BoxDecoration(
                        color: _blue,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          initiale,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      fullnameCtrl.text.isNotEmpty ? fullnameCtrl.text : '',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: Colors.black87),
                    ),
                  ),
                  Center(
                    child: Text(
                      emailCtrl.text,
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Section infos ──────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Informations personnelles',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Colors.black87)),
                        const SizedBox(height: 16),

                        TextField(
                          controller: fullnameCtrl,
                          decoration: _fieldDecoration('Nom complet', Icons.person_outline_rounded),
                        ),
                        const SizedBox(height: 12),

                        TextField(
                          controller: emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _fieldDecoration('Adresse e-mail', Icons.mail_outline_rounded),
                        ),
                        const SizedBox(height: 12),

                        TextField(
                          controller: phoneCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: _fieldDecoration('Téléphone', Icons.phone_outlined),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Bouton Enregistrer ─────────────────────────────────
                  SizedBox(
                    height: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: _orange,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: _isSaving ? null : _updateProfile,
                        child: _isSaving
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save_rounded, color: Colors.white, size: 18),
                                  SizedBox(width: 8),
                                  Text('Enregistrer', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                                ],
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // ── Bouton Déconnexion ─────────────────────────────────
                  SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.red.shade300),
                        backgroundColor: Colors.red.shade50,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginView()),
                          (route) => false,
                        );
                      },
                      icon: Icon(Icons.logout_rounded, color: Colors.red.shade400, size: 18),
                      label: Text('Déconnexion', style: TextStyle(color: Colors.red.shade400, fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Version de l'application ───────────────────────
                  Center(
                    child: Column(
                      children: [
                        Divider(color: Colors.grey.shade200),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: _orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.asset('assets/logo_MEC_1.png', height: 16, width: 16),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Citoyen +',
                              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.black54),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Version 1.0.0',
                          style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}