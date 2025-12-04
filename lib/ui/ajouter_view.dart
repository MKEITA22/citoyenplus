import 'package:flutter/material.dart';
import 'package:on_mec/ui/entete.dart';

class AjouterView extends StatefulWidget {
  const AjouterView({super.key});

  @override
  State<AjouterView> createState() => _AjouterViewState();
}

class _AjouterViewState extends State<AjouterView> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: EntetePersonalise(),
    );
  }
}