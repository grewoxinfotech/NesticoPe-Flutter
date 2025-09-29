import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import 'package:http/http.dart' as http;

import '../../../../modules/add_property/model/photo_model.dart';

class PropertyService {
  final String baseUrl = "${ApiConstants.baseURL}/property";

  /// Common headers
  static Future<Map<String, String>> headersWithoutToken() async {
    return await ApiConstants.getHeadersWithoutToken();
  }

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  /// Fetch properties with optional pagination & filters
  // Future<List<Items>> fetchProperties({
  //   int page = 1,
  //   Map<String, String>? filters,
  // }) async {
  //   try {
  //     final queryParameters = {
  //       'page': page.toString(),
  //       if (filters != null) ...filters,
  //     };
  //
  //     final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
  //     final response = await http.get(uri, headers: await headers());
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //
  //       print("data: $data");
  //       // Extract the list of properties
  //       final  itemsJson = data["data"]["items"] ?? [];
  //       print("itemsJson: $itemsJson");
  //
  //       return (itemsJson as List).map((json) => Items.fromJson(json)).toList();
  //     } else {
  //       print("Failed to load properties: ${response.statusCode}");
  //       print("Failed to load properties: ${response.body}");
  //
  //     }
  //   } catch (e) {
  //     print("Exception in fetchProperties: $e");
  //   }
  //
  //   return [];
  // }

  Future<PaginationResponse<Items>> fetchProperties({
    int page = 1,
    Map<String, String>? filters,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("data: $data");

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
  // Future<Items?> getPropertyById(String id) async {
  //   try {
  //     final response = await http.get(
  //       Uri.parse("$baseUrl/$id"),
  //       headers: await headers(),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final jsonData = json.decode(response.body);
  //       return PropertyModel.fromJson(jsonData).data?.items?.first;
  //     }
  //   } catch (e) {
  //     print("Get property by ID exception: $e");
  //   }
  //   return null;
  // }

  /// Create new property
  // Future<bool> createProperty(
  //   Map<String, dynamic> property,
  //   List<PhotoImageModel> image,
  // ) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(baseUrl),
  //       headers: await headers(),
  //       body: jsonEncode(property.toJson()),
  //     );
  //     print("Create property response: ${response.body}");
  //     return response.statusCode == 201 || response.statusCode == 200;
  //   } catch (e) {
  //     print("Create property exception: $e");
  //     return false;
  //   }
  // }

  Future<bool> createProperty(
    Map<String, dynamic> property,
    List<PhotoImageModel> images,
  ) async {
    try {
      final url = Uri.parse(baseUrl);

      debugPrint("Property Json : ${property}");

      // Multipart request
      var request = http.MultipartRequest("POST", url);

      // Add headers (auth, content-type, etc.)
      request.headers.addAll(await headers());

      // 🔑 Add property data (as normal fields, not JSON)
      property.forEach((key, value) {
        if (value != null) {
          if (value is Map || value is List) {
            request.fields[key] = jsonEncode(value); // stringify nested objects
          } else {
            request.fields[key] = value.toString();
          }
        }
      });

      // 🔑 Attach images
      for (int i = 0; i < images.length; i++) {
        final file = File(images[i].path);
        final stream = http.ByteStream(file.openRead());
        final length = await file.length();

        final multipartFile = http.MultipartFile(
          'property_images', // 👈 backend expects this field
          stream,
          length,
          filename: file.path.split("/").last,
        );

        request.files.add(multipartFile);
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Create property response: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Create property exception: $e");
      return false;
    }
  }

  /// Update property
  Future<bool> updateProperty(String id, Items property) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: await headers(),
        body: jsonEncode(property.toJson()),
      );
      return response.statusCode == 200;
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
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Delete property exception: $e");
      return false;
    }
  }
}
