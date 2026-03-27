import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import '../model/contact_model.dart';

class ContactService {
  final String baseUrl = ApiConstants.contact;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<List<ContactItem>> fetchContacts({int page = 1, int limit = 10}) async {
    final uri = Uri.parse(baseUrl).replace(queryParameters: {
      'page': page.toString(),
      'limit': limit.toString(),
    });
    final res = await http.get(uri, headers: await headers());
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final items = (data['data']?['items'] as List?) ?? const [];
      return items.map((e) => ContactItem.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  Future<PaginationResponse<ContactItem>> fetchContactsPaged({
    int page = 1,
    int limit = 10,
  }) async {
    final uri = Uri.parse(baseUrl).replace(queryParameters: {
      'page': page.toString(),
      'limit': limit.toString(),
    });
    final res = await http.get(uri, headers: await headers());
    final data = jsonDecode(res.body);
    return PaginationResponse<ContactItem>.fromJson(
      data,
      (json) => ContactItem.fromJson(json),
    );
  }
}
