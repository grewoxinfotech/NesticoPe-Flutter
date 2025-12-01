import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../../app/constants/api_constants.dart';

class MediaUploadService {
  final ImagePicker _picker = ImagePicker();
  Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }

  // Pick multiple images
  Future<List<File>> pickImages({
    int maxWidth = 800,
    int maxHeight = 800,
    int imageQuality = 80,
  }) async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage(
        maxWidth: maxWidth.toDouble(),
        maxHeight: maxHeight.toDouble(),
        imageQuality: imageQuality,
      );

      if (pickedFiles != null) {
        return pickedFiles.map((x) => File(x.path)).toList();
      }
      return [];
    } catch (e) {
      debugPrint('Error picking images: $e');
      throw Exception('Failed to pick images: $e');
    }
  }

  // Pick single video
  Future<File?> pickVideo() async {
    try {
      final XFile? pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking video: $e');
      throw Exception('Failed to pick video: $e');
    }
  }

  // Upload media files
  Future<Map<String, dynamic>> uploadMediaFiles({
    required String projectId,
    required String variantId,
    required List<File> images,
    required List<File> videos,
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.builderProject}/$projectId/$variantId/media',
      );

      debugPrint("Upload URI: $uri");

      var request = http.MultipartRequest('POST', uri);

      // Add images
      for (var image in images) {
        request.files.add(
          await http.MultipartFile.fromPath('variant_images', image.path),
        );
      }

      // Add videos
      for (var video in videos) {
        request.files.add(
          await http.MultipartFile.fromPath('variant_videos', video.path),
        );
      }

      request.headers.addAll(await header());

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'message': 'Upload successful',
          'data': responseBody,
        };
      } else {
        return {
          'success': false,
          'message': 'Upload failed: ${response.statusCode}',
          'error': responseBody,
        };
      }
    } catch (e) {
      debugPrint('Upload error: $e');
      return {
        'success': false,
        'message': 'Upload error',
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> removeVariantMedia({
    required String projectId,
    required String variantId,
    required String mediaType, // "image" or "video"
    required String mediaUrl, // exact URL from variant list
  }) async {
    try {
      final uri = Uri.parse(
        '${ApiConstants.builderProject}/$projectId/$variantId/media',
      );

      debugPrint("Remove Media URI: $uri");

      final body = {"mediaType": mediaType, "mediaUrl": mediaUrl};

      debugPrint("Remove Payload: $body");

      final response = await http.delete(
        uri,
        headers: await header(),
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        return {
          "success": true,
          "message": "Media removed",
          "data": jsonDecode(response.body),
        };
      } else {
        return {
          "success": false,
          "message": "Failed: ${response.statusCode}",
          "error": response.body,
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Exception occurred",
        "error": e.toString(),
      };
    }
  }
}
