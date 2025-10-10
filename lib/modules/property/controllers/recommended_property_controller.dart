import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/manager/favorite.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';

import '../../../app/care/pagination/models/pagination_models.dart';
import '../../../data/network/property/services/recommanded_property_service.dart';

class RecommendedPropertyController extends PaginatedController<Items> {
  final RecommendedPropertyService _service = RecommendedPropertyService();

  // Optional filters
  Map<String, String>? filters = {};

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  /// --- Required override from PaginatedController ---
  @override
  Future<PaginationResponse<Items>> fetchItems(int page) async {
    try {
      final response = await _service.fetchRecommendedProperties(
        page: page,
        filters: filters,
      );

      print("Fetched recommended properties: ${response.items.length}");
      return response; // PaginationResponse with items + meta
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    }
  }
}
