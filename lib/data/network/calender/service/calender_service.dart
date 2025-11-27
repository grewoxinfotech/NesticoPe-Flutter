import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:housing_flutter_app/app/widgets/snackbar/snackbar.dart';
import 'package:http/http.dart' as http;

import '../../../../app/care/pagination/models/pagination_models.dart';
import '../../../../app/constants/api_constants.dart';
import '../../../database/secure_storage_service.dart';
import '../model/calender_model.dart';

class CalenderService {
  final String baseUrl = ApiConstants.calendar;

  /// GET HEADERS
  static Future<Map<String, String>> headers() async {
    final h = await ApiConstants.getHeaders();
    return {...h, "Content-Type": "application/json"};
  }

  /// FETCH EVENTS (LIST + PAGINATION)
  Future<PaginationResponse<CalenderEventModel>> fetchEvents({
    int page = 1,
    Map<String, String>? filters,
  }) async {
    try {
      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id;

      final queryParameters = {
        'page': page.toString(),
        if (userId != null) 'created_by': userId,
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);

      print("uri: $uri");

      final response = await http.get(uri, headers: await headers());

      print("response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        /// Important: Pagination model expects "data"
        if (data is Map<String, dynamic>) {
          return PaginationResponse<CalenderEventModel>.fromJson(
            data,
            (json) => CalenderEventModel.fromJson(json),
          );
        }
      }

      throw Exception("Failed to load events");
    } catch (e) {
      print("Exception in load Events: $e");
      rethrow;
    }
  }

  /// ADD EVENT
  Future<CalenderEventModel?> addEvent(CalenderEventModel event) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: await headers(),
        body: jsonEncode(event.toJson()),
      );

      print("ADD RESPONSE: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);

        return CalenderEventModel.fromJson(jsonData['data']);
      }
    } catch (e) {
      print("Exception in add Event: $e");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
    }
    return null;
  }

  /// UPDATE EVENT
  Future<CalenderEventModel?> updateEvent(CalenderEventModel event) async {
    try {
      if (event.id == null) {
        throw Exception("Event ID is missing for update");
      }

      final response = await http.put(
        Uri.parse('$baseUrl/${event.id}'),
        headers: await headers(),
        body: jsonEncode(event.toJson()),
      );

      print("UPDATE RESPONSE: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return CalenderEventModel.fromJson(jsonData['data']);
      }
    } catch (e) {
      print("Exception in update Event: $e");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
    }

    return null;
  }

  /// DELETE EVENT
  Future<bool> deleteEvent(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/$id"),
        headers: await headers(),
      );

      print("DELETE RESPONSE: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Exception in delete Event: $e");
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: "Something went wrong",
        contentType: ContentType.failure,
      );
      return false;
    }
  }
}
