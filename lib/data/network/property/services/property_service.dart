import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/app/widgets/snack_bar/custom_snackbar.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

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
      print("uri: $uri");
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
  Future<Items?> getPropertyById(String id) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/$id"),
        headers: await headers(),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return PropertyModel.fromJson(jsonData).data?.items?.first;
      }
    } catch (e) {
      print("Get property by ID exception: $e");
    }
    return null;
  }

  /// Create new property
  Future<bool> createProperty(
    Map<String, dynamic> property,
    List<PhotoImageModel> images,
  ) async {
    try {
      final url = Uri.parse(baseUrl);
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

      // Assuming `images` is List<PhotoImageModel>
      for (var image in images) {
        final file = File(image.path);
        if (await file.exists()) {
          // Detect MIME type dynamically
          final mimeType =
              lookupMimeType(file.path)?.split('/') ?? ['image', 'jpeg'];

          request.files.add(
            await http.MultipartFile.fromPath(
              'property_images', // backend field for images
              file.path,
              filename: file.path.split('/').last,
              contentType: MediaType(mimeType[0], mimeType[1]),
            ),
          );
        }
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("Create property response: ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomSnackBar.show(
          Get.overlayContext!,
          message: "Create Property Successful",
          type: SnackBarType.success,
        );
      } else {
        CustomSnackBar.show(
          Get.overlayContext!,
          message: "Failed to create property. Please try again.",
          type: SnackBarType.error,
        );
      }

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint("Create property exception: $e");
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

  Future<bool> addInquiry(Map<String, dynamic> data, String id) async {
    try {
      print("data : ${data}");
      print("baseUrl : ${baseUrl}/${id}");
      final response = await http.post(
        Uri.parse("$baseUrl/$id/inquiry"),
        headers: await headers(),
        body: jsonEncode(data),
      );
      print("response : ${response.body}");
      return response.statusCode == 200 || response.statusCode == 201;
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

  Future<bool> addFavorite(String id) async {
    try {
      print("baseUrl : ${baseUrl}/${id}");
      final response = await http.post(
        Uri.parse("$baseUrl/$id/favorite"),
        headers: await headers(),
      );
      print("response : --------------------  ${response.body}");
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Delete property exception: $e");
      return false;
    }
  }

  Future<List<String>?> getFavorite(String id) async {
    try {
      print("baseUrl : $baseUrl/$id");
      final response = await http.get(
        Uri.parse("$baseUrl/$id/favorite"),
        headers: await headers(),
      );
      print("response : --------------------  ${response.body}");
      print("response : --------------------  ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final favList = data['data']['favorite'] as List<dynamic>;
        final List<String> favorites =
            favList.map<String>((e) => e['propertyId'].toString()).toList();

        return favorites;
      }
      return null;
    } catch (e) {
      print("Get Favorite exception: $e");
      return null;
    }
  }
}
