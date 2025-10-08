import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/data/network/news/news_model.dart';

import '../../../data/network/news/news_service.dart';

class NewsController extends PaginatedController<NewsItem> {
  final NewsService _service = NewsService();

  // Reactive state
  RxBool isFeatured = false.obs;
  RxBool isExpanded = false.obs;
  RxString selectedCategory = ''.obs;

  // Optional filters
  Map<String, String>? filters = {};

  @override
  void onInit() {
    super.onInit();
    loadInitial(); // Auto-load page 1
  }

  /// --- Pagination Fetch ---
  @override
  Future<PaginationResponse<NewsItem>> fetchItems(int page) async {
    try {
      final response = await _service.fetchNews(page: page, filters: filters);
      print("Fetched news items: ${response.items.length}");
      return response;
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    }
  }

  /// --- Filters ---
  void applyFilter(String key, String val) {
    filters ??= {};
    filters!.clear();
    filters![key] = val;

    currentPage.value = 1;
    totalPages.value = 1;
    hasMore.value = true;
    items.clear();

    refreshList();
  }

  Future<void> applyFilters(Map<String, String> newFilters) async {
    isLoading.value = true;
    filters = newFilters;
    await refreshList();
    isLoading.value = false;
  }

  /// --- Get Single News by ID ---
  Future<NewsItem?> getNewsById(String id) async {
    try {
      final existing = items.firstWhereOrNull((item) => item.id == id);
      if (existing != null) return existing;

      final news = await _service.getNewsById(id);
      if (news != null) {
        items.add(news);
        items.refresh();
        return news;
      }
    } catch (e) {
      print("Get news error: $e");
    }
    return null;
  }
}
