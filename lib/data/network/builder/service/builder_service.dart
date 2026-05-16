import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:nesticope_app/data/network/builder/model/builder_model.dart';
import 'package:http/http.dart' as http;

import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../widgets/messages/snack_bar.dart';

// import '../model/builder_projectModel.dart';

/// Only http(s) URLs belong in JSON `mediaGallery`; local paths are sent as multipart files.
bool _isRemoteGalleryUrl(String raw) {
  final s = raw.trim();
  if (s.isEmpty) return false;
  final u = Uri.tryParse(s);
  return u != null && u.hasScheme && (u.scheme == 'http' || u.scheme == 'https');
}

Map<String, dynamic> _mediaGalleryJsonForMultipart(Map<String, dynamic> source) {
  List<dynamic> remoteOnly(dynamic list) {
    if (list is! List) return <String>[];
    return list
        .map((e) => e.toString())
        .where(_isRemoteGalleryUrl)
        .toList();
  }

  return <String, dynamic>{
    'images': remoteOnly(source['images']),
    'videos': remoteOnly(source['videos']),
    'documents': remoteOnly(source['documents']),
  };
}

void _normalizeMediaGalleryInProjectMap(Map<String, dynamic> projectMap) {
  final g = projectMap['mediaGallery'];
  if (g != null) {
    if (g is Map<String, dynamic>) {
      projectMap['mediaGallery'] = _mediaGalleryJsonForMultipart(g);
    } else if (g is Map) {
      projectMap['mediaGallery'] = _mediaGalleryJsonForMultipart(
        Map<String, dynamic>.from(g),
      );
    }
  }

  for (final key in ['imageList', 'videoList', 'documentList']) {
    final v = projectMap[key];
    if (v is List) {
      projectMap[key] = v
          .map((e) => e.toString().trim())
          .where(_isRemoteGalleryUrl)
          .toList();
    }
  }
}

String _dateOnly(dynamic value) {
  if (value == null) return '';
  final s = value.toString().trim();
  if (s.isEmpty) return '';
  return s.contains('T') ? s.split('T').first : s;
}

String _fileNameFromUrl(String url) {
  final path = Uri.tryParse(url)?.path ?? url;
  final segments = path.split('/');
  return segments.isNotEmpty ? segments.last : path;
}

MediaType _documentMediaType(String path) {
  final ext = path.split('.').last.toLowerCase();
  switch (ext) {
    case 'pdf':
      return MediaType('application', 'pdf');
    case 'doc':
      return MediaType('application', 'msword');
    case 'docx':
      return MediaType(
        'application',
        'vnd.openxmlformats-officedocument.wordprocessingml.document',
      );
    case 'txt':
      return MediaType('text', 'plain');
    default:
      return MediaType('application', 'octet-stream');
  }
}

List<String> _retainUrlsFromFiles(List<File>? files) {
  if (files == null || files.isEmpty) return [];
  return files
      .map((f) => f.path.trim())
      .where((path) => path.isNotEmpty && _isRemoteGalleryUrl(path))
      .toList();
}

/// PUT /builderproject/:id expects multipart `data` (JSON) + file parts.
Map<String, dynamic> _buildUpdateDataPayload(
  Map<String, dynamic> projectMap, {
  List<String>? retainImageUrls,
  List<String>? retainVideoUrls,
  List<String>? retainDocumentUrls,
}) {
  final mediaGalleryRaw = projectMap['mediaGallery'];
  final fallbackGallery =
      mediaGalleryRaw is Map<String, dynamic>
          ? mediaGalleryRaw
          : mediaGalleryRaw is Map
          ? Map<String, dynamic>.from(mediaGalleryRaw)
          : <String, dynamic>{
            'images': <String>[],
            'videos': <String>[],
            'documents': <String>[],
          };

  final mediaGallery = <String, dynamic>{
    'images': retainImageUrls ?? fallbackGallery['images'] ?? [],
    'videos': retainVideoUrls ?? fallbackGallery['videos'] ?? [],
    'documents': retainDocumentUrls ?? fallbackGallery['documents'] ?? [],
  };

  final pdfPath = projectMap['pdfPath']?.toString().trim() ?? '';
  final brochureName = projectMap['brochure']?.toString().trim() ?? '';
  final brochures = <Map<String, String>>[];
  if (pdfPath.isNotEmpty && _isRemoteGalleryUrl(pdfPath)) {
    brochures.add({
      'name':
          brochureName.isNotEmpty ? brochureName : _fileNameFromUrl(pdfPath),
      'url': pdfPath,
    });
  }

  final zip = projectMap['zipCode']?.toString() ?? '';
  final location = projectMap['location']?.toString() ?? '';

  return {
    'projectName': projectMap['projectName'],
    'builderName':
        projectMap['builderName'] ??
        projectMap['ownerName'] ??
        'Unknown Builder',
    'location': location,
    'city': projectMap['city'],
    'state': projectMap['state'],
    'pinCode': zip,
    'zipCode': zip,
    'address': projectMap['address'],
    'locality': projectMap['locality'] ?? location,
    'propertyTypes': projectMap['propertyTypes'],
    'status': projectMap['status'],
    'projectArea': projectMap['projectArea'],
    'projectSize': projectMap['projectSize'],
    'launchDate': _dateOnly(projectMap['launchDate']),
    'possessionDate': _dateOnly(projectMap['possessionDate']),
    'configurations': projectMap['configurations'],
    'nearbyLocations': projectMap['nearbyLocations'] ?? [],
    'amenities': projectMap['amenities'] ?? [],
    'buildingNames': projectMap['buildingNames'] ?? {},
    'projectHighlights': projectMap['projectHighlights'] ?? [],
    'brochures': brochures,
    'projectContactInfo': projectMap['projectContactInfo'],
    'ownerName': projectMap['ownerName'],
    'ownerPhone': projectMap['ownerPhone'],
    'ownerEmail': projectMap['ownerEmail'],
    'reraId': projectMap['reraId'],
    'mediaGallery': mediaGallery,
  };
}

Future<void> _attachProjectDocuments(
  http.MultipartRequest request,
  List<File> documents,
) async {
  for (final document in documents) {
    if (!_isRemoteGalleryUrl(document.path)) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'project_document',
          document.path,
          contentType: _documentMediaType(document.path),
        ),
      );
    }
  }
}

class BuilderService {
  final String baseUrl = ApiConstants.builderProject; // Adjust endpoint
  final String topProjectUrl = ApiConstants.topProject;

  ///==================== Common Headers ====================
  static Future<Map<String, String>> headersWithoutToken() async {
    return await ApiConstants.getHeadersWithoutToken();
  }

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<PaginationResponse<ProjectItem>> fetchProjects({
    int page = 1,
    Map<String, String>? filters,
    String? limit,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        // Use paged limit by default to avoid decoding very large payloads
        // on the UI isolate, which can cause jank/ANR-like behavior.
        'limit': limit ?? '20',
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
      print("📡 Fetching Projects from: $uri");

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);



        return PaginationResponse<ProjectItem>.fromJson(
          data,
          (json) => ProjectItem.fromJson(json),
        );
      } else {
        print("❌ Failed to load Top projects: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Top projects");
      }
    } catch (e) {
      print("⚠️ Exception in fetchProjects: $e");
      rethrow; // Let controller handle error
    }
  }

  Future<PaginationResponse<ProjectItem>> fetchTopProject({
    int page = 1,
    Map<String, String>? filters,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        
          'limit': '10',
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(topProjectUrl).replace(queryParameters: queryParameters);
      print("📡 Fetching Projects from: $uri");

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Project API Response: $data");

        return PaginationResponse<ProjectItem>.fromJson(
          data,
          (json) => ProjectItem.fromJson(json),
        );
      } else {
        print("❌ Failed to load projects: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load projects");
      }
    } catch (e) {
      print("⚠️ Exception in fetchProjects: $e");
      rethrow; // Let controller handle error
    }
  }

  Future<ProjectItem> getProjectById(String projectId) async {
    try {
      final uri = Uri.parse("$baseUrl/$projectId");
      print("📡 Fetching Projects from: $uri");

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Project API Response: $data");
        // AppLogger.structured("Project Api Calling from api",  data);
        return ProjectItem.fromJson(data['data']);
      } else {
        print("❌ Failed to load projects: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load projects");
      }
    } catch (e) {
      print("⚠️ Exception in fetchProjects: $e");
      rethrow; // Let controller handle error
    }
  }

  ///==================== Create Project under a Builder ====================
  Future<bool> createProject({
    required AddProjectModel projectData,
    List<File>? images,
    List<File>? videos,
    File? brochures,
    List<File>? documents,
  }) async {
    try {
      final uri = Uri.parse(baseUrl);
      debugPrint("📤 Creating project at: $uri");
      print("Project Data: ${projectData.toJson()}");

      final headerMap = await headers();

      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        ...headerMap,
        'Content-Type': 'multipart/form-data',
      });

      // Convert model to Map
      final projectMap = projectData.toJson();
      _normalizeMediaGalleryInProjectMap(projectMap);

      if (brochures != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'brochure',
            brochures.path,
            contentType: MediaType('application', 'pdf'),
          ),
        );
      }

      if (documents != null && documents.isNotEmpty) {
        await _attachProjectDocuments(request, documents);
      }

      // ====== Add all other fields ======
      /*projectMap.forEach((key, value) {
        if (value == null) return;

        if (key == 'brochure') return;
        if (key == 'documentList') return;

        if (value is Map || value is List) {
          request.fields[key] = jsonEncode(value);
        } else {
          request.fields[key] = value.toString();
        }
      });*/
      // ====== Add all other fields ======
      projectMap.forEach((key, value) {
        if (value == null) return;
        if (key == 'brochure' || key == 'documentList') return;

        // Special handling for nested maps/lists
        if (key == 'buildingNames' && value is Map) {
          // 🔹 Flatten buildingNames
          value.forEach((innerKey, innerValue) {
            request.fields['buildingNames[$innerKey]'] = innerValue.toString();
          });
        } else if (value is Map || value is List) {
          // 🔹 Encode other complex fields like projectSize/configurations
          request.fields[key] = jsonEncode(value);
        } else {
          // 🔹 Normal flat field
          request.fields[key] = value.toString();
        }
      });

      // ==== Attach Project Images ====
      if (images != null && images.isNotEmpty) {
        for (var image in images) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'project_images',
              image.path,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        }
      }
      //
      // ==== Attach Project Videos ====
      if (videos != null && videos.isNotEmpty) {
        for (var video in videos) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'project_videos',
              video.path,
              contentType: MediaType('video', 'mp4'),
            ),
          );
        }
      }
      debugPrint("🧾 Multipart fields: ${request.fields}");
      debugPrint("📎 Attached files: ${request.files.length}");

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("📩 Create Project Response: ${response.statusCode}");
      debugPrint("📄 Response Body: ${_truncate(response.body)}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        /*      CustomSnackBar.show(
          Get.overlayContext!,
          message: "Project created successfully",
          type: SnackBarType.success,
        );*/
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: data['message'] ?? 'Project Created Successfully',
          contentType: ContentType.success,
        );
        return true;
      }
      final data = jsonDecode(response.body);
      debugPrint("❌ Create project exception: ${data['message']}");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Failergrejhghrd',

        message: data['message'] ?? 'Project Created fail',
        contentType: ContentType.failure,
      );
      return false;
    } catch (e) {
      debugPrint("❌ Create project exception: $e");
      /*  CustomSnackBar.show(
        Get.overlayContext!,
        message: "Error while creating project",
        type: SnackBarType.error,
      );*/
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Failed',
        message: 'Project Created fail',
        contentType: ContentType.failure,
      );
      return false;
    }
  }

  /*Future<bool> updateProject({
    required String projectId,
    required AddProjectModel projectData,
    List<File>? images,
    List<File>? videos,
    File? documents,
  }) async {
    try {
      AppLogger("🧾 Multipart fields1:", {
        "projectName": projectData.projectName,
        "amenitiesCount": projectData.amenities.length,
        "configCount": projectData.configurations.length,
      });
      final uri = Uri.parse('$baseUrl/$projectId'); // include project ID
      debugPrint("📤 Updating project at: $uri");

      final headerMap = await headers();

      var request = http.MultipartRequest('PUT', uri);
      request.headers.addAll({
        ...headerMap,
        'Content-Type': 'multipart/form-data',
      });

      // Convert model to Map
      final projectMap = projectData.toJson();
      debugPrint("Project Map keys: ${projectMap.keys.toList()}");
      debugPrint("Documents present: ${documents != null}");
      debugPrint("Images count: ${images?.length ?? 0}");
      debugPrint("Videos count: ${videos?.length ?? 0}");

      // ===== Attach brochure if local =====
      if (documents != null) {
        final isNetwork = Uri.tryParse(documents.path)?.isAbsolute ?? false;
        if (!isNetwork) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'brochure',
              documents.path,
              contentType: MediaType('application', 'pdf'),
            ),
          );
        }
      }

      // ===== Attach other fields =====
      projectMap.forEach((key, value) {
        if (value == null) return;
        if (key == 'brochure') return; // already handled
        if (value is Map || value is List) {
          request.fields[key] = jsonEncode(value);
        } else {
          request.fields[key] = value.toString();
        }
      });

      // ===== Attach images if local =====
      if (images != null && images.isNotEmpty) {
        for (var image in images) {
          final isNetwork = Uri.tryParse(image.path)?.isAbsolute ?? false;
          if (!isNetwork) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'project_images',
                image.path,
                contentType: MediaType('image', 'jpeg'),
              ),
            );
          }
        }
      }

      // ===== Attach videos if local =====
      if (videos != null && videos.isNotEmpty) {
        for (var video in videos) {
          final isNetwork = Uri.tryParse(video.path)?.isAbsolute ?? false;
          if (!isNetwork) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'project_videos',
                video.path,
                contentType: MediaType('video', 'mp4'),
              ),
            );
          }
        }
      }

      AppLogger("🧾 Multipart fields:", request.fields);
      debugPrint("📎 Attached files: ${request.files.length}");

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("📩 Update Project Response: ${response.statusCode}");
      debugPrint("📄 Response Body: ${_truncate(response.body)}");

      if (response.statusCode == 200) {
        */ /*CustomSnackBar.show(
          Get.overlayContext!,
          message: "Project updated successfully",
          type: SnackBarType.success,
        );*/ /*
        final data = jsonDecode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: data['message'] ?? 'Project update successfully',
          contentType: ContentType.success,
        );
        return true;
      }

      */ /*  CustomSnackBar.show(
        Get.overlayContext!,
        message: "Failed to update project",
        type: SnackBarType.error,
      );*/ /*
      final data = jsonDecode(response.body);
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Failed',
        message: data['message'] ?? 'Failed to update project',
        contentType: ContentType.failure,
      );
      return false;
    } catch (e) {
      debugPrint("❌ Update project exception: $e");
      */ /* CustomSnackBar.show(
        Get.overlayContext!,
        message: "Error while updating project",
        type: SnackBarType.error,
      );*/ /*
      // NesticoPeSnackBar.showAwesomeSnackbar(
      //   title: 'Failed',
      //   message: "Error while updating project",
      //   contentType: ContentType.failure,
      // );
      return false;
    }
  }*/
  Future<bool> updateProject({
    required String projectId,
    required AddProjectModel projectData,
    List<File>? images,
    List<File>? videos,
    List<File>? documents,
    File? brochures,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/$projectId');
      debugPrint("📤 Updating project at: $uri");

      final retainImageUrls = _retainUrlsFromFiles(images);
      final retainVideoUrls = _retainUrlsFromFiles(videos);
      final retainDocumentUrls = _retainUrlsFromFiles(documents);

      final hasLocalImage =
          (images ?? []).any((f) => !_isRemoteGalleryUrl(f.path));
      final hasLocalVideo =
          (videos ?? []).any((f) => !_isRemoteGalleryUrl(f.path));
      final hasLocalDocument =
          (documents ?? []).any((f) => !_isRemoteGalleryUrl(f.path));
      final hasLocalBrochure =
          brochures != null && !_isRemoteGalleryUrl(brochures.path);
      final hasLocalMediaUpload =
          hasLocalImage || hasLocalVideo || hasLocalDocument || hasLocalBrochure;

      final projectMap = projectData.toJson();
      final dataPayload = _buildUpdateDataPayload(
        projectMap,
        retainImageUrls: retainImageUrls,
        retainVideoUrls: retainVideoUrls,
        retainDocumentUrls: retainDocumentUrls,
      );

      http.Response response;

      // No new local files → JSON PUT (same idea as property_service).
      if (!hasLocalMediaUpload) {
        final headerMap = await headers();
        headerMap['Content-Type'] = 'application/json';
        response = await http.put(
          uri,
          headers: headerMap,
          body: jsonEncode(dataPayload),
        );
        log(
          '🧾 Update JSON: images=${retainImageUrls.length}, '
          'videos=${retainVideoUrls.length}, '
          'documents=${retainDocumentUrls.length}',
        );
      } else {
        final headerMap = await headers();
        var request = http.MultipartRequest('PUT', uri);
        request.headers.addAll({
          ...headerMap,
          'Content-Type': 'multipart/form-data',
        });

        // Existing remote URLs in JSON `data`; new picks as multipart parts.
        request.fields['data'] = jsonEncode(dataPayload);

        if (hasLocalBrochure) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'brochure',
              brochures!.path,
              contentType: MediaType('application', 'pdf'),
            ),
          );
        }

        if (images != null) {
          for (final image in images) {
            if (_isRemoteGalleryUrl(image.path)) continue;
            request.files.add(
              await http.MultipartFile.fromPath(
                'project_images',
                image.path,
                contentType: MediaType('image', 'jpeg'),
              ),
            );
          }
        }

        if (videos != null) {
          for (final video in videos) {
            if (_isRemoteGalleryUrl(video.path)) continue;
            request.files.add(
              await http.MultipartFile.fromPath(
                'project_videos',
                video.path,
                contentType: MediaType('video', 'mp4'),
              ),
            );
          }
        }

        if (documents != null) {
          await _attachProjectDocuments(request, documents);
        }

        log(
          '🧾 Update multipart: retain images=${retainImageUrls.length}, '
          'videos=${retainVideoUrls.length}, '
          'documents=${retainDocumentUrls.length}, '
          'newFiles=${request.files.length}',
        );

        final streamedResponse = await request.send();
        response = await http.Response.fromStream(streamedResponse);
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: data['message'] ?? 'Project updated successfully',
          contentType: ContentType.success,
        );
        return true;
      }

      final data = jsonDecode(response.body);
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Failed',
        message: data['message'] ?? 'Failed to update project',
        contentType: ContentType.failure,
      );
      return false;
    } catch (e) {
      debugPrint("❌ Update project exception: $e");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Failed',
        message: 'Error while updating project',
        contentType: ContentType.failure,
      );
      return false;
    }
  }

  String _truncate(String text, {int maxLength = 600}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...<truncated>';
  }
}
