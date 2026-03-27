import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nesticope_app/app/constants/api_constants.dart';
import '../../../modules/seller/model/overview_model.dart';
// import '../models/seller_overview_model.dart';

// class SellerOverviewService {
//   final String baseUrl = "${ApiConstants.auth}/seller/overview";
//
//   /// 🔹 Fetch Seller Overview Data
//   Future<SellerOverviewModel?> fetchSellerOverview({
//     required String token,
//   }) async {
//     try {
//       final response = await http.get(
//         Uri.parse(baseUrl),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         print("Reseekfrheu8fyuhgfyue ${response.body}");
//         final Map<String, dynamic> jsonResponse = json.decode(response.body);
//         return SellerOverviewModel.fromJson(jsonResponse);
//       } else {
//         print("❌ Failed to fetch seller overview: ${response.statusCode}");
//         print("Response: ${response.body}");
//         return null;
//       }
//     } catch (e) {
//       print("⚠️ Error fetching seller overview: $e");
//       return null;
//     }
//   }
// }
