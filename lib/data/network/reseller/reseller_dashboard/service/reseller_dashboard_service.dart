import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/utils/logger/app_logger.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ResellerDashboardService {
  ResellerDashboardService._();

  static ResellerDashboardService resellerDashboardService =
      ResellerDashboardService._();
  final String _baseUrl = ApiConstants.resellerDashboard;
  final String _userId = '';
  final String cityWiseLeaderBoard = ApiConstants.resellerCityWiseReseller;
  final String getCityWise = ApiConstants.resellerGetAllCity;

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }

  Future<Map<String, dynamic>?> fetchResellerDashboard(
    String userId, {
    int? leadsYear,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (leadsYear != null) {
        queryParams['year'] = leadsYear.toString();
      }
      final response = await http.get(
        Uri.parse('$_baseUrl/$userId').replace(queryParameters: queryParams),
        headers: await header(),
      );
      print(
        "Reseller dashboard Url from api : ${Uri.parse('$_baseUrl/$userId').replace(queryParameters: queryParams)}",
      );

      final decoded = jsonDecode(response.body);
      print('📦 Reseller Dashboard Raw Response: $decoded');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return decoded;
      } else {
        print('⚠️ Reseller Dashboard Error Response: $decoded');
        return decoded;
      }
    } catch (e, stack) {
      print('❌ Exception in fetchResellerDashboard: $e');
      print(stack);
      return null;
    }
  }

  Future<Map<String, dynamic>> fetchCityWiseLeaderBoard({
    String? period,
    String? city,
    String? week,
    String? month,
  }) async {
    try {
      // ✅ Build query safely (skip null or empty)
      final Map<String, String> query = {};

      if (period != null && period.trim().isNotEmpty) {
        query["period"] = period;
      }
      if (city != null && city.trim().isNotEmpty) {
        query["city"] = city;
      }
      if (week != null && week.trim().isNotEmpty) {
        query["week"] = week;
      }
      if (month != null && month.trim().isNotEmpty) {
        query["month"] = month;
      }

      // ✅ Construct final URL safely
      final uri = Uri.parse(
        cityWiseLeaderBoard,
      ).replace(queryParameters: query.isNotEmpty ? query : null);

      log("📡 Fetch City Wise Leaderboard → $uri");

      final response = await http.get(uri, headers: await header());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        AppLogger.structured("✅ City Wise data fetched", data);
        return data;
      } else {
        log("⚠️ City Wise API failed: ${response.statusCode}");
        return {};
      }
    } catch (e, st) {
      log("❌ Error in fetchCityWiseLeaderBoard: $e");
      log(st.toString());
      return {};
    }
  }

  Future<Map<String, dynamic>> fetchCityOfReseller() async {
    try {
      var url = Uri.parse(getCityWise);
      final response = await http.get(url, headers: await header());
      log("fetch City wise data from api Url $url");

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.structured(
          "City Wise data fetch data ",
          jsonDecode(response.body),
        );

        final data = jsonDecode(response.body);

        return data;
      }
      return {};
    } catch (e) {
      rethrow;
    }
  }
}
