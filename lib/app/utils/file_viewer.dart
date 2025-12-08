import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FileViewer {
  /// Opens file based on its type
  static Future<void> open(BuildContext context, String fileUrl) async {
    final ext = fileUrl.split('.').last.toLowerCase();

    // 1️⃣ Images
    if (['png', 'jpg', 'jpeg', 'gif', 'webp'].contains(ext)) {
      _openImage(context, fileUrl);
    }
    // 2️⃣ PDFs
    else if (ext == 'pdf') {
      openPDF(context, fileUrl);
    }
    // 3️⃣ Other documents → DOCX, XLSX, PPT, ZIP etc
    else {
      await _openNative(fileUrl);
    }
  }

  /// Opens image in PhotoView
  static void _openImage(BuildContext context, String fileUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => Scaffold(
              appBar: AppBar(title: const Text('Image Preview')),
              body: PhotoView(
                imageProvider: NetworkImage(fileUrl),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3,
              ),
            ),
      ),
    );
  }

  /// Opens PDF in-app
  static Future<void> openPDF(BuildContext context, String fileUrl) async {
    final response = await http.get(Uri.parse(fileUrl));
    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => Scaffold(
                appBar: AppBar(title: const Text('PDF Preview')),
                body: SfPdfViewer.memory(bytes),
              ),
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to load PDF')));
    }
  }

  /// Opens any other file in native app
  static Future<void> _openNative(String fileUrl) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final fileName = fileUrl.split('/').last;
      final filePath = "${tempDir.path}/$fileName";

      // Download the file
      final response = await http.get(Uri.parse(fileUrl));
      final file = await File(filePath).writeAsBytes(response.bodyBytes);

      await OpenFilex.open(file.path);
    } catch (e) {
      print("Error opening file: $e");
    }
  }
}
