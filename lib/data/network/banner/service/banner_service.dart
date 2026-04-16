import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:nesticope_app/app/constants/api_constants.dart';
import '../model/banner_model.dart';

class BannerService {
  final String baseUrl = ApiConstants.banner;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeadersWithoutToken();
  }

  Future<List<BannerItem>> fetchActiveBanners() async {
    final uri = Uri.parse('$baseUrl/active');
    debugPrint("Fetching Active Banners: $uri");
    final res = await http.get(uri, headers: await headers());
    debugPrint("Active Banners Status Code: ${res.statusCode}");
    debugPrint("Active Banners Body: ${res.body}");
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      final list = (data['data'] as List?) ?? const [];
      return list.map((e) => BannerItem.fromJson(e)).toList();
    }
    debugPrint("Failed to fetch active banners: ${res.statusCode} ${res.body}");
    throw Exception('Failed to fetch active banners');
  }

 
}
