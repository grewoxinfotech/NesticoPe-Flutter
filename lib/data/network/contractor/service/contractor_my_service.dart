import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:nesticope_app/utils/logger/app_logger.dart';

import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../../../app/care/pagination/models/pagination_models.dart';
import '../../../../app/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../../../app/widgets/snackbar/snackbar.dart';
import '../../../../widgets/messages/snack_bar.dart';
import '../model/contractot_service_model/contractor_category_model.dart';
import '../model/contractot_service_model/contractor_service_model.dart';

class ContractorMyService {
  ContractorMyService._();

  static ContractorMyService contractorMyService = ContractorMyService._();
  final _baseUrl = ApiConstants.contractorService;
  final _baseCategory = ApiConstants.contractorServiceCategory;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<ContractorServiceCategory> getContractorByIDCategory({
    int page = 1,
    int limit = 10,
    required String fields,
  }) async {
    try {
      final uri = Uri.parse('$_baseCategory/$fields');

      print("Category API URI: $uri");

      final response = await http.get(uri, headers: await headers());
      print("Contractor Service Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Category data fetched successfully: $data");
        return ContractorServiceCategory.fromMap(data['data']);
      } else {
        print("Failed to load Categories: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Categories");
      }
    } catch (e) {
      print("Exception in getContractorCategory: $e");
      return ContractorServiceCategory.fromMap({});
    }
  }

  Future<PaginationResponse<ContractorServiceItem>> fetchContractorService({
    int page = 1,
    Map<String, String>? filters,
    required String id,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        if (filters != null) ...filters,
        "contractor_id": id,
      };

      final uri = Uri.parse("$_baseUrl").replace(queryParameters: queryParams);
      print("Contractor Service URI: $uri");

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Contractor Service data: $data");

        return PaginationResponse<ContractorServiceItem>.fromJson(
          data,
          (json) => ContractorServiceItem.fromJson(json),
        );
      } else {
        print("Failed to load Review: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Review");
      }
    } catch (e) {
      print("Exception in Review: $e");
      rethrow;
    }
  }

  Future<void> changeActiveToInActive(String id, bool isActive) async {
    final uri = Uri.parse('$_baseUrl/$id');
    try {
      final response = await http.put(
        uri,
        headers: await headers(),
        body: jsonEncode({"isActive": isActive}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Change the active and Inactive: $data");
      } else {
        print("Failed to load Active: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Active");
      }
    } catch (e) {
      print("Response body: ${e}");
    }
  }

  Future<bool> deletedService(String id) async {
    final uri = Uri.parse('$_baseUrl/$id');
    try {
      final response = await http.delete(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Service deleted Successfully: $data");
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        return data['success'];
      } else {
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
        print("Failed to load deleted: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to deleted");
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      print("Response body: ${e}");
      return false;
    }
  }

  Future<Map<String, dynamic>> getContractorCategory() async {
    final uri = Uri.parse('$_baseCategory');
    try {
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print("Failed to load Active: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Active");
      }
    } catch (e) {
      print("Response body: ${e}");
      return {};
    }
  }

  Future<PaginationResponse<ContractorServiceCategory>>
  getContractorCategoryService(
    {int page = 1,
    String? limit = '10',}

  ) async {
    final uri = Uri.parse('$_baseCategory').replace(
      queryParameters: {
        'page': page.toString(),
        if (limit != null) 'limit': limit,
      },
    );
    try {
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaginationResponse<ContractorServiceCategory>.fromJson(
          data,
          (json) => ContractorServiceCategory.fromMap(json),
        );
      } else {
        print("Failed to load Active: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Active");
      }
    } catch (e) {
      print("Response body: ${e}");
      rethrow;
    }
  }

  Future<bool> createService(
    Map<String, dynamic> data, {
    List<String>? imagePaths,
  }) async {
    final uri = Uri.parse('$_baseUrl');
    try {
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll(await headers());

      // Add other fields
      data.forEach((key, value) {
        if (key == 'meta') {
          request.fields[key] = jsonEncode(value);
        } else {
          request.fields[key] = value.toString();
        }
      });

      // Add images if available
      if (imagePaths != null && imagePaths.isNotEmpty) {
        for (var imagePath in imagePaths) {
          final mimeType = lookupMimeType(imagePath);
          final file = await http.MultipartFile.fromPath(
            'serviceImage',
            imagePath,
            contentType:
                mimeType != null
                    ? MediaType.parse(mimeType)
                    : MediaType('image', 'png'),
          );
          request.files.add(file);
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final resData = jsonDecode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: resData['message'],
          contentType: ContentType.success,
        );
        print("Service created successfully: $resData");
        return resData['success'];
      } else {
        final resData = jsonDecode(response.body);
        print("Failed to create service: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception(resData['message'] ?? "Failed to create service");
      }
    } catch (e) {
      final errorMessage =
          e is Exception
              ? e.toString().replaceFirst('Exception: ', '')
              : 'Something went wrong';

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: errorMessage,
        contentType: ContentType.failure,
      );

      print("Error creating service: $e");
      return false;
    }
  }

  Future<bool> updateContractorService(
    Map<String, dynamic> service,
    String id, {
    List<String>? imagePaths,
  }) async {
    final uri = Uri.parse('$_baseUrl/$id');
    try {
      var request = http.MultipartRequest('PUT', uri);
      request.headers.addAll(await headers());

      // Add other fields
      service.forEach((key, value) {
        if (key == 'meta') {
          request.fields[key] = jsonEncode(value);
        } else if (key == 'serviceImage') {
          // Send remaining existing image URLs
          request.fields[key] = jsonEncode(value);
        } else {
          request.fields[key] = value.toString();
        }
      });

      // Add new images if available
      if (imagePaths != null && imagePaths.isNotEmpty) {
        for (var imagePath in imagePaths) {
          final mimeType = lookupMimeType(imagePath);
          final file = await http.MultipartFile.fromPath(
            'serviceImage',
            imagePath,
            contentType:
                mimeType != null
                    ? MediaType.parse(mimeType)
                    : MediaType('image', 'png'),
          );
          request.files.add(file);
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: resData['message'],
          contentType: ContentType.success,
        );
        AppLogger.structured("Service Updated Successfully: ", resData);
        return resData['success'];
      } else {
        final resData = jsonDecode(response.body);
        print("Failed to update service: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception(resData['message'] ?? "Failed to update service");
      }
    } catch (e) {
      final errorMessage =
          e is Exception
              ? e.toString().replaceFirst('Exception: ', '')
              : 'Something went wrong';

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: errorMessage,
        contentType: ContentType.failure,
      );
      print("Error updating service: $e");
      return false;
    }
  }

  /// Create Inquiry Of Service
  Future<bool> createInquiry(Map<String, dynamic> data) async {
    final uri = Uri.parse('${ApiConstants.contractorInquiry}');
    try {
      final response = await http.post(
        uri,
        headers: await headers(),
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Inquiry Created Successfully: $data");
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        return data['success'];
      } else {
        final data = jsonDecode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Error",
          message: data['message'] ?? 'Something went wrong',
          contentType: ContentType.failure,
        );
        print("Failed to create Inquiry: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to create Inquiry");
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      print("Response body for create Inquiry: ${e}");
      return false;
    }
  }
}
