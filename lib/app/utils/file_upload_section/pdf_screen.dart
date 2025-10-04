import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewPage extends StatefulWidget {
  final String path;
  const PdfViewPage({Key? key, required this.path}) : super(key: key);

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  PdfControllerPinch? _pdfController;

  @override
  void initState() {
    super.initState();
    if (File(widget.path).existsSync()) {
      _pdfController = PdfControllerPinch(
        document: PdfDocument.openFile(widget.path),
      );
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_pdfController == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('View PDF')),
        body: const Center(child: Text('File not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('View PDF')),
      body: PdfViewPinch(controller: _pdfController!),
    );
  }
}
