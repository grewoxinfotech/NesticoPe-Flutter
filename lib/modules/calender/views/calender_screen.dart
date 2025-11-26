import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:intl/intl.dart';
import '../controllers/calender_controller.dart';

class CalendarScreen extends StatelessWidget {
  final CalendarController controller = Get.put(CalendarController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Event'), centerTitle: true),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  controller.previousMonth();
                },
                icon: Icon(Icons.keyboard_arrow_left_rounded),
              ),
              Obx(
                () => Text(
                  "${DateFormat.MMMM().format(controller.currentDate.value)} ${controller.currentDate.value.year}",
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.nextMonth();
                },
                icon: Icon(Icons.keyboard_arrow_right_rounded),
              ),
            ],
          ),
          SizedBox(height: 12),
          Expanded(
            child: Column(
              children: [
                buildWeekDays(),
                Expanded(
                  child: Card(
                    child: PageView.builder(
                      controller: controller.pageController,
                      onPageChanged: controller.onPageChanged,
                      itemBuilder: (context, index) {
                        final date = DateTime(
                          DateTime.now().year,
                          DateTime.now().month + (index - 5000),
                          1,
                        );
                        return buildMonthGrid(date);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 70,
                          margin: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          padding: EdgeInsets.all(12),
                          child: Text("kjdhglkdfhnl", maxLines: 2),
                          decoration: BoxDecoration(
                            color: ColorRes.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: ColorRes.leadGreyColor.shade300,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Weekdays header
  Widget buildWeekDays() {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children:
          days
              .map(
                (e) => Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    alignment: Alignment.center,
                    child: Text(
                      e,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }

  // Month grid
  Widget buildMonthGrid(DateTime date) {
    final controller = Get.find<CalendarController>();
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final firstWeekday = firstDayOfMonth.weekday % 7;

    List<Widget> dayWidgets = [];

    for (int i = 0; i < firstWeekday; i++) {
      dayWidgets.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final dayDate = DateTime(date.year, date.month, day);
      dayWidgets.add(
        GestureDetector(
          onTap: () => showAddEventDialog(dayDate),
          child: Obx(() {
            final isSelected =
                controller.selectedDate.value != null &&
                DateFormat(
                      'yyyy-MM-dd',
                    ).format(controller.selectedDate.value!) ==
                    DateFormat('yyyy-MM-dd').format(dayDate);
            final hasEvent = controller.getEvents(dayDate).isNotEmpty;

            return Container(
              margin: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      "$day",
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  if (hasEvent)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      );
    }

    return GridView.count(crossAxisCount: 7, children: dayWidgets);
  }

  void showAddEventDialog(DateTime date) {
    final controller = Get.find<CalendarController>();
    controller.selectDate(date);
    final eventController = TextEditingController();

    Get.defaultDialog(
      title: "Add Event",
      content: Column(
        children: [
          Text("Date: ${DateFormat('yyyy-MM-dd').format(date)}"),
          TextField(
            controller: eventController,
            decoration: InputDecoration(hintText: "Event name"),
          ),
        ],
      ),
      textConfirm: "Add",
      textCancel: "Cancel",
      onConfirm: () {
        if (eventController.text.trim().isNotEmpty) {
          controller.addEvent(eventController.text.trim());
        }
        Get.back();
      },
    );
  }
}
