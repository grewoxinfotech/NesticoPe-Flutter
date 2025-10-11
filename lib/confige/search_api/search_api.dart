// import 'dart:convert';
// import 'package:housing_flutter_app/confige/helper/api_helper.dart';
// import 'package:http/http.dart' as http;
//
//
// class GoogleMapApi {
//   GoogleMapApi._();
//
//   static final GoogleMapApi instance = GoogleMapApi._();
//   Future<Map<String, dynamic>?> getPlacePredictions(String city) async {
//     try {
//       final Uri url = Uri.parse(
//         "${ApiConfig.googleMapApi}&input=$city"
//
//         ,
//       );
//
//       final http.Response response = await http.get(url,headers: {'Content-type' : 'application/json'});
//
//       if (response.statusCode == 200) {
//         print("Map respons=========${response.body}");
//
//         return json.decode(response.body) as Map<String, dynamic>;
//       } else {
//         print("❌ Failed with status: ${response.statusCode}");
//         return null;
//       }
//     } catch (e) {
//       print("❌ Error fetching predictions: $e");
//       return null;
//     }
//   }
// }

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../helper/api_helper.dart';

class GoogleMapApi {
  // final String apiKey;
  //
  // GoogleMapApi(this.apiKey);

  GoogleMapApi._();

  static final GoogleMapApi instance = GoogleMapApi._();

  static const String baseUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';

  // Common method to call the API
  Future<Map<String, dynamic>> _fetchPredictions(
    String input,
    String types,
  ) async {
    final uri = Uri.parse(
      '$baseUrl?input=$input&types=$types&components=country:in&key=${ApiConfig.mapkey}',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        // return List<String>.from(
        //     data['predictions'].map((p) => p['description']));
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('API Error: ${data['status']}');
      }
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  /// Search cities
  Future<Map<String, dynamic>> searchCities(String query) async {
    // Google uses '(cities)' type for city-level search
    return _fetchPredictions(query, '(cities)');
  }

  /// Search states
  Future<Map<String, dynamic>> searchStates(String query) async {
    // Google doesn't have a specific "state" type, but you can use '(regions)'
    return _fetchPredictions(query, '(regions)');
  }

  /// Search areas (localities, neighborhoods)
  Future<Map<String, dynamic>> searchAreas(String query) async {
    // Google type 'geocode' + component filter gives local areas
    return _fetchPredictions(query, 'geocode');
  }

  Future<Map<String, dynamic>> searchLocalities(String query) async {
    // Google type 'geocode' + component filter gives local areas
    return _fetchPredictions(query, 'locality');
  }
}
