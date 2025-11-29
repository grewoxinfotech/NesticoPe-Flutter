import 'package:get/get.dart';

import '../../../data/network/property_approval_history/model/property_approval_history.dart';
import '../../../data/network/property_approval_history/service/property_apprival_service.dart';

class ApprovalHistoryController extends GetxController {
  final ApprovalHistoryService _service = ApprovalHistoryService();

  var isLoading = false.obs;
  var approvalHistory = <ApprovalHistory>[].obs;

  /// Fetch approval history for a given property ID
  Future<void> loadApprovalHistory(String propertyId) async {
    try {
      isLoading.value = true;

      final result = await _service.fetchApprovalHistory(propertyId);

      approvalHistory.assignAll(result);
    } catch (e) {
      print("Error loading approval history: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
