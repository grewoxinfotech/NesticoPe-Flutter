import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/utils/logger/app_logger.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ResellerDashboardService {
  ResellerDashboardService._();

  static ResellerDashboardService resellerDashboardService =
      ResellerDashboardService._();
  final String _baseUrl = ApiConstants.resellerDashboard;
  final assignPoperty=ApiConstants.property;
  final assignProject=ApiConstants.builderProject;
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




  Future<Map<String, dynamic>?> fetchResellerAndYearDashboard(
    String userId, {
    int? leadsYear,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (leadsYear != null) {
        
        queryParams['resellerId']=userId;
        queryParams['year'] = leadsYear.toString();
      }
      final response = await http.get(
        Uri.parse('$_baseUrl').replace(queryParameters: queryParams),
        headers: await header(),
      );
      print(
        "Reseller fetchResellerAndYearDashboard Url from api : ${Uri.parse('$_baseUrl').replace(queryParameters: queryParams)}",
      );

      final decoded = jsonDecode(response.body);
      print('📦 Reseller fetchResellerAndYearDashboard Raw Response: $decoded  ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return decoded;
      } else {
        print('⚠️ Reseller fetchResellerAndYearDashboard Error Response: $decoded');
        return decoded;
      }
    } catch (e, stack) {
      print('❌ Exception in fetchResellerAndYearDashboard: $e');
      print(stack);
      return null;
    }
  }


    Future<Map<String, dynamic>?> fetchResellerAssignProperty(
    String userId, {
    bool isExpired=false,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (isExpired != null) {
        queryParams['isExpired'] = isExpired.toString();
        queryParams['assignedTo']=userId;
      }
      final response = await http.get(
        Uri.parse('$assignPoperty').replace(queryParameters: queryParams),
        headers: await header(),
      );
      print(
        "Reseller fetchResellerAssignProperty Url from api : ${Uri.parse('$assignPoperty').replace(queryParameters: queryParams)}",
      );

      final decoded = jsonDecode(response.body);
      print('📦 Reseller fetchResellerAssignProperty Raw Response: $decoded   ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return decoded;
      } else {
        print('⚠️ Reseller fetchResellerAssignProperty Error Response: $decoded');
        return decoded;
      }
    } catch (e, stack) {
      print('❌ Exception in fetchResellerAssignProperty: $e');
      print(stack);
      return null;
    }
  }



   Future<Map<String, dynamic>?> fetchResellerAssignProject(
    String userId, {
    bool isExpired=false,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (isExpired != null) {
        queryParams['isExpired'] = isExpired.toString();
        queryParams['assignedTo']=userId;
      }
      final response = await http.get(
        Uri.parse('$assignProject').replace(queryParameters: queryParams),
        headers: await header(),
      );
      print(
        "Reseller fetchResellerAssignProject Url from api : ${Uri.parse('$assignProject').replace(queryParameters: queryParams)}",
      );

      final decoded = jsonDecode(response.body);
      print('📦 Reseller fetchResellerAssignProject Raw Response: $decoded   ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return decoded;
      } else {
        print('⚠️ Reseller fetchResellerAssignProject Error Response: $decoded');
        return decoded;
      }
    } catch (e, stack) {
      print('❌ Exception in fetchResellerAssignProject: $e');
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
        final data = jsonDecode(response.body);

        return data;
      }
      return {};
    } catch (e) {
      rethrow;
    }
  }
}
