import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/reseller/meeting/meeting_model.dart';
import 'package:nesticope_app/data/network/reseller/meeting/meeting_service.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';

class ResellerMeetingController extends PaginatedController<MeetingItem> {
  final MeetingService _service = MeetingService.instance;
  final RxString resellerId = ''.obs;

  /// Page size for pagination
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await SecureStorage.getUserData();
    resellerId.value = user?.user?.id ?? '';
    await loadInitial();
  }

  @override
  Future<PaginationResponse<MeetingItem>> fetchItems(int page) async {
    if (resellerId.isEmpty) {
      return PaginationResponse(items: [], meta: PaginationMeta(total: 0, currentPage: 1, totalPages: 1, hasMore: false, fetchedAll: true));
    }
    return _service.fetchMeetings(
      page: page,
      limit: pageSize,
      resellerId: resellerId.value,
    );
  }

  Future<void> refreshMeetings() async {

    try {
      await refreshList();
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: e.toString(),
        contentType: ContentType.failure,
      );
    }
  }
  Future<void> createMeeting({
    required String title,
    required String date, // yyyy-MM-dd
    required String time, // HH:mm
    String? note,
  }) async {
    try {
      final payload = CreateMeetingPayload(
        meetingTitle: title,
        date: date,
        time: time,
        resellerId: resellerId.value,
        note: note,
      );
      await _service.createMeeting(payload);
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Success',
        message: 'Meeting request submitted',
        contentType: ContentType.success,
      );
      await loadInitial();
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: e.toString(),
        contentType: ContentType.failure,
      );
    }
  }
}
