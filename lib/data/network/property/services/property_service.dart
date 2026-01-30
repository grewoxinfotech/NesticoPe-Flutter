import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/app/widgets/snack_bar/custom_snackbar.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../../../modules/add_property/model/photo_model.dart';
import '../../../../utils/logger/app_logger.dart';
import '../../reseller/reseller_dashboard/model/reseller_dashboard_model.dart';
import '../models/top_property_model.dart';

class PropertyService {
  final String baseUrl = ApiConstants.property;
  final String topPropertyUrl = ApiConstants.topProperties;
  final String recommendedPropertyUrl = ApiConstants.recommmendedPorperties;

  /// Common headers
  static Future<Map<String, String>> headersWithoutToken() async {
    return await ApiConstants.getHeadersWithoutToken();
  }

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<PaginationResponse<Items>> fetchProperties({
    int page = 1,
    Map<String, String>? filters,
    List<String>? fields,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        if (fields != null) ...{'fields': fields.join(',')},
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
      print("Reseller uri: $uri");
      final response = await http.get(uri, headers: await headers());

      print("response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        AppLogger.structured(
          "Fetch Properties from Api and Store in Items",
          data,
        );

        return PaginationResponse<Items>.fromJson(
          data,
          (json) => Items.fromJson(json),
        );
      } else {
        print("Failed to load properties: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load properties");
      }
    } catch (e) {
      print("Exception in fetchProperties: $e");
      rethrow; // Let controller handle error
    }
  }

  Future<PaginationResponse<Items>> fetchTopProperties({
    int page = 1,
    Map<String, String>? filters,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(
        topPropertyUrl,
      ).replace(queryParameters: queryParameters);
      print("top property uri: $uri");
      final response = await http.get(uri, headers: await headers());

      print("response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse<Items>.fromJson(
          data,
          (json) => Items.fromJson(json),
        );
      } else {
        print("Failed to load properties: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load properties");
      }
    } catch (e) {
      print("Exception in fetchProperties: $e");
      rethrow; // Let controller handle error
    }
  }

  /// Get single property by ID
  Future<Items?> getPropertyById(String id) async {
    try {
      print("baseUrl : $baseUrl/$id");
      final response = await http.get(
        Uri.parse("$baseUrl/$id"),
        headers: await headers(),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        return Items.fromJson(jsonData['data']);
      }
    } catch (e) {
      print("Get property by ID exception: $e");
    }
    return null;
  }

  /// Create new property
  Future<bool> createProperty(
    Map<String, dynamic> property,
    List<io.File>? images,
    List<io.File>? videos,
    List<io.File>? documents,
  ) async {
    try {
      final url = Uri.parse(baseUrl);
      print("url: $url");
      debugPrint("Property JSON: ${jsonEncode(property)}");

      var request = http.MultipartRequest("POST", url);

      // Add headers
      request.headers.addAll(await headers());

      property.forEach((key, value) {
        if (value is Map || value is List) {
          request.fields[key] = jsonEncode(
            value,
          ); // nested objects/lists as JSON string
        } else {
          request.fields[key] = value.toString();
        }
      });

      if (images != null && images.isNotEmpty) {
        for (var image in images) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'property_images',
              image.path,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        }
      }

      // ==== Attach Project Videos ====
      if (videos != null && videos.isNotEmpty) {
        for (var video in videos) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'property_videos',
              video.path,
              contentType: MediaType('video', 'mp4'),
            ),
          );
        }
      }

      if (documents != null) {
        for (var document in documents) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'property_documents',
              document.path,
              contentType: MediaType('application', 'pdf'),
            ),
          );
        }
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      AppLogger.structured("Create property response: ", response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Success",
          message: "Create Property Successful",
          contentType: ContentType.success,
        );
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Error",
          message: "Failed to create property. Please try again.",
          contentType: ContentType.failure,
        );
      }

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint("Create property exception: $e");
      return false;
    }
  }

  /// Update property
  Future<bool> updateProperty(
    String id,
    Map<String, dynamic> property,
    List<io.File>? images,
    List<io.File>? videos,
    List<io.File>? documents,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/$id');
      print("url: $url");
      debugPrint("Property JSON: ${jsonEncode(property)}");

      var request = http.MultipartRequest("PUT", url);

      // Add headers
      request.headers.addAll(await headers());

      property.forEach((key, value) {
        if (value is Map || value is List) {
          request.fields[key] = jsonEncode(
            value,
          ); // nested objects/lists as JSON string
        } else {
          request.fields[key] = value.toString();
        }
      });

      // ==== Attach Images ====
      if (images != null && images.isNotEmpty) {
        for (var image in images) {
          if (isNetworkFile(image.path)) {
            print("Skipping network image: ${image.path}");
            continue; // Skip upload
          }

          request.files.add(
            await http.MultipartFile.fromPath(
              'property_images',
              image.path,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        }
      }

      // ==== Attach Videos ====
      if (videos != null && videos.isNotEmpty) {
        for (var video in videos) {
          if (isNetworkFile(video.path)) {
            print("Skipping network video: ${video.path}");
            continue; // Skip upload
          }

          request.files.add(
            await http.MultipartFile.fromPath(
              'property_videos',
              video.path,
              contentType: MediaType('video', 'mp4'),
            ),
          );
        }
      }

      // ==== Attach Documents ====
      if (documents != null && documents.isNotEmpty) {
        for (var document in documents) {
          if (isNetworkFile(document.path)) {
            print("Skipping network document: ${document.path}");
            continue; // Skip upload
          }

          request.files.add(
            await http.MultipartFile.fromPath(
              'property_documents',
              document.path,
              contentType: MediaType('application', 'pdf'),
            ),
          );
        }
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("Update property response: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Success",
          message: "Update Property Successful",
          contentType: ContentType.success,
        );
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Error",
          message: "Failed to Update property. Please try again.",
          contentType: ContentType.success,
        );
      }

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Update property exception: $e");
      return false;
    }
  }

  /// Delete property
  Future<bool> deleteProperty(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/$id"),
        headers: await headers(),
      );
      print("Delete property response: ${response.body}");
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Delete property exception: $e");
      return false;
    }
  }

  Future<bool> addInquiry(Map<String, dynamic> data, String id) async {
    try {
      print("data : ${data}");
      print("baseUrl : $baseUrl/$id/inquiry");
      final response = await http.post(
        Uri.parse("$baseUrl/$id/inquiry"),
        headers: await ApiConstants.getHeadersWithoutToken(),
        body: jsonEncode(data),
      );
      print("response : ${response.body}");
      print("Status code : ${response.statusCode}");
      return (response.statusCode == 200 || response.statusCode == 201);
    } catch (e) {
      print("Delete property exception: $e");
      return false;
    }
  }

  Future<bool> addView(String id) async {
    try {
      print("baseUrl : ${baseUrl}/${id}");
      final response = await http.post(
        Uri.parse("$baseUrl/$id/view"),
        headers: await headers(),
      );
      print("response : ${response.body}");
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Delete property exception: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getRecommendedPropertyById(
    String id,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("$recommendedPropertyUrl/$id"),
        headers: await headers(),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['data'] != null &&
            jsonData['data']['properties'] != null) {
          return List<Map<String, dynamic>>.from(
            jsonData['data']['properties'],
          );
        }
      }
    } catch (e) {
      print("Get property by ID exception: $e");
    }
    return [];
  }

  //
  // Future<Map<String,dynamic>> getRecommendedPropertyById(String id) async {
  //   try {
  //     print("baseUrl : $baseUrl/$id");
  //     final response = await http.get(
  //       Uri.parse("$recommendedPropertyUrl/$id"),
  //       headers: await headers(),
  //     );
  //
  //     print("Response of Recommended properties: ${response.body}");
  //
  //     if (response.statusCode == 200) {
  //       final jsonData = json.decode(response.body);
  //       print("hubdshbds Response of Recommended properties ${jsonData['data']}");
  //       return jsonData['data'];
  //     }
  //   } catch (e) {
  //     print("Get property by ID exception: $e");
  //   }
  //   return {};
  // }
  bool isNetworkFile(String path) {
    return path.startsWith("http://") || path.startsWith("https://");
  }
}
