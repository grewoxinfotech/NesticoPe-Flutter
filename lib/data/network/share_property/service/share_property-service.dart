import 'dart:convert';
import 'dart:developer';


import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class SharePropertyService{
  SharePropertyService._();
  static SharePropertyService service=SharePropertyService._();
  final _baseUrl=ApiConstants.sharePropertyLink;
  final _baseSharePropertyUrl=ApiConstants.resellerPropertyShare;

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }
  Future<Map<String,dynamic>> getPropertyLink(String propertyId)
  async {
  try{
    final  url=Uri.parse(_baseUrl);
    final response=await http.post(url,headers:await header(),body: jsonEncode({
      "propertyId": propertyId,
      "platform": "copy_link",
      "shareType": "direct"
    } ));
    log("Share Property By id ${response.body}");
    if(response.statusCode==200 || response.statusCode==201)
    {
        final data=jsonDecode(response.body);
        log("Share Property By id ${data}");

        return data;

    }
  }catch(e){
    print('Share Link error $e');
    return {};
  }
  return {};
  }

  Future<String?> sharePropertyLink(String propertyId) async {
    try {
      final url = Uri.parse(_baseSharePropertyUrl);

      final response = await http.post(
        url,
        headers: await header(),
        body: jsonEncode({"propertyId": propertyId}),
      );

      log("📤 Share Property Request → $propertyId");
      log("📩 Response Body → ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data is Map && data['success'] == true) {
          final shareData = data['data'];
          if (shareData != null && shareData['shareUrl'] != null) {
            final shareUrl = shareData['shareUrl'].toString();
            log("✅ Share Property URL → $shareUrl");
            return shareUrl;
          }
        }

        log("⚠️ Response received but missing share URL.");
        return null;
      } else {
        log("⚠️ Failed to share property. Status Code: ${response.statusCode}");
        return null;
      }
    } catch (e, stack) {
      log("❌ Error while sharing property: $e");
      log(stack.toString());
      return null;
    }
  }}
