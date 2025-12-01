import 'dart:convert';
import 'dart:developer';


import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class SharePropertyService{
  SharePropertyService._();
  static SharePropertyService service=SharePropertyService._();
  final _baseUrl=ApiConstants.sharePropertyLink;

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
}