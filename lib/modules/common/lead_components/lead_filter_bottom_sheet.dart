import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';

import '../../../widgets/messages/snack_bar.dart';

/// Reusable Lead Filter Bottom Sheet
/*class LeadFilterBottomSheet {
  static void show({
    required BuildContext context,
    required RxList<String> selectedFilters,
    required Function() onApplyFilters,
  }) {
    final RxList<String> tempSelectedFilters =
        <String>[...selectedFilters].obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorRes.transparentColor,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: ColorRes.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: ColorRes.leadGreyColor[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter Leads',
                        style: TextStyle(
                          fontSize: AppFontSizes.body,
                          fontWeight: AppFontWeights.semiBold,
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                tempSelectedFilters.clear();
                              });
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: ColorRes.error[400],
                            ),
                            child: Text(
                              'Clear All',
                              style: TextStyle(
                                fontWeight: AppFontWeights.medium,
                                fontSize: AppFontSizes.small,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, color: ColorRes.leadGreyColor[300]),

                // Filter content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Stage Section
                        _buildFilterSection(
                          context: context,
                          title: 'Stage',
                          icon: Icons.stairs,
                          filterType: 'Stage',
                          options: [
                            'New Lead',
                            'Contacted',
                            'Interested',
                            'Site Visit',
                            'Sell',
                          ],
                          tempSelectedFilters: tempSelectedFilters,
                          setState: setState,
                        ),

                        const SizedBox(height: 24),

                        // Status Section
                        _buildFilterSection(
                          context: context,
                          title: 'Status',
                          icon: Icons.flag,
                          filterType: 'Status',
                          options: [
                            'New',
                            'Contacted',
                            'Qualified',
                            'Negotiating',
                            'Lost',
                            'Converted',
                          ],
                          tempSelectedFilters: tempSelectedFilters,
                          setState: setState,
                        ),
                      ],
                    ),
                  ),
                ),

                // Apply button
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        selectedFilters.clear();
                        selectedFilters.addAll(tempSelectedFilters);
                        onApplyFilters();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRes.primary,
                        foregroundColor: ColorRes.white,
                        padding: const EdgeInsets.all(16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Obx(
                        () => Text(
                          'Apply Filters (${tempSelectedFilters.length})',
                          style: TextStyle(
                            fontSize: AppFontSizes.body,
                            fontWeight: AppFontWeights.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget _buildFilterSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String filterType,
    required List<String> options,
    required RxList<String> tempSelectedFilters,
    required StateSetter setState,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorRes.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: ColorRes.primary),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: AppFontSizes.bodySmall,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Filter chips
        Wrap(
          spacing: 8,
          runSpacing: -4,
          children: options.map((option) {
            return Obx(() {
              final fullFilterKey = '$filterType:$option';
              final isSelected = tempSelectedFilters.any(
                (e) => e.startsWith('$filterType:') && e == fullFilterKey,
              );

              return FilterChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (selected) {
                  tempSelectedFilters.removeWhere(
                    (e) => e.startsWith('$filterType:'),
                  );
                  if (selected) {
                    tempSelectedFilters.add(fullFilterKey);
                  }
                  setState(() {});
                },
                selectedColor: ColorRes.primary.withOpacity(0.15),
                checkmarkColor: ColorRes.primary,
                backgroundColor: ColorRes.leadGreyColor[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? ColorRes.primary
                        : ColorRes.leadGreyColor[300]!,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                labelStyle: TextStyle(
                  color: isSelected ? ColorRes.primary : ColorRes.blackShade87,
                  fontWeight: isSelected
                      ? AppFontWeights.semiBold
                      : AppFontWeights.regular,
                  fontSize: AppFontSizes.small,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              );
            });
          }).toList(),
        ),
      ],
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';

import '../../../widgets/messages/snack_bar.dart';

class LeadFilterScreen extends StatefulWidget {
  final RxList<String> selectedFilters;
  final Function() onApplyFilters;

  const LeadFilterScreen({
    super.key,
    required this.selectedFilters,
    required this.onApplyFilters,
  });

  @override
  State<LeadFilterScreen> createState() => _LeadFilterScreenState();
}

class _LeadFilterScreenState extends State<LeadFilterScreen> {
  late final RxList<String> tempSelectedFilters;

  // ✅ Date state — separate from chips, synced into tempSelectedFilters
  DateTime? startDate;
  DateTime? endDate;
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    tempSelectedFilters = <String>[...widget.selectedFilters].obs;

    // ✅ Restore previously selected dates from filter list
    for (final f in tempSelectedFilters) {
      if (f.startsWith('createdAtFrom:')) {
        startDateController.text = f.replaceFirst('createdAtFrom:', '');
      } else if (f.startsWith('createdAtTo:')) {
        endDateController.text = f.replaceFirst('createdAtTo:', '');
      }
    }
  }

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  void _clearAll() {
    setState(() {
      tempSelectedFilters.clear();
      startDate = null;
      endDate = null;
      startDateController.clear();
      endDateController.clear();
    });
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Widget _datePickerTheme(BuildContext context, Widget? child) => Theme(
    data: Theme.of(context).copyWith(
      colorScheme: ColorScheme.light(
        primary: ColorRes.primary,
        onPrimary: ColorRes.white,
        onSurface: ColorRes.black,
      ),
    ),
    child: child!,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        backgroundColor: ColorRes.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: ColorRes.textColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Filter Leads',
          style: TextStyle(
            fontSize: AppFontSizes.large,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _clearAll,
            child: Text(
              'Clear All',
              style: TextStyle(
                color: ColorRes.error,
                fontWeight: AppFontWeights.medium,
                fontSize: AppFontSizes.small,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ──────────── CREATED DATE RANGE ────────────
            _buildSectionHeader('Created Date Range', Icons.date_range),
            const SizedBox(height: 12),
            Row(
              children: [
                // Start Date
                Expanded(
                  child: _buildDateTile(
                    label: 'Start Date',
                    controller: startDateController,
                    isSelected: startDate != null,
                    onTap: () async {
                      FocusScope.of(context).unfocus();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        builder: _datePickerTheme,
                      );
                      if (picked != null) {
                        final formatted = _formatDate(picked);
                        setState(() {
                          startDate = picked;
                          startDateController.text = formatted;
                          // Clear end date if it's now before the new start
                          if (endDate != null && endDate!.isBefore(picked)) {
                            endDate = null;
                            endDateController.clear();
                            tempSelectedFilters.removeWhere(
                              (e) => e.startsWith('createdAtTo:'),
                            );
                          }
                          tempSelectedFilters.removeWhere(
                            (e) => e.startsWith('createdAtFrom:'),
                          );
                          tempSelectedFilters.add('createdAtFrom:$formatted');
                        });
                      }
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 16,
                    color: ColorRes.leadGreyColor[400],
                  ),
                ),

                // End Date
                Expanded(
                  child: _buildDateTile(
                    label: 'End Date',
                    controller: endDateController,
                    isSelected: endDate != null,
                    onTap: () async {
                      if (startDate == null) {
                        NesticoPeSnackBar.showAwesomeSnackbar(
                          title: 'Date Required',
                          message: 'Please select start date first',
                          contentType: ContentType.failure,
                        );
                        return;
                      }
                      FocusScope.of(context).unfocus();
                      final picked = await showDatePicker(
                        context: context,
                        initialDate:
                            endDate ??
                            (startDate!.isAfter(DateTime.now())
                                ? startDate!
                                : DateTime.now()),
                        firstDate: startDate!,
                        lastDate: DateTime(2100),
                        builder: _datePickerTheme,
                      );
                      if (picked != null) {
                        final formatted = _formatDate(picked);
                        setState(() {
                          endDate = picked;
                          endDateController.text = formatted;
                          tempSelectedFilters.removeWhere(
                            (e) => e.startsWith('createdAtTo:'),
                          );
                          tempSelectedFilters.add('createdAtTo:$formatted');
                        });
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ──────────── LEAD SOURCE ────────────
            _buildFilterSection(
              title: 'Lead Source',
              icon: Icons.source_outlined,
              filterType: 'source',
              options: [
                'App',
                'Website',
                'Referral',
                'Social Media',
                'Direct',
                'Other',
              ],
            ),

            const SizedBox(height: 24),

            // ──────────── STAGE ────────────
            _buildFilterSection(
              title: 'Stage',
              icon: Icons.stairs,
              filterType: 'stage',
              options: [
                'New Lead',
                'Contacted',
                'Interested',
                'Site Visit',
                'Sell',
              ],
            ),

            const SizedBox(height: 24),

            // ──────────── STATUS ────────────
            _buildFilterSection(
              title: 'Status',
              icon: Icons.flag,
              filterType: 'status',
              options: [
                'New',
                'Contacted',
                'Qualified',
                'Negotiating',
                'Lost',
                'Converted',
              ],
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),

      // ──────────── BOTTOM BUTTONS ────────────
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: ColorRes.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Cancel — discard changes, just go back
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: ColorRes.primary,
                        width: 1.5,
                      ),
                      foregroundColor: ColorRes.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: AppFontSizes.body,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Apply — commit filters and reload
                Expanded(
                  flex: 2,
                  child: Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRes.primary,
                        foregroundColor: ColorRes.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        widget.selectedFilters.clear();
                        log("Project Lead Filter issues ${tempSelectedFilters.map((element) => element,)}");
                        widget.selectedFilters.addAll(tempSelectedFilters);
                        widget.onApplyFilters();
                        tempSelectedFilters.clear();
                        Get.back();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Apply (${tempSelectedFilters.length})',
                            style: TextStyle(
                              fontSize: AppFontSizes.body,
                              fontWeight: AppFontWeights.semiBold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ──────────── SECTION HEADER ────────────
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ColorRes.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: ColorRes.primary),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: AppFontSizes.bodySmall,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textColor,
          ),
        ),
      ],
    );
  }

  // ──────────── DATE TILE ────────────
  Widget _buildDateTile({
    required String label,
    required TextEditingController controller,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? ColorRes.primary : ColorRes.leadGreyColor[300]!,
            width: isSelected ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
          color:
              isSelected ? ColorRes.primary.withOpacity(0.05) : ColorRes.white,
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color:
                  isSelected ? ColorRes.primary : ColorRes.leadGreyColor[400],
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                controller.text.isEmpty ? label : controller.text,
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  color:
                      isSelected
                          ? ColorRes.primary
                          : ColorRes.leadGreyColor[500],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────── FILTER CHIP SECTION ────────────
  // ✅ Uses ONLY tempSelectedFilters (RxList) — zero RxMap involved
  Widget _buildFilterSection({
    required String title,
    required IconData icon,
    required String filterType,
    required List<String> options,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title, icon),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              options.map((option) {
                return Obx(() {
                  // ✅ Normalize to match API format: lowercase + underscores
                  final apiValue = option.toLowerCase().replaceAll(' ', '_');
                  final filterKey = '$filterType:$apiValue';
                  final isSelected = tempSelectedFilters.contains(filterKey);

                  return FilterChip(
                    label: Text(option),
                    selected: isSelected,
                    onSelected: (selected) {
                      // ✅ RaBCHD NHSJ  BCHDNJSN NVN  NDJND  hjn dio behaviour: only one per filterType
                      tempSelectedFilters.removeWhere(
                        (e) => e.startsWith('$filterType:'),
                      );
                      if (selected) {
                        tempSelectedFilters.add(filterKey);
                      }
                    },
                    selectedColor: ColorRes.primary.withOpacity(0.15),
                    checkmarkColor: ColorRes.primary,
                    backgroundColor: ColorRes.leadGreyColor[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color:
                            isSelected
                                ? ColorRes.primary
                                : ColorRes.leadGreyColor[300]!,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    labelStyle: TextStyle(
                      color:
                          isSelected ? ColorRes.primary : ColorRes.blackShade87,
                      fontWeight:
                          isSelected
                              ? AppFontWeights.semiBold
                              : AppFontWeights.regular,
                      fontSize: AppFontSizes.small,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  );
                });
              }).toList(),
        ),
      ],
    );
  }
}
