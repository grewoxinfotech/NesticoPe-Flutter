import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nesticope_app/app/constants/api_constants.dart';

class ApiConfig {
  static String mapkey = '';
  static String truecallerClientId = '';
  static String get googleMapApi =>
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?key=$mapkey';


  static String token = '';

  static void updateToken(String newToken) {
    print("newToken=$newToken");
    token = newToken;
  }

  static Map<String, String> header() {
    final headers = {"Content-type": "application/json"};

    if (token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }
    print("Final Headers: $headers");
    return headers;
  }

  /// Fetch third-party settings and update keys (e.g., Google Maps)
  static Future<void> fetchThirdPartySettings() async {
    try {
      final uri = Uri.parse(ApiConstants.thirdPartySettings)
          .replace(queryParameters: {'page': '1', 'limit': '10'});
      final res = await http.get(uri, headers: await ApiConstants.getHeaders());
      if (res.statusCode == 200) {
        final jsonBody = json.decode(res.body) as Map<String, dynamic>;
        final data = jsonBody['data'] as Map<String, dynamic>? ?? {};
        final items = data['items'] as List<dynamic>? ?? [];
        for (final item in items) {
          final m = item as Map<String, dynamic>;
          final type = (m['type'] ?? '').toString().toLowerCase();
          final name = (m['name'] ?? '').toString().toLowerCase();
          if (type == 'maps' || name.contains('google maps')) {
            final key = m['apiKey']?.toString();
            if (key != null && key.isNotEmpty) {
              mapkey = key;
            }
          }
          if (name.contains('truecaller')) {
            // Backend returns client id in `token` for Truecaller item
            final token = m['token']?.toString();
            final apiKey = m['apiKey']?.toString();
            // Prefer token field for Truecaller; fallback to apiKey if provided
            final clientId = (token != null && token.isNotEmpty)
                ? token
                : (apiKey ?? '');
            if (clientId.isNotEmpty) {
              truecallerClientId = clientId;
            }
          }
        }
      }
    } catch (e) {
      // Silent fallback, keep existing key if any
    }
  }

  /// Ensure map key is present before making Google requests
  static Future<void> ensureMapKey() async {
    if (mapkey.isEmpty) {
      await fetchThirdPartySettings();
    }
  }

  /// Ensure Truecaller client id is loaded (from ThirdPartySettings)
  static Future<void> ensureTruecallerClientId() async {
    if (truecallerClientId.isEmpty) {
      await fetchThirdPartySettings();
    }
  }
}
