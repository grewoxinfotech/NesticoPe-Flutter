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

  /// Get Near By LandMarks of address
  // Future<List<Map<String, dynamic>>> getNearbyLandmarks(String address) async {
  //   try {
  //     // 1️⃣ Step: Convert address → coordinates using Geocoding API
  //     final geoUri = Uri.parse(
  //       'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=${ApiConfig.mapkey}',
  //     );
  //     final geoResponse = await http.get(geoUri);
  //
  //     if (geoResponse.statusCode != 200) {
  //       throw Exception('Failed to get coordinates for address');
  //     }
  //
  //     final geoData = json.decode(geoResponse.body);
  //     if (geoData['status'] != 'OK' || geoData['results'].isEmpty) {
  //       throw Exception('No coordinates found for address');
  //     }
  //
  //     final location = geoData['results'][0]['geometry']['location'];
  //     final lat = location['lat'];
  //     final lng = location['lng'];
  //
  //     // 2️⃣ Step: Get nearby landmarks using Places Nearby Search API
  //     final nearbyUri = Uri.parse(
  //       'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=1500&key=${ApiConfig.mapkey}',
  //     );
  //
  //     final nearbyResponse = await http.get(nearbyUri);
  //
  //     if (nearbyResponse.statusCode != 200) {
  //       throw Exception('Failed to fetch nearby landmarks');
  //     }
  //
  //     final nearbyData = json.decode(nearbyResponse.body);
  //     if (nearbyData['status'] != 'OK') {
  //       throw Exception('Nearby API Error: ${nearbyData['status']}');
  //     }
  //
  //     final List<dynamic> results = nearbyData['results'] ?? [];
  //
  //     // Return simplified landmark info
  //     return results.map<Map<String, dynamic>>((place) {
  //       return {
  //         'name': place['name'],
  //         'address': place['vicinity'],
  //         'types': place['types'],
  //         'lat': place['geometry']['location']['lat'],
  //         'lng': place['geometry']['location']['lng'],
  //         'rating': place['rating'],
  //       };
  //     }).toList();
  //   } catch (e) {
  //     print('❌ Error in getNearbyLandmarks: $e');
  //     return [];
  //   }
  // }

  Future<List<Map<String, dynamic>>> getNearbyLandmarks(String address) async {
    try {
      // 1️⃣ Step: Convert address → coordinates using Geocoding API
      final geoUri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=${ApiConfig.mapkey}',
      );
      final geoResponse = await http.get(geoUri);

      if (geoResponse.statusCode != 200) {
        throw Exception('Failed to get coordinates for address');
      }

      final geoData = json.decode(geoResponse.body);
      if (geoData['status'] != 'OK' || geoData['results'].isEmpty) {
        throw Exception('No coordinates found for address');
      }

      final location = geoData['results'][0]['geometry']['location'];
      final lat = location['lat'];
      final lng = location['lng'];

      // 2️⃣ Step: Get nearby landmarks using Places Nearby Search API
      final nearbyUri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=1500&key=${ApiConfig.mapkey}',
      );

      final nearbyResponse = await http.get(nearbyUri);

      if (nearbyResponse.statusCode != 200) {
        throw Exception('Failed to fetch nearby landmarks');
      }

      final nearbyData = json.decode(nearbyResponse.body);
      if (nearbyData['status'] != 'OK') {
        throw Exception('Nearby API Error: ${nearbyData['status']}');
      }

      final List<dynamic> results = nearbyData['results'] ?? [];

      // 3️⃣ Return simplified landmark info (limit to first 4)
      final simplified =
          results.map<Map<String, dynamic>>((place) {
            return {
              'name': place['name'],
              'address': place['vicinity'],
              'types': place['types'],
              'lat': place['geometry']['location']['lat'],
              'lng': place['geometry']['location']['lng'],
              'rating': place['rating'],
            };
          }).toList();

      return simplified.take(4).toList(); // ✅ Limit to 4 items
    } catch (e) {
      print('❌ Error in getNearbyLandmarks: $e');
      return [];
    }
  }

  /// Get nearby places by category (simple version, returns just the places list)
  Future<List<Map<String, dynamic>>> getNearbyPlacesByCategory(
    String address,
    String type, {
    int radius = 2000,
  }) async {
    final result = await getNearbyPlacesByCategoryWithCoords(address, type, radius: radius);
    return result['places'] as List<Map<String, dynamic>>;
  }

  /// Get nearby places by category (Education, Healthcare, Food, Shopping, etc.)
  /// Returns a map with 'places' list and 'propertyCoords' map
  Future<Map<String, dynamic>> getNearbyPlacesByCategoryWithCoords(
    String address,
    String type, {
    int radius = 2000,
  }) async {
    try {
      // Step 1: Geocode the address to get lat/lng
      final geoUri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=${ApiConfig.mapkey}',
      );

      final geoResponse = await http.get(geoUri);

      if (geoResponse.statusCode != 200) {
        throw Exception('Failed to get coordinates for address');
      }

      final geoData = json.decode(geoResponse.body);

      if (geoData['status'] != 'OK' || geoData['results'].isEmpty) {
        throw Exception('No coordinates found for address');
      }

      final location = geoData['results'][0]['geometry']['location'];
      final lat = location['lat'];
      final lng = location['lng'];

      print('📍 Fetching $type near ($lat, $lng)');

      // Step 2: Fetch nearby places by type
      final placesUri = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=$radius&type=$type&key=${ApiConfig.mapkey}',
      );

      final placesResponse = await http.get(placesUri);

      if (placesResponse.statusCode != 200) {
        throw Exception('Failed to fetch nearby places');
      }

      final placesData = json.decode(placesResponse.body);

      if (placesData['status'] != 'OK') {
        print('⚠️ Places API Status: ${placesData['status']}');
        return {
          'propertyCoords': {'lat': lat, 'lng': lng},
          'places': <Map<String, dynamic>>[],
        };
      }

      // Step 3: Parse and return results with property coordinates
      final results = placesData['results'] as List<dynamic>;

      final places = results.take(10).map((place) {
        return {
          'name': place['name'] ?? 'Unknown',
          'address': place['vicinity'] ?? '',
          'types': place['types'] ?? [],
          'lat': place['geometry']['location']['lat'],
          'lng': place['geometry']['location']['lng'],
          'rating': place['rating'] ?? 0.0,
          'distance': '', // Distance can be calculated separately if needed
        };
      }).toList();

      return {
        'propertyCoords': {'lat': lat, 'lng': lng},
        'places': places,
      };
    } catch (e) {
      print('❌ Error in getNearbyPlacesByCategory: $e');
      return {
        'propertyCoords': null,
        'places': <Map<String, dynamic>>[],
      };
    }
  }
}
