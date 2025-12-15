import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:http/http.dart' as http;

import '../../../../app/care/pagination/models/pagination_models.dart';
import '../../../../app/constants/api_constants.dart';
import '../../../../app/widgets/snackbar/snackbar.dart';
import '../../../../widgets/messages/snack_bar.dart';
import '../model/calender_category_model.dart';

class CalenderCategoryService {
  final String calendarCategory = ApiConstants.calendarCategory;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<PaginationResponse<CalenderCategoryModel>> fetchEventsCategory({
    int page = 1,
    Map<String, String>? filters,
  }) async {
    try {
      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id;

      final queryParameters = <String, List<String>>{
        'page': [page.toString()],
        'created_by': [], // multiple values
        if (userId != null)
          'created_by': [userId, 'SYSTEM']
        else
          'created_by': ['SYSTEM'],
        if (filters != null)
          for (var entry in filters.entries) entry.key: [entry.value],
      };

      final uri = Uri.parse(
        calendarCategory,
      ).replace(queryParameters: queryParameters);

      print("uri: $uri");

      final response = await http.get(uri, headers: await headers());
      print("response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse<CalenderCategoryModel>.fromJson(
          data,
          (json) => CalenderCategoryModel.fromJson(json),
        );
      } else {
        throw Exception("Failed to load Category");
      }
    } catch (e) {
      print("Exception in load Events: $e");
      rethrow;
    }
  }

  Future<CalenderCategoryModel?> getCategoryById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$calendarCategory/$id'),
        headers: await headers(),
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return CalenderCategoryModel.fromJson(jsonData['data']);
      }
      return null;
    } catch (e) {
      print("Exception in load Events: $e");
      rethrow;
    }
  }

  /// Add Event to the calender
  Future<CalenderCategoryModel?> addEventCategory(String category) async {
    try {
      final response = await http.post(
        Uri.parse(calendarCategory),
        headers: await headers(),
        body: jsonEncode({"name": category}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return CalenderCategoryModel.fromJson(jsonData['data']);
      }
      return null;
    } catch (e) {
      print("Exception in load Events: $e");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
    }
    return null;
  }

  /// Update Calender Event
  Future<CalenderCategoryModel?> updateEvent(
    CalenderCategoryModel category,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$calendarCategory/${category.id}'),
        headers: await headers(),
        body: jsonEncode(category.toJson()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return CalenderCategoryModel.fromJson(jsonData['data']);
      }
      return null;
    } catch (e) {
      print("Exception in load Events: $e");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
    }
    return null;
  }

  /// Delete Calender Event
  Future<bool> deleteEventCategory(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("$calendarCategory/$id"),
        headers: await headers(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print("Exception in load Events: $e");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      return false;
    }
  }
}
