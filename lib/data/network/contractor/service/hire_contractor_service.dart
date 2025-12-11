import 'dart:convert';
import 'dart:developer';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../../../../app/care/pagination/models/pagination_models.dart';
import '../../../../app/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../../../app/widgets/snackbar/snackbar.dart';
import '../../auth/model/user_model.dart';
import '../model/contractor_hire_profile_model.dart';
import '../model/contractot_service_model/contractor_category_model.dart';
import '../model/contractot_service_model/contractor_service_model.dart';
import '../model/hire-contractor_service_model.dart';

class HireContractorService {
  HireContractorService._();

  static HireContractorService contractorMyService = HireContractorService._();

  final _baseCategory = ApiConstants.contractorServiceCategory;
  final _baseUser = ApiConstants.user;
  final _baseUserProfile = ApiConstants.contractorUserProfile;
  final _baseContractorService = ApiConstants.contractorService;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<PaginationResponse<ContractorServiceCategory>> getContractorCategory({
    int page = 1,
    Map<String, String>? filter,
  }) async {
    final query = {'page': page.toString(), if (filter != null) ...filter};

    final uri = Uri.parse('$_baseCategory').replace(queryParameters: query);
    log("Print Url for ${uri}");
    try {
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaginationResponse.fromJson(
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
      print("Exception in Review: $e");
      rethrow;
    }
  }

  Future<PaginationResponse<User>> fetchUserContractorProfile({
    int page = 1,
    Map<String, String>? filter,
  }) async {
    final query = {'page': page.toString(), if (filter != null) ...filter};
    final uri = Uri.parse('$_baseUser').replace(queryParameters: query);
    log("User Data  Url for ${uri}");
    try {
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("User Data jidfjsdjf  Url for ${response.body}");
        return PaginationResponse.fromJson(data, (json) => User.fromJson(json));
      } else {
        print("Failed to load Active: ${response.statusCode}");
        print("User Data  Url for ${response.body}");
        throw Exception("Failed to load Active");
      }
    } catch (e) {
      print("Response body: ${e}");
      print("Exception in Review: $e");
      rethrow;
    }
  }

  Future<HireContractorUserProfileResponse?> fetchUserProfileData(
      Map<String, dynamic> user) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUserProfile),
        headers: await headers(),
        body: jsonEncode(user),
      );

      if (response.statusCode == 200||response.statusCode == 201) {
        final jsonBody = jsonDecode(response.body);

        // Parse response into model
        final profileResponse =
        HireContractorUserProfileResponse.fromMap(jsonBody);

        return profileResponse;
      } else {
        print('❌ Failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e, stack) {
      print('⚠️ Error fetching user profile: $e');
      print(stack);
      return null;
    }
  }
  Future<HireContractorServiceResponse?> fetchHireContractorService(
      String categoryId) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseContractorService/by-category/$categoryId"),
        headers: await headers(),
      );

      if (response.statusCode == 200) {
        final jsonBody = jsonDecode(response.body);

        // Parse response into model
        final profileResponse =
        HireContractorServiceResponse.fromMap(jsonBody);

        return profileResponse;
      } else {
        print('❌ Failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e, stack) {
      print('⚠️ Error fetching user profile: $e');
      print(stack);
      return null;
    }
  }
}
