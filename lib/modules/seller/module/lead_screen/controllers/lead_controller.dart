import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LeadController extends GetxController {
  final List<String> statusList = [
    'Interested',
    'New Lead',
    'Contacted',
    'Follow Up',
    'Site Visit',
    'Negotiation',
    'Closed',
    'Lost',
  ];

  RxString selectedFilterStatus = ''.obs;
  RxString selectedStatus = ''.obs;

  final List<String> leadTypeList = ["All Leads", "Residential", "Commercial"];

  RxString selectedLeadType = ''.obs;
  Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final TextEditingController dateController = TextEditingController();

  // Add notes functionality
  RxString notes = ''.obs;
  final TextEditingController notesController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadVariables();
  }

  @override
  void onClose() {
    dateController.dispose();
    notesController.dispose();
    super.onClose();
  }

  void loadVariables() {
    selectedFilterStatus.value = 'All Status'; // Changed to show all by default
    selectedLeadType.value = leadTypeList.first; // This is "All Leads"
    selectedStatus.value = statusList.first;
    dateController.text = "";
    selectedDate.value = null;
    notes.value = '';
  }

  // Method to update lead status
  void updateStatus(String newStatus) {
    if (statusList.contains(newStatus)) {
      selectedFilterStatus.value = newStatus;
    }
  }

  // Method to update lead type filter
  void updateLeadType(String newType) {
    if (leadTypeList.contains(newType)) {
      selectedLeadType.value = newType;
    }
  }

  // Method to set follow-up date and time
  void setFollowUpDateTime(DateTime dateTime) {
    selectedDate.value = dateTime;
    dateController.text = dateTime.toString();
  }

  // Method to clear follow-up date
  void clearFollowUpDate() {
    selectedDate.value = null;
    dateController.text = "";
  }

  // Method to update notes
  void updateNotes(String newNotes) {
    notes.value = newNotes;
    notesController.text = newNotes;
  }

  // Method to clear notes
  void clearNotes() {
    notes.value = '';
    notesController.text = '';
  }

  // Method to reset all filters and data
  void resetFilters() {
    selectedFilterStatus.value = statusList.first;
    selectedLeadType.value = leadTypeList.first;
  }

  // Method to check if lead has pending follow-up
  bool hasUpcomingFollowUp() {
    if (selectedDate.value == null) return false;
    return selectedDate.value!.isAfter(DateTime.now());
  }

  // Method to check if follow-up is overdue
  bool isFollowUpOverdue() {
    if (selectedDate.value == null) return false;
    return selectedDate.value!.isBefore(DateTime.now());
  }

  // Method to get formatted follow-up date
  String getFormattedFollowUpDate() {
    if (selectedDate.value == null) return "No follow-up set";
    return dateController.text;
  }

  // Method to validate if all required fields are filled
  bool isValid() {
    return selectedFilterStatus.value.isNotEmpty;
  }
}
