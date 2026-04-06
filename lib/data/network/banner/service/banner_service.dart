import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/app/constants/api_constants.dart';
import '../model/banner_model.dart';

class BannerService {
  final String baseUrl = ApiConstants.banner;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeadersWithoutToken();
  }

  Future<PaginationResponse<BannerItem>> fetchBanners({
    int page = 1,
    int limit = 12,
    Map<String, String>? filters,
  }) async {
    final query = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (filters != null) ...filters,
    };
    final uri = Uri.parse(baseUrl).replace(queryParameters: query);
    debugPrint("Fetching Banners: $uri");
    final res = await http.get(uri, headers: await headers());
    if (res.statusCode == 200 || res.statusCode == 304) {
      final data = json.decode(res.body);
      return PaginationResponse<BannerItem>.fromJson(
        data,
        (json) => BannerItem.fromJson(json),
      );
    }
    debugPrint("Failed to fetch banners: ${res.statusCode} ${res.body}");
    throw Exception('Failed to fetch banners');
  }
}
