// import 'dart:convert';
// import 'dart:io';
//
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
//
// import '../../../../app/constants/api_constants.dart';
//
// class MediaUploadService {
//   final ImagePicker _picker = ImagePicker();
//   Future<Map<String, String>> header() async {
//     return await ApiConstants.getHeaders();
//   }
//
//   // Pick multiple images
//   Future<List<File>> pickImages({
//     int maxWidth = 800,
//     int maxHeight = 800,
//     int imageQuality = 80,
//   }) async {
//     try {
//       final List<XFile>? pickedFiles = await _picker.pickMultiImage(
//         maxWidth: maxWidth.toDouble(),
//         maxHeight: maxHeight.toDouble(),
//         imageQuality: imageQuality,
//       );
//
//       if (pickedFiles != null) {
//         return pickedFiles.map((x) => File(x.path)).toList();
//       }
//       return [];
//     } catch (e) {
//       debugPrint('Error picking images: $e');
//       throw Exception('Failed to pick images: $e');
//     }
//   }
//
//   // Pick single video
//   Future<File?> pickVideo() async {
//     try {
//       final XFile? pickedFile = await _picker.pickVideo(
//         source: ImageSource.gallery,
//       );
//
//       if (pickedFile != null) {
//         return File(pickedFile.path);
//       }
//       return null;
//     } catch (e) {
//       debugPrint('Error picking video: $e');
//       throw Exception('Failed to pick video: $e');
//     }
//   }
//
//   // Pick single 3D model file
//   Future<File?> pick3DModel() async {
//     try {
//       final result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowMultiple: false,
//         allowedExtensions: [
//           'glb',
//           'gltf',
//           'fbx',
//           'obj',
//           'stl',
//           'dae',
//         ],
//       );
//
//       if (result != null && result.files.single.path != null) {
//         return File(result.files.single.path!);
//       }
//
//       return null;
//     } catch (e) {
//       debugPrint('Error picking 3D model: $e');
//       throw Exception('Failed to pick 3D model: $e');
//     }
//   }
//
//
//   // Upload media files
//   Future<Map<String, dynamic>> uploadMediaFiles({
//     required String projectId,
//     required String variantId,
//     required List<File> images,
//     required List<File> videos,
//      File? model
//   }) async {
//     try {
//       final uri = Uri.parse(
//         '${ApiConstants.builderProject}/$projectId/$variantId/media',
//       );
//
//       debugPrint("Upload URI: $uri");
//
//       var request = http.MultipartRequest('POST', uri);
//
//       // Add images
//       for (var image in images) {
//         request.files.add(
//           await http.MultipartFile.fromPath('variant_images', image.path),
//         );
//       }
//
//       // Add videos
//       for (var video in videos) {
//         request.files.add(
//           await http.MultipartFile.fromPath('variant_videos', video.path),
//         );
//       }
//
//       if(model != null){
//         request.files.add(
//           await http.MultipartFile.fromPath('variant_3d_model', model.path),
//         );
//       }
//
//
//
//       request.headers.addAll(await header());
//
//       final response = await request.send();
//       final responseBody = await response.stream.bytesToString();
//
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return {
//           'success': true,
//           'message': 'Upload successful',
//           'data': responseBody,
//         };
//       } else {
//         return {
//           'success': false,
//           'message': 'Upload failed: ${response.statusCode}',
//           'error': responseBody,
//         };
//       }
//     } catch (e) {
//       debugPrint('Upload error: $e');
//       return {
//         'success': false,
//         'message': 'Upload error',
//         'error': e.toString(),
//       };
//     }
//   }
//
//   Future<Map<String, dynamic>> removeVariantMedia({
//     required String projectId,
//     required String variantId,
//     required String mediaType, // "image" or "video"
//     required String mediaUrl, // exact URL from variant list
//   }) async {
//     try {
//       final uri = Uri.parse(
//         '${ApiConstants.builderProject}/$projectId/$variantId/media',
//       );
//
//       debugPrint("Remove Media URI: $uri");
//
//       final body = {"mediaType": mediaType, "mediaUrl": mediaUrl};
//
//       debugPrint("Remove Payload: $body");
//
//       final response = await http.delete(
//         uri,
//         headers: await header(),
//         body: jsonEncode(body),
//       );
//
//       if (response.statusCode == 200) {
//         return {
//           "success": true,
//           "message": "Media removed",
//           "data": jsonDecode(response.body),
//         };
//       } else {
//         return {
//           "success": false,
//           "message": "Failed: ${response.statusCode}",
//           "error": response.body,
//         };
//       }
//     } catch (e) {
//       return {
//         "success": false,
//         "message": "Exception occurred",
//         "error": e.toString(),
//       };
//     }
//   }
// }


import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../../../app/constants/api_constants.dart';

class MediaUploadService {
  final ImagePicker _picker = ImagePicker();

  // Valid 3D model extensions
  static const List<String> valid3DExtensions = [
    'glb',
    'gltf',
    'fbx',
    'obj',
    'stl',
    'dae',
  ];

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

  // Pick single 3D model file with validation
  Future<File?> pick3DModel() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: valid3DExtensions,
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);

        // Additional validation to ensure the file extension is correct
        final fileName = file.path.toLowerCase();
        final isValidExtension = valid3DExtensions.any(
                (ext) => fileName.endsWith('.$ext')
        );

        if (!isValidExtension) {
          debugPrint('Invalid file extension: $fileName');
          throw Exception(
              'Invalid file format. Please select a valid 3D model file:\n'
                  '${valid3DExtensions.map((e) => e.toUpperCase()).join(', ')}'
          );
        }

        // Optional: Check file size (e.g., max 50MB)
        final fileSize = await file.length();
        const maxSize = 50 * 1024 * 1024; // 50MB in bytes

        if (fileSize > maxSize) {
          throw Exception(
              'File size too large. Maximum allowed size is 50MB.\n'
                  'Selected file: ${(fileSize / (1024 * 1024)).toStringAsFixed(2)}MB'
          );
        }

        return file;
      }

      return null;
    } catch (e) {
      debugPrint('Error picking 3D model: $e');
      if (e.toString().contains('Invalid file format') ||
          e.toString().contains('File size too large')) {
        rethrow;
      }
      throw Exception('Failed to pick 3D model: $e');
    }
  }

  // Validate 3D model file
  bool validate3DModelFile(File file) {
    final fileName = file.path.toLowerCase();
    return valid3DExtensions.any((ext) => fileName.endsWith('.$ext'));
  }

  // Get file extension
  String getFileExtension(File file) {
    final fileName = file.path;
    final lastDot = fileName.lastIndexOf('.');
    if (lastDot != -1) {
      return fileName.substring(lastDot + 1).toLowerCase();
    }
    return '';
  }

  // Upload media files
  Future<Map<String, dynamic>> uploadMediaFiles({
    required String projectId,
    required String variantId,
    required List<File> images,
    required List<File> videos,
    File? model,
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

      // Add 3D model with validation
      if (model != null) {
        // Validate before uploading
        if (!validate3DModelFile(model)) {
          return {
            'success': false,
            'message': 'Invalid 3D model file format',
            'error': 'File must be one of: ${valid3DExtensions.join(', ')}',
          };
        }

        final extension = getFileExtension(model);
        debugPrint("Uploading 3D model with extension: $extension");

        request.files.add(
          await http.MultipartFile.fromPath('variant_3d_model', model.path),
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
    required String mediaType, // "image", "video", or "model"
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