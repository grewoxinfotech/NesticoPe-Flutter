import 'dart:convert';
import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../../../../app/care/pagination/models/pagination_models.dart';
import '../../../../app/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../../../app/widgets/snackbar/snackbar.dart';
import '../../../../modules/contractor/view/project/contractor_service.dart';
import '../../auth/model/user_model.dart';
import '../model/contractor_compare_model/contractor_compare_model.dart';
import '../model/contractor_hire_profile_model.dart';
import '../model/contractot_service_model/contractor_category_model.dart';
import '../model/contractot_service_model/contractor_service_model.dart';
import '../model/hire-contractor_service_model.dart';
import '../model/new_hire_contractor.dart';

class HireContractorService {
  HireContractorService._();

  static HireContractorService contractorMyService = HireContractorService._();

  final _baseCategory = ApiConstants.contractorServiceCategory;

  final _baseUser = ApiConstants.user;
  final _baseUserProfile = ApiConstants.contractorUserProfile;
  final _baseUserProfileData = ApiConstants.getUserProfile;
  final _baseContractorService = ApiConstants.contractorService;
  final _baseContractorCity = ApiConstants.contractorServicesCity;

  final _baseUrlForByCategory = ApiConstants.contractorServiceByCategory;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<PaginationResponse<OverAllContractorItem>>
  fetchAllContractorByCategory({int? page, int? limit}) async {
    try {
      final queryParameters = {
        if (page != null) 'page': page.toString(),
        if (limit != null) 'limit': limit.toString(),
      };

      final uri = Uri.parse(
        _baseUrlForByCategory,
      ).replace(queryParameters: queryParameters);

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = Map<String, dynamic>.from(
          jsonDecode(response.body),
        );

        final data = Map<String, dynamic>.from(responseData['data'] ?? {});
        final contractorsList = (data['contractors'] as List<dynamic>? ?? []);

        return PaginationResponse<OverAllContractorItem>(
          items:
              contractorsList
                  .map(
                    (e) => OverAllContractorItem.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList(),
          meta: PaginationMeta.fromJson({}),
        );
      } else {
        throw Exception("Failed to load contractors (${response.statusCode})");
      }
    } catch (e, stack) {
      rethrow;
    }
  }

  Future<PaginationResponse<OverAllContractorItem>>
  fetchHireContractorByCategory({
    int? page,
    int? limit,
    required String id,
    Map<String, String>? filter,
  }) async {
    try {
      final queryParameters = {
        if (page != null) 'page': page.toString(),
        if (limit != null) 'limit': limit.toString(),
        if (filter != null) ...filter,
      };

      final uri = Uri.parse(
        '$_baseUrlForByCategory/$id',
      ).replace(queryParameters: queryParameters);

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = Map<String, dynamic>.from(
          jsonDecode(response.body),
        );

        final data = Map<String, dynamic>.from(responseData['data'] ?? {});
        final contractorsList = (data['contractors'] as List<dynamic>? ?? []);

        return PaginationResponse<OverAllContractorItem>(
          items:
              contractorsList
                  .map(
                    (e) => OverAllContractorItem.fromJson(
                      Map<String, dynamic>.from(e),
                    ),
                  )
                  .toList(),
          meta: PaginationMeta.fromJson({}),
        );
      } else {
        throw Exception("Failed to load contractors (${response.statusCode})");
      }
    } catch (e, stack) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchContractorCity() async {
    try {
      final response = await http.get(
        Uri.parse("$_baseContractorCity"),
        headers: await headers(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data;
      }
      return {};
    } catch (e) {
      rethrow;
    }
  }

  // 1️⃣ Fetch User by ID
  Future<User?> fetchUserById(String userId) async {
    final uri = Uri.parse("$_baseUser/$userId");

    try {
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        return User.fromJson(jsonBody['data']);
      } else {
        return null;
      }
    } catch (e, stack) {
      return null;
    }
  }

  // 2️⃣ Fetch Contractor Profile by ID
  Future<HireContractorUserProfile?> fetchContractorProfileById(
    String contractorId,
  ) async {
    final uri = Uri.parse("$_baseUserProfileData/$contractorId");

    try {
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        return HireContractorUserProfile.fromMap(jsonBody['data']);
      } else {
        return null;
      }
    } catch (e, stack) {
      return null;
    }
  }

  Future<PaginationResponse<ContractorServiceCategory>> getContractorCategory({
    int page = 1,
    Map<String, String>? filter,
  }) async {
    final query = {'page': page.toString(), if (filter != null) ...filter};

    final uri = Uri.parse('$_baseCategory').replace(queryParameters: query);

    try {
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse.fromJson(
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

  Future<PaginationResponse<User>> fetchUserContractorProfile({
    int page = 1,
    Map<String, String>? filter,
  }) async {
    final query = {'page': page.toString(), if (filter != null) ...filter};
    final uri = Uri.parse('$_baseUser').replace(queryParameters: query);

    try {
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse.fromJson(data, (json) => User.fromJson(json));
      } else {
        throw Exception("Failed to load Active");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<HireContractorUserProfileResponse?> fetchUserProfileData(
    Map<String, dynamic> user,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUserProfile),
        headers: await headers(),
        body: jsonEncode(user),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonBody = jsonDecode(response.body);

        // Parse response into model
        final profileResponse = HireContractorUserProfileResponse.fromMap(
          jsonBody,
        );

        return profileResponse;
      } else {
        return null;
      }
    } catch (e, stack) {
      return null;
    }
  }

  Future<HireContractorServiceResponse?> fetchHireContractorService({
    required String categoryId,
    required Map<String, String> filter,
  }) async {
    try {
      final uri = Uri.parse(
        "$_baseContractorService/by-category/$categoryId",
      ).replace(queryParameters: filter);

      final requestHeaders = await headers();

      final response = await http.get(uri, headers: requestHeaders);

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        final parsedResponse = HireContractorServiceResponse.fromMap(jsonBody);

        return parsedResponse;
      } else {
        return null;
      }
    } catch (e, stack) {
      return null;
    } finally {}
  }
}
