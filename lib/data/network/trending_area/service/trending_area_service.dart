import 'dart:convert';
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/confige/helper/api_helper.dart';
import 'package:http/http.dart' as http;

import '../model/trending_area_model.dart';


class CityInsightsService {

  CityInsightsService._();
  static CityInsightsService cityInsightsService=CityInsightsService._();

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }
  Future<TrendingAreasResponse?> getTrendingAreas(String city) async {
    final url = Uri.parse('${ApiConstants.baseURL}${ApiConstants.trendingAreaAPi}=$city');


    try {
      final response = await http.get(url,headers:await header() );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return TrendingAreasResponse.fromJson(jsonData);
      } else {
        print('❌ Failed: ${response.statusCode} - ${response.reasonPhrase}');
        return null;
      }
    } catch (e) {
      print('⚠️ Exception: $e');
      return null;
    }
  }
}
