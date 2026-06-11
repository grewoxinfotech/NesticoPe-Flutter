import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nesticope_app/app/constants/api_constants.dart';

class ApiConfig {
  static String mapkey = '';
  static String truecallerClientId = '';
  /// Razorpay Checkout **key_id** (public), from ThirdPartySettings "Payment Gateway" / Razorpay row.
  static String razorpayKeyId = '';
  static String get googleMapApi =>
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?key=$mapkey';
  static bool isAdharActive = false;
  static String aadharClientId='';

   /// Check if a third-party service is active based on its name


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
      print("Third party settings response =$res");
      if (res.statusCode == 200) {
        final jsonBody = json.decode(res.body) as Map<String, dynamic>;
        final data = jsonBody['data'] as Map<String, dynamic>? ?? {};
        final items = data['items'] as List<dynamic>? ?? [];
        for (final item in items) {
          print("Item =$item");
          final m = item as Map<String, dynamic>;
          final type = (m['type'] ?? '').toString().toLowerCase();
          final name = (m['name'] ?? '').toString().toLowerCase();
          final status = (m['status'] ?? '').toString().toLowerCase();
          final isActive = status.isEmpty || status == 'active';


          if (type == 'maps' || name.contains('google maps')) {
            if (!isActive) continue;
            final key = m['apiKey']?.toString();

            if (key != null && key.isNotEmpty) {

              print("Map api key =$key");

              mapkey = key;
            }
          }
        }
      }
    } catch (e) {
      // Silent fallback, keep existing key if any
    }
  }

  static Future<void> fetchTruecallerSettings() async {
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
          final name = (m['name'] ?? '').toString().toLowerCase();
          if (name.contains('truecaller')) {
            final token = m['token']?.toString();
            final apiKey = m['apiKey']?.toString();
            final clientId =
                (token != null && token.isNotEmpty) ? token : (apiKey ?? '');
            if (clientId.isNotEmpty) {
              truecallerClientId = clientId;
            }
          }
        }
      }
    } catch (_) {}
  }

  
  static Future<void> fetchAadharSettings() async {
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
          final name = (m['name'] ?? '').toString().toLowerCase();
          if (name.contains('aadhar verification')) {
           if(m['status']?.toString().toLowerCase() == 'active'){
            final token = m['token']?.toString();
            final apiKey = m['apiKey']?.toString();
            final clientId =
                (token != null && token.isNotEmpty) ? token : (apiKey ?? '');
            if (clientId.isNotEmpty) {
              truecallerClientId = clientId;
            }
           }
           else{
             isAdharActive = false;
             aadharClientId = '';
           }
          }
        }
      }
    } catch (_) {}
  }

  /// Ensure map key is present before making Google requests
  static Future<void> ensureMapKey() async {
    if (mapkey.isEmpty) {
      await fetchThirdPartySettings();
    }
  }

  /// Load Razorpay **key_id** for Checkout when not embedded in create-order response.
  static Future<void> ensureRazorpayKeyId() async {
    if (razorpayKeyId.isEmpty) {
      await fetchThirdPartySettings();
    }
  }

  /// Ensure Aadhar client id is loaded (from ThirdPartySettings)
  static Future<void> ensureAadharClientId() async {
    if (aadharClientId.isEmpty) {
      await fetchAadharSettings();
    }
  }

  /// Ensure Truecaller client id is loaded (from ThirdPartySettings)
  static Future<void> ensureTruecallerClientId() async {
    if (truecallerClientId.isEmpty) {
      await fetchTruecallerSettings();
    }
  }
}
