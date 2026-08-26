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
      final uri =
          (userId.isNotEmpty && userId != null)
              ? Uri.parse('$baseUrl/$userId/inquiry')
              : Uri.parse('$baseUrl/inquiry');
      [];
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200 || response.statusCode == 201) {
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
      return [];
    }
  }

  Future<bool> fetchHasInquiries(String userId, {String? itemId}) async {
    try {
      // Build the path dynamically
      final idData =
          (itemId != null && itemId.isNotEmpty) ? '$userId/$itemId' : userId;
      final uri =
          (userId.isNotEmpty && userId != null)
              ? Uri.parse('$baseUrl/$idData/has-inquired')
              : Uri.parse('$baseUrl/has-inquired');

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // Safely check response structure
        if (data is Map<String, dynamic> &&
            data['success'] == true &&
            data['data'] != null) {
          return data['data']['hasInquired'];
        } else {
          return false;
        }
      } else {
        throw HttpException(
          'Failed to fetch contacted inquiries (code: ${response.statusCode})',
          uri: uri,
        );
      }
    } catch (e, stack) {
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
      return [];
    }
  }

  Future<bool> addInquiry(Map<String, dynamic> data, String id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/$id/inquiry"),
        headers: await headers(),
        body: jsonEncode(data),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
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

      final res = await http.put(
        uri,
        headers: await headers(),
        body: jsonEncode(payload),
      );

      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  /// Get inquiries for a specific property
  Future<List<Inquiry>> fetchInquiriesByPropertyId(String userId) async {
    try {
      final uri =
          (userId.isNotEmpty)
              ? Uri.parse('$baseUrl/$userId/inquiry')
              : Uri.parse('$baseUrl/inquiry');

      final response = await http.get(uri, headers: await headers());
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final inquiryResponse = InquiryResponse.fromJson(data);

        return inquiryResponse.data.items ?? [];
      } else {
        throw Exception(
          'Failed to fetch property inquiries: ${response.statusCode}',
        );
      }
    } catch (e) {
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
      return [];
    }
  }
}
