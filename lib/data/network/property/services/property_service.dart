import 'dart:convert';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import 'package:http/http.dart' as http;


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
  Future<bool> createProperty(Items property) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: await headers(),
        body: jsonEncode(property.toJson()),
      );
      return response.statusCode == 201 || response.statusCode == 200;
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