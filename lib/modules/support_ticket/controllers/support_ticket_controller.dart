import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/app/services/image_picker_helper.dart';
import 'package:housing_flutter_app/app/widgets/snackbar/snackbar.dart';
import 'package:housing_flutter_app/data/network/support_ticket/service/ticket_service/support_ticket_service.dart';

import '../../../data/network/support_ticket/models/ticket_model/support_ticket_model.dart';
import '../../../widgets/messages/snack_bar.dart';

// Controller using GetX
class SupportTicketController extends PaginatedController<TicketItem> {
  var selectedTab = 'All'.obs;

  // Form Key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text Editing Controllers
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  // Dropdown Values
  final selectedCategory = ''.obs;
  final selectedTicketType = ''.obs;

  // final selectedPriority = ''.obs;
  final Rx<File> pickedImages = Rx<File>(File(""));

  // Dropdown Data
  final categories =
      [
        "misleading_info",
        "property_issue",
        "payment_dispute",
        "reseller_behaviour",
        "other",
      ].obs;
  final ticketTypes =
      [
        "complaint",
        "maintenance",
        "repair",
        "installation",
        "inspection",
        "custom",
      ].obs;
  final priorities = ["low", "medium", "high", "critical"].obs;

  final _service = TicketService();
  RxMap<String, String> filters = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  @override
  Future<PaginationResponse<TicketItem>> fetchItems(int page) async {
    try {
      final response = await _service.fetchTickets(
        page: page,
        filters: filters,
      );

      return response;
    } catch (e) {
      print("Exception in fetchItems: $e");
      rethrow;
    }
  }

  /// Create a new ticket
  Future<void> submitTicket({TicketCreateRequest? payload}) async {
    try {
      isLoading.value = true;

      if (payload == null) {
        if (!formKey.currentState!.validate()) {
          return;
        }
      }

      final ticket =
          payload != null
              ? payload
              : TicketCreateRequest(
                title: titleController.text,
                description: descriptionController.text,
                category: selectedCategory.value,
                ticketType: selectedTicketType.value,
                // priority: selectedPriority.value,
              );

      final success = await _service.createTicket(ticket, pickedImages.value);
      if (success) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: "Success",
          message: "Ticket created successfully",
          contentType: ContentType.success,
        );
        resetFormField();
        refreshList();
        Get.back();
      }
    } catch (e) {
      print("Exception in submitTicket: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void resetFormField() {
    titleController.clear();
    descriptionController.clear();
    selectedCategory.value = categories.first;
    selectedTicketType.value = ticketTypes.first;
    // selectedPriority.value = priorities.first;
    pickedImages.value = File('');
  }

  Future<void> pickImage() async {
    final images = await pickImagesUsingImagePicker(1);

    if (images.isNotEmpty) {
      final img = images.first; // ImageFile

      // Convert to File
      final file = await uint8ListToFile(img.bytes!, img.name);

      if (pickedImages.value.path.isNotEmpty) {
        final maxSize = 5 * 1024 * 1024; // 5 MB
        if (pickedImages.value.lengthSync() > maxSize) {
          NesticoPeSnackBar.showAwesomeSnackbar(
            title: 'Error',
            message: 'Image size should be less than 5 MB',
            contentType: ContentType.failure,
          );
          return;
        }
      }

      pickedImages.value = file;
    }
  }

  Future<void> clearImage() async {
    pickedImages.value = File('');
  }

  // Filter tickets by selected tab
  // List<TicketItem> get filteredTickets {
  //   if (selectedTab.value == 'All') return items;
  //   return items.where((t) => t.status == selectedTab.value).toList();
  // }
}
