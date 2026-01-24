import 'dart:convert';
import 'dart:developer';

import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/confige/helper/api_helper.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../../../../widgets/messages/snack_bar.dart';
import '../../model/employee/contractor_employee_model.dart';

class ContractorEmployeeServices {
  ContractorEmployeeServices._();

  static final ContractorEmployeeServices _instance =
      ContractorEmployeeServices._();

  static ContractorEmployeeServices get instance => _instance;
  final String baseUrl = ApiConstants.contractorEmployees;

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }

  Future<PaginationResponse<ContractorEmployeeItem>> fetchContractorEmployees({
    int page = 1,
    Map<String, String>? filter,
    required String createdBy,
  }) async {
    final query = {
      'page': page.toString(),
      if (filter != null) ...filter,
      'created_by': createdBy,
    };
    final headers = await header();
    try {
      final response = await http.get(
        Uri.parse(baseUrl).replace(queryParameters: query),
        headers: headers,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Contractor Employee Response: ${response.body}");
        final data = jsonDecode(response.body);
        return PaginationResponse<ContractorEmployeeItem>.fromJson(
          data,
          (json) => ContractorEmployeeItem.fromJson(json),
        );
      } else {
        print("Failed to load contractor employees: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load contractor employees");
      }
    } catch (e) {
      print("Error fetching contractor employees: $e");
      rethrow;
    }
    // Handle the response as needed
  }

  Future<bool> addContractorEmployee(Map<String,dynamic> employeeData) async {
    final headers = await header();
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(employeeData),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Add Contractor Employee Response: ${response.body}");
        final data = jsonDecode(response.body);

        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: data['message'],
          contentType: ContentType.success,
        );
        return data['success'];
      } else {
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message']??"Failed to add contractor employee",
          contentType: ContentType.failure,
        );
        print("Failed to add contractor employee: ${response.statusCode}");
        print("Response body: ${response.body}");
       return false;
      }
    } catch (e) {
      print("Error adding contractor employee: $e");
      return false;
    }


  }
  Future<bool> deleteContractorEmployee(String id) async {

    final headers = await header();
    try {
      final response = await http.delete(
        Uri.parse('${baseUrl}/$id'),
        headers: headers,
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Delete Contractor Employee Response: ${response.body}");
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
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message']??"Failed to deleted contractor",
          contentType: ContentType.failure,
        );
        print("Failed to delete contractor employee: ${response.statusCode}");
        print("Response body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error delete contractor employee: $e");
      return false;
    }
  }
  Future<bool> updateContractorEmployee(Map<String,dynamic> updateEmployeeData ,String id) async {

    final headers = await header();
    try {
      final response = await http.put(
        Uri.parse('${baseUrl}/$id'),
        headers: headers,
        body: jsonEncode(updateEmployeeData),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        log("Update Contractor Employee Response: ${response.body}");
        final data = jsonDecode(response.body);
        // final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: data['message'],
          contentType: ContentType.success,
        );
        // Handle the response data as needed
        return data['success'];
      } else {
        final data = jsonDecode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: data['message']??"Failed to update contractor employee",
          contentType: ContentType.failure,
        );
        print("Failed to update contractor employee: ${response.statusCode}");
        print("Response body: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error update contractor employee: $e");
      return false;
    }
  }
}
