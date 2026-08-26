import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:nesticope_app/data/network/contractor/service/subscription/subscription_limit_guard.dart';
import 'package:nesticope_app/utils/logger/app_logger.dart';

import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../../../app/care/pagination/models/pagination_models.dart';
import '../../../../app/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

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

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return ContractorServiceCategory.fromMap(data['data']);
      } else {
        throw Exception("Failed to load Categories");
      }
    } catch (e) {
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

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final items = (data['data']?['items'] as List?)?.length ?? 0;
        final currentPage = data['data']?['currentPage'];
        final totalPages = data['data']?['totalPages'];

        return PaginationResponse<ContractorServiceItem>.fromJson(
          data,
          (json) => ContractorServiceItem.fromJson(json),
        );
      } else {
        throw Exception("Failed to load Review");
      }
    } catch (e) {
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
        jsonDecode(response.body);
        // print("Change the active and Inactive: $data");
      } else {
        // print("Failed to load Active: ${response.statusCode}");
        // print("Response body: ${response.body}");
        throw Exception("Failed to load Active");
      }
    } catch (e) {}
  }

  Future<bool> deletedService(String id) async {
    final uri = Uri.parse('$_baseUrl/$id');
    try {
      final response = await http.delete(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

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

        throw Exception("Failed to deleted");
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );

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
        throw Exception("Failed to load Active");
      }
    } catch (e) {
      return {};
    }
  }

  Future<PaginationResponse<ContractorServiceCategory>>
  getContractorCategoryService({int page = 1, String? limit = '10'}) async {
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
        throw Exception("Failed to load Active");
      }
    } catch (e) {
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

      final hasNewImages = imagePaths != null && imagePaths.isNotEmpty;

      // Add other fields
      data.forEach((key, value) {
        if (key == 'serviceImage') {
          // If user picked no images, send an empty array so the backend
          // validation ("must be an array") passes.
          // If user picked images, rely on multipart files instead.
          if (value == null) {
            if (!hasNewImages) {
              request.fields[key] = jsonEncode(<dynamic>[]);
            }
          } else if (value is List) {
            request.fields[key] = jsonEncode(value);
          }
          return;
        }

        if (value == null) return;

        // Meta is a nested object; send as JSON string.
        if (key == 'meta') {
          request.fields[key] = jsonEncode(value);
          return;
        }

        request.fields[key] = value.toString();
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

        return resData['success'];
      } else {
        final handled = await SubscriptionLimitGuard.handlePlanLimitResponse(
          response,
        );
        if (handled) return false;
        final resData = jsonDecode(response.body);

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
        if (value == null) {
          // The backend expects `serviceImage` to be an array.
          if (key == 'serviceImage') {
            request.fields[key] = jsonEncode([]);
          }
          return;
        }

        if (key == 'meta') {
          request.fields[key] = jsonEncode(value);
          return;
        }

        if (key == 'serviceImage') {
          // Send remaining existing image URLs as an array.
          request.fields[key] = jsonEncode(value);
          return;
        }

        request.fields[key] = value.toString();
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

        return resData['success'];
      } else {
        final handled = await SubscriptionLimitGuard.handlePlanLimitResponse(
          response,
        );
        if (handled) return false;
        final resData = jsonDecode(response.body);

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

        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        return data['success'];
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage =
            (errorData['error']?['message'] ?? errorData['message'] ?? '')
                .toString()
                .trim();
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Error",
          message:
              errorMessage.isEmpty ? 'Failed to create inquiry' : errorMessage,
          contentType: ContentType.failure,
        );

        return false;
      }
    } catch (e) {
      final fallbackMessage = e.toString().trim();
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message:
            fallbackMessage.isEmpty
                ? 'Something went wrong while creating inquiry'
                : fallbackMessage,
        contentType: ContentType.failure,
      );

      return false;
    }
  }
}
