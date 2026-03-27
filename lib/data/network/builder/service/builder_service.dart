import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/data/network/builder/model/builder_model.dart';
import 'package:nesticope_app/utils/logger/app_logger.dart';
import 'package:http/http.dart' as http;

import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/app/widgets/snack_bar/custom_snackbar.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../widgets/messages/snack_bar.dart';

// import '../model/builder_projectModel.dart';

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
        'limit': limit ?? 'all',
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
      print("📡 Fetching Projects fromsdlkjfdsk: $uri");

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
        AppLogger.structured("Project Api Calling from api",  data);
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

      if (brochures != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'brochure',
            brochures.path,
            contentType: MediaType('application', 'pdf'),
          ),
        );
      }

      if (documents != null) {
        for (var document in documents) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'project_document',
              document.path,
              contentType: MediaType('application', 'pdf'),
            ),
          );
        }
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
      debugPrint("📄 Response Body: ${response.body}");

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
      AppLogger("🧾 Multipart fields1:", projectData.toJson());
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
      debugPrint("Project Map: $projectMap");
      debugPrint("Documents: $documents");
      debugPrint("Images: $images");
      debugPrint("Videos: $videos");

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
      debugPrint("📄 Response Body: ${response.body}");

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
    File? documents,
  }) async {
    try {
      AppLogger("🧾 Multipart fields1:", projectData.toJson());
      final uri = Uri.parse('$baseUrl/$projectId');
      debugPrint("📤 Updating project at: $uri");

      final headerMap = await headers();

      var request = http.MultipartRequest('PUT', uri);
      request.headers.addAll({
        ...headerMap,
        'Content-Type': 'multipart/form-data',
      });

      // Convert model to Map
      final projectMap = projectData.toJson();
      debugPrint("Project Map: $projectMap");
      debugPrint("Documents: $documents");
      debugPrint("Images: $images");
      debugPrint("Videos: $videos");

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

        // 🧩 Special handling for buildingNames
        if (key == 'buildingNames' && value is Map) {
          value.forEach((innerKey, innerValue) {
            request.fields['buildingNames[$innerKey]'] = innerValue.toString();
          });
        }
        // Encode other nested structures normally
        else if (value is Map || value is List) {
          request.fields[key] = jsonEncode(value);
        }
        // Simple field
        else {
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

      // 🧾 Debug logs
      log("🧩 Flattened buildingNames fields:");
      request.fields.forEach((key, value) {
        if (key.startsWith('buildingNames')) log("  $key = $value");
      });
      debugPrint("📎 Attached files: ${request.files.length}");

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("📩 Update Project Response: ${response.statusCode}");
      debugPrint("📄 Response Body: ${response.body}");

      if (response.statusCode == 200) {
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
}
