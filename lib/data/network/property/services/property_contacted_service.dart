import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:nesticope_app/utils/logger/app_logger.dart';
import 'package:http/http.dart' as http;
import '../../../../app/constants/api_constants.dart';
import '../models/inquiry_model.dart';

class PropertyContactedService {
  final String baseUrl = ApiConstants.property;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  /// Fetch contacted property inquiries for a given user.

  Future<List<Inquiry>> fetchContactedInquiries(String userId) async {
    try {
      final uri = Uri.parse('$baseUrl/$userId/inquiry');
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.structured(
          'Fetched contacted inquiries successfully',
          jsonDecode(response.body),
        );
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          final inquiryResponse = InquiryResponse.fromJson(data);
          return inquiryResponse.data.items ?? [];
        } else {
          return [];
        }
      } else {
        throw Exception(
          'Failed to fetch contacted inquiries: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching contacted inquiries: $e');
      return [];
    }
  }

  Future<bool> fetchHasInquiries(String userId, {String? itemId}) async {
    try {
      // Build the path dynamically
      final idData =
          (itemId != null && itemId.isNotEmpty) ? '$userId/$itemId' : userId;
      final uri = Uri.parse('$baseUrl/$idData/has-inquired');
      print("URI os Inquiry Check : ${uri}");

      final response = await http.get(uri, headers: await headers());
      print("Response os Inquiry Check : ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // Safely check response structure
        if (data is Map<String, dynamic> &&
            data['success'] == true &&
            data['data'] != null) {
          return data['data']['hasInquired'];
        } else {
          print('Unexpected response format or empty data');
          return false;
        }
      } else {
        throw HttpException(
          'Failed to fetch contacted inquiries (code: ${response.statusCode})',
          uri: uri,
        );
      }
    } catch (e, stack) {
      debugPrint('Error fetching contacted inquiries: $e');
      debugPrintStack(stackTrace: stack);
      return false;
    }
  }

  /// Fetch only contacted property IDs for a given user
  Future<List<String>> fetchContactedPropertyIds(String userId) async {
    try {
      final inquiries = await fetchContactedInquiries(userId);
      return inquiries.map((e) => e.propertyId).toList();
    } catch (e) {
      print('Error fetching contacted property IDs: $e');
      return [];
    }
  }

  Future<bool> addInquiry(Map<String, dynamic> data, String id) async {
    try {
      print("baseUrl : ${baseUrl}/${id}");
      final response = await http.post(
        Uri.parse("$baseUrl/$id/inquiry"),
        headers: await headers(),
        body: jsonEncode(data),
      );
      print("response : ${response.body}");
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Delete property exception: $e");
      return false;
    }
  }

  /// Update an existing inquiry's negotiable meta by inquiry id
  Future<bool> updateInquiryNegotiable({
    required String inquiryId,
    required String propertyId,
    required Map<String, dynamic> meta,
  }) async {
    try {
      final uri = Uri.parse("$baseUrl/inquiry/$inquiryId");
      final payload = {"propertyId": propertyId, "meta": meta};
      log("PUT $uri => ${jsonEncode(payload)}");

      final res = await http.put(
        uri,
        headers: await headers(),
        body: jsonEncode(payload),
      );
      print("PUT $uri => ${res.statusCode} ${res.body}");
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      print("updateInquiryNegotiable exception: $e");
      return false;
    }
  }

  /// Get inquiries for a specific property
  Future<List<Inquiry>> fetchInquiriesByPropertyId(String userId) async {
    try {
      final uri = Uri.parse('$baseUrl/$userId/inquiry');
      print("URI os Inquiry Check for Negotiable : ${uri}");

      final response = await http.get(uri, headers: await headers());
      if (response.statusCode == 200 || response.statusCode == 201) {
        log(
          'Fetched property inquiries successfully ${jsonDecode(response.body)}',
        );
        final data = jsonDecode(response.body);
        final inquiryResponse = InquiryResponse.fromJson(data);
        log(
          'Fetched property inquiries successfully Applogger ${inquiryResponse.data.items.map((e) => e.toJson())}',
        );
        return inquiryResponse.data.items ?? [];
      } else {
        throw Exception(
          'Failed to fetch property inquiries: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetchInquiriesByPropertyId: $e');
      return [];
    }
  }

  /// Get inquiries by user id (alias for negotiable preloading)
  Future<List<Inquiry>> fetchUserInquiries(String userId) async {
    try {
      final uri = Uri.parse('$baseUrl/$userId/inquiry');
      final response = await http.get(uri, headers: await headers());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final inquiryResponse = InquiryResponse.fromJson(data);
        return inquiryResponse.data.items ?? [];
      } else {
        throw Exception(
          'Failed to fetch user inquiries: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetchUserInquiries: $e');
      return [];
    }
  }
}
