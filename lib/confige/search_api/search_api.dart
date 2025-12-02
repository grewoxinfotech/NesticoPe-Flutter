import 'dart:convert';
import 'package:http/http.dart' as http;

import '../helper/api_helper.dart';

// class GoogleMapApi {
//   // final String apiKey;
//   //
//   // GoogleMapApi(this.apiKey);
//
//   GoogleMapApi._();
//
//   static final GoogleMapApi instance = GoogleMapApi._();
//
//   static const String baseUrl =
//       'https://maps.googleapis.com/maps/api/place/autocomplete/json';
//
//   // Common method to call the API
//   Future<Map<String, dynamic>> _fetchPredictions(
//     String input,
//     String types,
//   ) async {
//     print('');
//     final uri = Uri.parse(
//       '$baseUrl?input=$input&types=$types&components=country:in&key=${ApiConfig.mapkey}',
//     );
//
//     final response = await http.get(uri);
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['status'] == 'OK') {
//         // return List<String>.from(
//         //     data['predictions'].map((p) => p['description']));
//         return json.decode(response.body) as Map<String, dynamic>;
//       } else {
//         throw Exception('API Error: ${data['status']}');
//       }
//     } else {
//       throw Exception('Failed to fetch data');
//     }
//   }
//
//   /// Search cities
//   Future<Map<String, dynamic>> searchCities(String query) async {
//     // Google uses '(cities)' type for city-level search
//     return _fetchPredictions(query, '(cities)');
//   }
//
//   /// Search states
//   Future<Map<String, dynamic>> searchStates(String query) async {
//     // Google doesn't have a specific "state" type, but you can use '(regions)'
//     return _fetchPredictions(query, '(regions)');
//   }
//
//   /// Search areas (localities, neighborhoods)
//   Future<Map<String, dynamic>> searchAreas(String query) async {
//     // Google type 'geocode' + component filter gives local areas
//     return _fetchPredictions(query, 'geocode');
//   }
//
//   Future<Map<String, dynamic>> searchLocalities(String query) async {
//     // Google type 'geocode' + component filter gives local areas
//     return _fetchPredictions(query, 'locality');
//   }

class GoogleMapApi {
  GoogleMapApi._();

  static final GoogleMapApi instance = GoogleMapApi._();

  static const String baseUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';

  /// Common method to call the API
  Future<Map<String, dynamic>> _fetchPredictions(
    String input,
    String types, {
    String? cityFilter, // optional city name for filtering
  }) async {
    // Build components parameter
    String components = 'country:in';

    final uri = Uri.parse(
      '$baseUrl?input=$input&types=$types&components=$components&key=${ApiConfig.mapkey}',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      print('Google Maps API Response: ${response.body}');
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return data;
      } else {
        throw Exception('API Error: ${data['status']}');
      }
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  /// Get city coordinates using Geocoding API
  Future<Map<String, double>?> _getCityCoordinates(String cityName) async {
    try {
      final geoUri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$cityName,India&key=${ApiConfig.mapkey}',
      );

      final response = await http.get(geoUri);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return {'lat': location['lat'], 'lng': location['lng']};
        }
      }
      return null;
    } catch (e) {
      print('❌ Error getting city coordinates: $e');
      return null;
    }
  }

  /// Search cities
  Future<Map<String, dynamic>> searchCities(String query) async {
    return _fetchPredictions(query, '(cities)');
  }

  /// Search states
  Future<Map<String, dynamic>> searchStates(String query) async {
    return _fetchPredictions(query, '(regions)');
  }

  /// Search areas (localities, neighborhoods)
  Future<Map<String, dynamic>> searchAreas(String query) async {
    return _fetchPredictions(query, 'geocode');
  }

  /// ✅ Search localities filtered by a specific city
  Future<Map<String, dynamic>> searchLocalities(
    String query, {
    String? cityFilter,
  }) async {
    try {
      // If city filter is provided, get coordinates and use location bias
      if (cityFilter != null && cityFilter.isNotEmpty) {
        final coords = await _getCityCoordinates(cityFilter);

        if (coords != null) {
          // Use location bias to prioritize results near the city
          // Radius: 30km from city center (stricter boundary)
          final uri = Uri.parse(
            '$baseUrl?input=$query&types=geocode&components=country:in'
            '&location=${coords['lat']},${coords['lng']}'
            '&radius=30000'
            '&strictbounds=true'
            '&key=${ApiConfig.mapkey}',
          );

          final response = await http.get(uri);

          if (response.statusCode == 200) {
            print('Locality search with location bias: ${response.body}');
            final data = json.decode(response.body);

            if (data['status'] == 'OK') {
              // Additional filtering: only return results that contain city name
              final predictions = data['predictions'] as List;
              final cityLower = cityFilter.toLowerCase();

              final filteredPredictions =
                  predictions.where((pred) {
                    // Check main description
                    final description =
                        pred['description']?.toString().toLowerCase() ?? '';

                    // Check structured formatting for more accurate filtering
                    final secondaryText =
                        pred['structured_formatting']?['secondary_text']
                            ?.toString()
                            .toLowerCase() ??
                        '';
                    final mainText =
                        pred['structured_formatting']?['main_text']
                            ?.toString()
                            .toLowerCase() ??
                        '';

                    // Result should contain city name in description OR secondary text
                    // This ensures the locality is actually in the selected city
                    bool matchesCity =
                        description.contains(cityLower) ||
                        secondaryText.contains(cityLower);

                    // Additional check: if the result is from a different city, reject it
                    // Common other cities to filter out
                    List<String> otherMajorCities = [
                      'mumbai',
                      'delhi',
                      'bangalore',
                      'bengaluru',
                      'chennai',
                      'kolkata',
                      'hyderabad',
                      'pune',
                      'ahmedabad',
                      'jaipur',
                      'lucknow',
                      'kanpur',
                      'madurai',
                      'coimbatore',
                      'trichy',
                      'tiruchirappalli',
                      'trivandrum',
                      'thiruvananthapuram',
                      'kochi',
                      'cochin',
                      'mysore',
                      'mysuru',
                      'vadodara',
                      'baroda',
                      'rajkot',
                      'nashik',
                      'nagpur',
                      'indore',
                      'thane',
                      'bhopal',
                      'visakhapatnam',
                      'vizag',
                      'pimpri-chinchwad',
                      'patna',
                      'ludhiana',
                      'agra',
                      'chandigarh',
                      'faridabad',
                      'ghaziabad',
                      'noida',
                      'greater noida',
                    ];

                    // Remove the selected city from the exclusion list
                    otherMajorCities.remove(cityLower);

                    // Check if result contains any other major city name
                    bool containsOtherCity = otherMajorCities.any(
                      (city) =>
                          description.contains(city) ||
                          secondaryText.contains(city),
                    );

                    return matchesCity && !containsOtherCity;
                  }).toList();

              return {'status': 'OK', 'predictions': filteredPredictions};
            } else {
              return data;
            }
          } else {
            throw Exception('Failed to fetch data');
          }
        }
      }

      // Fallback: search without city filter
      return _fetchPredictions(query, 'geocode');
    } catch (e) {
      print('❌ Error in searchLocalities: $e');
      return _fetchPredictions(query, 'geocode');
    }
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
    final result = await getNearbyPlacesByCategoryWithCoords(
      address,
      type,
      radius: radius,
    );
    return result['places'] as List<Map<String, dynamic>>;
  }

  /// Get nearby places by category (Education, Healthcare, Food, Shopping, etc.)
  /// Returns a map with 'places' list and 'propertyCoords' map
  Future<Map<String, dynamic>> getNearbyPlacesByCategoryWithCoords(
    String address,
    String type, {
    int radius = 2000,
  }) async {
    print('Address in API: $address');
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

      print('Geocoding Response: $geoData');

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

      final places =
          results.take(10).map((place) {
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
      return {'propertyCoords': null, 'places': <Map<String, dynamic>>[]};
    }
  }
}
