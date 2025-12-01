import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/utils/validation.dart';
import '../../../../data/network/calender/model/calender_category_model.dart';
import '../../../../data/network/calender/model/calender_model.dart';
import '../../../../widgets/New folder/inputs/text_field.dart';
import '../../../../widgets/button/button.dart';
import '../../../../widgets/dialog/delete_confirmation_dialog.dart';
import '../../controllers/calender_event_category_controller.dart';
import '../../controllers/calender_event_controller.dart';

final CalenderCategoryController _categoryController = Get.put(
  CalenderCategoryController(),
);

// void showAddEventDialog({DateTime? date}) {
//   final eventController = Get.find<CalenderEventController>();
//
//   // Text controllers
//   final titleCtrl = TextEditingController();
//   final detailsCtrl = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final dropdownKey = GlobalKey<_CustomDropdownWithAddState>();
//   // Selected values
//   Rx<DateTime> selectedDate = (date ?? DateTime.now()).obs;
//
//   Get.dialog(
//     Dialog(
//       backgroundColor: ColorRes.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Container(
//         constraints: BoxConstraints(
//           maxHeight: Get.height * 0.8, // Maximum 80% of screen
//           maxWidth: Get.width * 0.9,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Dialog Title
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 "Add Event",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//             ),
//
//             // Scrollable Content
//             Flexible(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // ------------------ TITLE -------------------
//                       NesticoPeTextField(
//                         title: "Title",
//                         hintText: "Enter title...",
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         validator: (value) => requiredField(value, 'Title'),
//                         controller: titleCtrl,
//                       ),
//                       const SizedBox(height: 12),
//
//                       // ------------------ DATE PICKER -------------------
//                       DatePickerTextField(
//                         title: "Date",
//                         hintText: "Select date",
//                         selectedDate: selectedDate,
//                         onDatePicked: (d) {},
//                       ),
//
//                       const SizedBox(height: 12),
//
//                       // ------------------ CATEGORY DROPDOWN -------------------
//                       Obx(() {
//                         return CustomDropdownWithAdd<CalenderCategoryModel>(
//                           key: dropdownKey,
//                           title: "Category",
//                           hintText: "Select category",
//                           value: eventController.selectedCategory.value,
//                           items: eventController.categories,
//                           itemBuilder:
//                               (c) => Row(
//                                 children: [
//                                   Expanded(
//                                     child: Text(
//                                       c.name ?? "-",
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                   if (c.createdBy.toLowerCase() != 'system')
//                                     Row(
//                                       children: [
//                                         GestureDetector(
//                                           onTap: () async {
//                                             dropdownKey.currentState
//                                                 ?.closeDropdown();
//                                             final category =
//                                                 await openAddCategoryDialog(
//                                                   initialText: c.name,
//                                                   isEdit: true,
//                                                 );
//                                             if (category != null) {
//                                               c.name = category;
//                                               await _categoryController
//                                                   .updateCategory(c);
//                                               await eventController
//                                                   .loadCategories();
//                                               eventController
//                                                   .selectedCategory
//                                                   .value = eventController
//                                                   .categories
//                                                   .firstWhereOrNull(
//                                                     (element) =>
//                                                         element.name ==
//                                                         category,
//                                                   );
//                                             }
//                                           },
//                                           child: Icon(
//                                             Icons.edit_outlined,
//                                             color: ColorRes.primary,
//                                           ),
//                                         ),
//                                         SizedBox(width: 10),
//                                         GestureDetector(
//                                           onTap: () {
//                                             dropdownKey.currentState
//                                                 ?.closeDropdown();
//
//                                             showDeleteConfirmationDialog(
//                                               onConfirm: () async {
//                                                 // 1️⃣ If deleting selected category → switch to another one first
//                                                 if (eventController
//                                                         .selectedCategory
//                                                         .value ==
//                                                     c) {
//                                                   if (eventController
//                                                           .categories
//                                                           .length >
//                                                       1) {
//                                                     eventController
//                                                         .selectedCategory
//                                                         .value = eventController
//                                                         .categories
//                                                         .firstWhere(
//                                                           (item) =>
//                                                               item.id != c.id,
//                                                         );
//                                                   } else {
//                                                     // only one category exists
//                                                     eventController
//                                                         .selectedCategory
//                                                         .value = null;
//                                                   }
//                                                 }
//
//                                                 // 2️⃣ Call API and delete category
//                                                 await _categoryController
//                                                     .deleteCategory(c.id);
//
//                                                 // 3️⃣ Remove from list
//                                                 eventController.categories
//                                                     .removeWhere(
//                                                       (x) => x.id == c.id,
//                                                     );
//                                               },
//                                               title: 'Delete',
//                                               message:
//                                                   "Are you sure to delete \"${c.name}\" category?",
//                                               confirmText: 'Delete',
//                                               cancelText: 'Cancel',
//                                               confirmColor: ColorRes.error,
//                                             );
//                                           },
//                                           child: Icon(
//                                             Icons.delete_outline,
//                                             color: ColorRes.error,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                 ],
//                               ),
//                           onChanged: (value) {
//                             eventController.selectedCategory.value = value;
//                           },
//                           onAddPressed: () async {
//                             final category = await openAddCategoryDialog();
//                             if (category != null) {
//                               final categoryController =
//                                   Get.find<CalenderCategoryController>();
//                               await categoryController.addCategory(category);
//                               await eventController.loadCategories();
//                               eventController.selectedCategory.value =
//                                   eventController.categories.firstWhereOrNull(
//                                     (element) => element.name == category,
//                                   );
//                             }
//                           },
//                         );
//                       }),
//
//                       const SizedBox(height: 12),
//
//                       // ------------------ DETAILS FIELD -------------------
//                       NesticoPeTextField(
//                         title: "Details",
//                         hintText: "Enter details...",
//                         autovalidateMode: AutovalidateMode.onUserInteraction,
//                         validator: (value) => requiredField(value, 'Title'),
//                         maxLines: 3,
//                         controller: detailsCtrl,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//             // Action Buttons
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextButton(
//                       onPressed: () {
//                         Get.back();
//                       },
//                       child: Text('Cancel'),
//                     ),
//                   ),
//                   Expanded(
//                     child: NesticoPeButton(
//                       title: 'Add',
//                       onTap: () async {
//                         if (!_formKey.currentState!.validate()) {
//                           return;
//                         }
//
//                         final newEvent = CalenderEventModel(
//                           title: titleCtrl.text.trim(),
//                           date: selectedDate.value.toString(),
//                           categoryId:
//                               eventController.selectedCategory.value!.id,
//                           details: detailsCtrl.text.trim(),
//                         );
//
//                         final result = await eventController.addEvent(newEvent);
//                         if (result) Get.back();
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//     barrierDismissible: false,
//   );
// }

void showEventDialog({CalenderEventModel? event, bool isEdit = false}) {
  final eventController = Get.find<CalenderEventController>();
  final categoryController = Get.find<CalenderCategoryController>();

  // Text controllers
  final titleCtrl = TextEditingController(text: event?.title ?? '');
  final detailsCtrl = TextEditingController(text: event?.details ?? '');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final dropdownKey = GlobalKey<_CustomDropdownWithAddState>();

  // Selected category
  Rx<CalenderCategoryModel?> selectedCategory =
      (event != null
              ? eventController.categories.firstWhereOrNull(
                (c) => c.id == event.categoryId,
              )
              : eventController.selectedCategory.value)
          .obs;

  // Selected date
  Rx<DateTime> selectedDate =
      (event != null
              ? DateTime.tryParse(event.date ?? '') ?? DateTime.now()
              : DateTime.now())
          .obs;

  Get.dialog(
    Dialog(
      backgroundColor: ColorRes.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.8,
          maxWidth: Get.width * 1,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Dialog Title
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: ColorRes.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 230,
                      child: Text(
                        isEdit ? "Edit Event" : "Add Event",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: AppFontSizes.body,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.white
                        ),
                      ),
                    ),
                    Spacer(),
                    InkWell(onTap: () => Get.back(),child: Icon(Icons.close, color: ColorRes.white, size: 20)),
                  ],
                ),
              ),
            ),

            // Scrollable Form
            Flexible(
              child: SingleChildScrollView(
                padding:  EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ------------------ TITLE -------------------
                      NesticoPeTextField(
                        title: "Title",
                        hintText: "Enter title...",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => requiredField(value, 'Title'),
                        controller: titleCtrl,
                      ),
                      const SizedBox(height: 12),

                      // ------------------ DATE PICKER -------------------
                      DatePickerTextField(
                        title: "Date",
                        hintText: "Select date",
                        selectedDate: selectedDate,
                        onDatePicked: (d) {},
                      ),
                      const SizedBox(height: 12),

                      // ------------------ CATEGORY DROPDOWN -------------------
                      Obx(() {
                        return CustomDropdownWithAdd<CalenderCategoryModel>(
                          key: dropdownKey,
                          title: "Category",

                          hintText: "Select category",

                          value: selectedCategory.value,

                          items: eventController.categories,
                          itemBuilder:
                              (c) => Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      c.name ?? "-",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: AppFontSizes.bodySmall,
                                        color: Get.theme.colorScheme.onSurface,
                                        fontWeight: AppFontWeights.medium,
                                      ),
                                    ),
                                  ),
                                  if (c.createdBy.toLowerCase() != 'system')
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            dropdownKey.currentState
                                                ?.closeDropdown();
                                            final category =
                                                await openAddCategoryDialog(
                                                  initialText: c.name,
                                                  isEdit: true,
                                                );
                                            if (category != null) {
                                              c.name = category;
                                              await categoryController
                                                  .updateCategory(c);
                                              await eventController
                                                  .loadCategories();
                                              selectedCategory
                                                  .value = eventController
                                                  .categories
                                                  .firstWhereOrNull(
                                                    (element) =>
                                                        element.name ==
                                                        category,
                                                  );
                                            }
                                          },
                                          child: Icon(
                                            Icons.edit_outlined,
                                            color: ColorRes.primary,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            dropdownKey.currentState
                                                ?.closeDropdown();
                                            showDeleteConfirmationDialog(
                                              title: 'Delete',
                                              message:
                                                  "Are you sure to delete \"${c.name}\" category?",
                                              confirmText: 'Delete',
                                              cancelText: 'Cancel',
                                              confirmColor: ColorRes.error,
                                              onConfirm: () async {
                                                if (selectedCategory.value ==
                                                    c) {
                                                  selectedCategory
                                                      .value = eventController
                                                      .categories
                                                      .firstWhereOrNull(
                                                        (item) =>
                                                            item.id != c.id,
                                                      );
                                                }
                                                await categoryController
                                                    .deleteCategory(c.id);
                                                eventController.categories
                                                    .removeWhere(
                                                      (x) => x.id == c.id,
                                                    );
                                              },
                                            );
                                          },
                                          child: Icon(
                                            Icons.delete_outline,
                                            color: ColorRes.error,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                          onChanged: (value) {
                            selectedCategory.value = value;
                          },
                          onAddPressed: () async {
                            final category = await openAddCategoryDialog();
                            if (category != null) {
                              await categoryController.addCategory(category);
                              await eventController.loadCategories();
                              selectedCategory.value = eventController
                                  .categories
                                  .firstWhereOrNull(
                                    (element) => element.name == category,
                                  );
                            }
                          },
                        );
                      }),
                      const SizedBox(height: 12),

                      // ------------------ DETAILS -------------------
                      NesticoPeTextField(
                        title: "Details",
                        hintText: "Enter details...",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => requiredField(value, 'Details'),
                        maxLines: 3,
                        controller: detailsCtrl,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  Expanded(
                    child: NesticoPeButton(
                      title: isEdit ? 'Update' : 'Add',
                      onTap: () async {
                        if (!_formKey.currentState!.validate()) return;

                        final newEvent = CalenderEventModel(
                          id: event?.id ?? '', // keep id for edit
                          title: titleCtrl.text.trim(),
                          date: selectedDate.value.toString(),
                          categoryId: selectedCategory.value?.id,
                          details: detailsCtrl.text.trim(),
                        );

                        if (isEdit) {
                          await eventController.updateEvent(newEvent);
                        } else {
                          await eventController.addEvent(newEvent);
                        }

                        Get.back();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
Future<String?> openAddCategoryDialog({
  String? initialText,
  bool isEdit = false,
}) async {
  final TextEditingController textCtrl = TextEditingController(
    text: initialText ?? "",
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  return await Get.dialog<String?>(
    Dialog(
      backgroundColor: ColorRes.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: BoxConstraints(maxWidth: 400),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: ColorRes.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    isEdit ? "Edit Category" : "Add Category",
                    style: TextStyle(
                      fontSize: AppFontSizes.body,
                      color: ColorRes.white,
                      fontWeight: AppFontWeights.semiBold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Text Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: NesticoPeTextField(
                  title: "Category Name",
                  hintText: "Enter category name...",
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => requiredField(value, 'Category'),
                  controller: textCtrl,

                ),
              ),
              // SizedBox(height: 24),

              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Cancel Button
                    TextButton(
                      onPressed: () => Get.back(result: null),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: AppFontSizes.medium,
                          color: Colors.grey[600],
                          fontWeight: AppFontWeights.medium,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),

                    // Confirm Button
                    ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          final text = textCtrl.text.trim();
                          if (text.isNotEmpty) {
                            Get.back(result: text);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRes.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        isEdit ? "Update" : "Add",
                        style: TextStyle(
                          fontSize: AppFontSizes.medium,
                          fontWeight: AppFontWeights.semiBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
// Future<String?> openAddCategoryDialog({
//   String? initialText,
//   bool isEdit = false,
// }) async {
//   final TextEditingController textCtrl = TextEditingController(
//     text: initialText ?? "",
//   );
//
//   return await Get.defaultDialog<String?>(
//     titleStyle:  TextStyle(
//     fontSize: AppFontSizes.large,
//     color: ColorRes.textColor,
//     fontWeight: AppFontWeights.medium,
//   ),
//     title: isEdit ? "Edit Category" : "Add Category",
//
//     barrierDismissible: false,
//     content: Padding(
//       padding:  EdgeInsets.all(8),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           NesticoPeTextField(
//             title: "New Category",
//             hintText: "Enter category name...",
//             autovalidateMode: AutovalidateMode.onUserInteraction,
//             validator: (value) => requiredField(value, 'Category'),
//             controller: textCtrl,
//           ),
//         ],
//       ),
//     ),
//     textConfirm: isEdit ? "Update" : "Add",
//     textCancel: "Cancel",
//
//     onConfirm: () {
//
//       final text = textCtrl.text.trim();
//       if (text.isEmpty) {
//         Get.snackbar("Error", "Please enter category name");
//         return;
//       }
//       Get.back(result: text); // return text
//     },
//     /*onCancel: () {
//       Get.back(result: null); // return nothing
//     },*/
//   );
// }
// make this ui perfect for add category
class DatePickerTextField extends StatelessWidget {
  final String title;
  final String hintText;
  final Rx<DateTime> selectedDate;
  final Function(DateTime) onDatePicked;

  const DatePickerTextField({
    super.key,
    required this.title,
    required this.hintText,
    required this.selectedDate,
    required this.onDatePicked,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return InkWell(
        onTap: () async {
          final picked = await showDatePicker(
            context: context,

            initialDate: selectedDate.value,
            firstDate: DateTime.now(),
            lastDate: DateTime(2050),
          );
          if (picked != null) {
            selectedDate.value = picked;
            onDatePicked(picked);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textColor
                  ),
                ),
              ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                border: Border.all(color: ColorRes.leadGreyColor.shade200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 18,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    DateFormat("dd-MM-yyyy").format(selectedDate.value),
                    style: TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                      color: Get.theme.colorScheme.onSurface,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class CustomDropdownWithAdd<T> extends StatefulWidget {
  final String title;
  final String hintText;
  final T? value;
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final Function(T?) onChanged;
  final VoidCallback onAddPressed;

  const CustomDropdownWithAdd({
    super.key,
    required this.title,
    required this.hintText,
    required this.value,
    required this.items,
    required this.itemBuilder,
    required this.onChanged,
    required this.onAddPressed,
  });

  @override
  State<CustomDropdownWithAdd<T>> createState() =>
      _CustomDropdownWithAddState<T>();
}

class _CustomDropdownWithAddState<T> extends State<CustomDropdownWithAdd<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool isOpen = false;

  // Public method to close dropdown - can be called via GlobalKey
  void closeDropdown() {
    if (!isOpen) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() => isOpen = false);
    }
  }

  void toggleDropdown() {
    if (isOpen) {
      closeDropdown();
    } else {
      openDropdown();
    }
  }

  void openDropdown() {
    _overlayEntry = _createOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => isOpen = true);
  }

  OverlayEntry _createOverlay() {
    RenderBox box = context.findRenderObject() as RenderBox;
    final size = box.size;
    final offset = box.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate height for 4 items (each item ~48px + padding)
    const itemHeight = 48.0;
    const maxItems = 4;
    const addButtonHeight = 50.0;
    final dropdownHeight =
        (itemHeight * maxItems) + addButtonHeight + 16; // 16 for padding

    // Calculate available space below and above
    final spaceBelow = screenHeight - offset.dy - size.height;
    final spaceAbove = offset.dy;
    final showAbove = spaceBelow < dropdownHeight && spaceAbove > spaceBelow;

    return OverlayEntry(
      builder:
          (context) => GestureDetector(
            onTap: closeDropdown,
            behavior: HitTestBehavior.translucent,
            child: Stack(
              children: [
                Positioned(
                  width: size.width,
                  child: CompositedTransformFollower(
                    link: _layerLink,
                    showWhenUnlinked: false,
                    offset:
                        showAbove
                            ? Offset(0, -250 - 6) // Show above
                            : Offset(0, size.height + 6), // Show below
                    child: Material(
                      elevation: 8,
                      borderRadius: BorderRadius.circular(12),
                      shadowColor: Colors.black26,
                      child: Container(
                        constraints: BoxConstraints(maxHeight: dropdownHeight),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.shade200,
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Items List
                              if (widget.items.isNotEmpty)
                                Flexible(
                                  child: ListView.separated(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    shrinkWrap: true,
                                    itemCount: widget.items.length,
                                    separatorBuilder:
                                        (_, __) => Divider(
                                          height: 1,
                                          indent: 12,
                                          endIndent: 12,
                                          color: Colors.grey.shade200,
                                        ),
                                    itemBuilder: (context, index) {
                                      final item = widget.items[index];
                                      final isSelected = widget.value == item;

                                      return InkWell(
                                        onTap: () {
                                          widget.onChanged(item);
                                          closeDropdown();
                                        },
                                        child: Container(
                                          height: itemHeight,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          alignment: Alignment.centerLeft,
                                          color:
                                              isSelected
                                                  ? Colors.blue.shade50
                                                  : Colors.transparent,
                                          child: widget.itemBuilder(item),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                              // Empty State
                              if (widget.items.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    "No categories available",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),

                              // Divider before Add button
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.grey.shade300,
                              ),

                              // Add New Button
                              InkWell(
                                onTap: () {
                                  closeDropdown();
                                  widget.onAddPressed();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline,
                                        color: ColorRes.primary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        "Add New Category",
                                        style: TextStyle(
                                          color: ColorRes.primary,
                                          fontWeight: AppFontWeights.semiBold,
                                          fontSize: AppFontSizes.medium,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Label
          Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),

          // Dropdown Field
          InkWell(
            onTap: toggleDropdown,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: isOpen ? Colors.blue.shade400 : Colors.grey.shade300,
                  width: isOpen ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.value != null
                          ? (widget.value as dynamic).name ?? ""
                          : widget.hintText,
                      style: TextStyle(
                        color:
                            widget.value == null
                                ? Colors.grey.shade500
                                :  Get.theme.colorScheme.onSurface,
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight:
                            widget.value == null
                                ?  AppFontWeights.medium
                                : AppFontWeights.medium,
                      ),
                    ),
                  ),
                  Icon(
                    isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: isOpen ? Colors.blue.shade400 : Colors.grey.shade600,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
