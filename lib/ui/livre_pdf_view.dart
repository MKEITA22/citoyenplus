import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class LivrePdfView extends StatefulWidget {
  final String pdf;
  const LivrePdfView({super.key, required this.pdf});

  @override
  // ignore: library_private_types_in_public_api
  LivrePdfViewState createState() => LivrePdfViewState();
}

class LivrePdfViewState extends State<LivrePdfView> {
  late PdfControllerPinch pdfController;

  @override
  void initState() {
    super.initState();
    pdfController = PdfControllerPinch(
      document: PdfDocument.openAsset(widget.pdf),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lecture PDF")),
      body: PdfViewPinch(controller: pdfController),
    );
  }
}
