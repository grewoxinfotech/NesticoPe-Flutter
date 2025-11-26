import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalendarController extends GetxController {
  Rx<DateTime> currentDate = DateTime.now().obs;
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  RxMap<String, List<String>> events = <String, List<String>>{}.obs;

  // For PageView index
  PageController pageController = PageController(initialPage: 5000);

  // Select date
  void selectDate(DateTime date) {
    selectedDate.value = date;
  }

  // Add event
  void addEvent(String event) {
    if (selectedDate.value == null) return;
    final key = DateFormat('yyyy-MM-dd').format(selectedDate.value!);
    if (events.containsKey(key)) {
      events[key]!.add(event);
    } else {
      events[key] = [event];
    }
  }

  List<String> getEvents(DateTime date) {
    final key = DateFormat('yyyy-MM-dd').format(date);
    return events[key] ?? [];
  }

  // 🚀 Next Month (smooth animation)
  void nextMonth() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  // 🚀 Previous Month (smooth animation)
  void previousMonth() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  // Called when user swipes the PageView
  void onPageChanged(int page) {
    int diff = page - 5000;

    // Update the currentDate with smooth month shifting
    currentDate.value = DateTime(
      DateTime.now().year,
      DateTime.now().month + diff,
      1,
    );
  }
}
