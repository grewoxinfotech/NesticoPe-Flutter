import 'dart:io';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ModelCacheService {
  static Future<String> downloadAndCache(String url, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');

    if (await file.exists()) {
      return file.path;
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Failed to download model');
    }

    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }
}

class ModelRenderScreen extends StatefulWidget {
  final String modelUrl;
  final String iosModelUrl;

  const ModelRenderScreen({
    super.key,
    required this.modelUrl,
    required this.iosModelUrl,
  });

  @override
  State<ModelRenderScreen> createState() => _ModelRenderScreenState();
}

class _ModelRenderScreenState extends State<ModelRenderScreen> {
  String? localGlbPath;
  String? localUsdzPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _prepareModels();
  }

  Future<void> _prepareModels() async {
    try {
      final glb = await ModelCacheService.downloadAndCache(
        widget.modelUrl,
        'property_model.glb',
      );

      String? usdz;
      if (Platform.isIOS) {
        usdz = await ModelCacheService.downloadAndCache(
          widget.iosModelUrl,
          'property_model.usdz',
        );
      }

      setState(() {
        localGlbPath = glb;
        localUsdzPath = usdz;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Model download error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('3D Model Viewer')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ModelViewer(
                src: 'file://$localGlbPath',
                iosSrc: localUsdzPath != null ? 'file://$localUsdzPath' : null,
                alt: "3D property model",
                ar: true,
                autoRotate: true,
                cameraControls: true,
                backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
                autoPlay: true,
                loading: Loading.eager,
              ),
    );
  }
}
