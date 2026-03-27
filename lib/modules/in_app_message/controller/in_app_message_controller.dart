import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';

import '../../../data/network/in_app_messaging/model/in_app_messaging_model.dart';
import '../../../data/network/in_app_messaging/service/in_app_messaging_service.dart';

class NotificationController extends PaginatedController<NotificationItem> {
  final NotificationService _service = NotificationService();

  /// Reactive UI state
  RxBool isExpanded = false.obs;
  RxBool isUnreadOnly = false.obs;
  RxString selectedType = ''.obs;
  RxInt unReadNumber=0
.obs;
  /// Optional filters
  Map<String, String>? filters = {};

  @override
  void onInit() {
    super.onInit();
    loadInitial(); // Auto-load first page
    getUnReadNotificationCount();
  }

  ///==================== Pagination Fetch ====================
  @override
  Future<PaginationResponse<NotificationItem>> fetchItems(int page) async {
    try {
      final response = await _service.fetchNotifications(
        page: page,
        filters: filters,
      );

      debugPrint("Fetched notifications: ${response.items.length}");
      getUnReadNotificationCount();

      return response;
    } catch (e) {
      debugPrint("Exception in fetchItems: $e");
      rethrow;
    }
  }

  Future<void> markAllRead() async {
    final data = await _service.updateNotificationMarkAsRead();
    if (data) {
      getUnReadNotificationCount();
      items.clear();
      refreshList();
    }
  }

  ///==================== Filters ====================
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

  Future<void> markedReadNotification(String id) async {
    final data = await _service.markReadNotificationById(id);
    if (data) {
      getUnReadNotificationCount();
      refreshList();
      items.refresh();

    }
  }

  Future<void> getUnReadNotificationCount()
  async {
    final data = await _service.fetchCountOfUnReadNotification();
    unReadNumber.value=data;
  }

  ///==================== Get Single Notification ====================
  Future<NotificationItem?> getNotificationById(String id) async {
    try {
      final existing = items.firstWhereOrNull((item) => item.id == id);

      if (existing != null) return existing;

      final notification = await _service.getNotificationById(id);

      if (notification != null) {
        items.add(notification);
        items.refresh();
        return notification;
      }
    } catch (e) {
      debugPrint("Get notification error: $e");
    }

    return null;
  }

  ///==================== Refresh Helper ====================
  Future<void> refreshNotifications() async {
    await refreshList();
    Future.delayed(Duration(seconds: 2));
  }
}
