import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/modules/hire_contractor/controller/hire_contractor_filter_controller.dart';
import 'package:nesticope_app/modules/hire_contractor/view/widget/hire_contractor_profilelist.dart';
import '../../../../../app/constants/app_font_sizes.dart';

class CategoryServiceExplorer extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const CategoryServiceExplorer({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryServiceExplorer> createState() =>
      _CategoryServiceExplorerState();
}

class _CategoryServiceExplorerState extends State<CategoryServiceExplorer> {
  final Set<int> expanded = {};

  String _keyForMap(String name) {
    return name
        .trim()
        .toLowerCase()
        .replaceAll('/', ' ')
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '_');
  }

  Widget _badge(String text, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg.withOpacity(0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: bg.withOpacity(0.4)),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          color: bg,
          fontSize: 10,
          fontWeight: AppFontWeights.bold,
          letterSpacing: .3,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HireContractorFilterProfileController>();

    final key = _keyForMap(widget.categoryName);
    print('Category Key : $key');
    final groups = controller.getServiceNamesForCategory(key);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorRes.white,
        title: Text(
          widget.categoryName,
          style: const TextStyle(fontWeight: AppFontWeights.semiBold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.selectedCategoryId.value = widget.categoryId;
              controller.selectedCategoryName.value = widget.categoryName;
              controller.selectedServiceNames.clear();
              controller.selectedWorkItems.clear();
              controller.workItemOptions.clear();
              controller.applyFilters(<String, String>{});
              Get.to(() => const HireContractorProfileList());
            },

            child: const Text('View All'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child:
            groups.isEmpty
                ? Center(
                  child: Text(
                    'No services available',
                    style: TextStyle(color: ColorRes.textSecondary),
                  ),
                )
                : ListView.separated(
                  itemCount: groups.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final g = groups[index];
                    final label = (g['label'] as String?) ?? '';
                    final value = (g['value'] as String?) ?? label;
                    final items =
                        ((g['items'] as List?) ?? const <String>[])
                            .cast<String>();
                    final isTrending = (g['trending'] as bool?) ?? false;
                    final isBestSelling = (g['bestSelling'] as bool?) ?? false;
                    final isExpanded = expanded.contains(index);
                    final visibleCount =
                        isExpanded
                            ? items.length
                            : (items.length > 5 ? 5 : items.length);
                    return Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        AppRadius.mediumLarge,
                      ),
                      child: Container(

                        decoration: BoxDecoration(
                          color: ColorRes.white,
                          border:
                              isTrending || isBestSelling
                                  ? Border.all(
                                    color:
                                        (isTrending)
                                            ? Color(0xFF7C4DFF)
                                            : (isBestSelling)
                                            ? ColorRes.green
                                            : ColorRes.grey.withOpacity(0.2),
                                    width:
                                        (isTrending || isBestSelling) ? 2.5 : 1,
                                  )
                                  : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 2,
                              offset: const Offset(2, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(
                            AppRadius.mediumLarge,
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    label,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: AppFontSizes.medium,
                                      fontWeight: AppFontWeights.bold,
                                      color: ColorRes.textColor,
                                    ),
                                  ),
                                ),
                                if (isTrending || isBestSelling)
                                  Row(
                                    children: [
                                      if (isTrending)
                                        _badge(
                                          'Trending',
                                          const Color(0xFF7C4DFF),
                                        ),
                                      if (isTrending && isBestSelling)
                                        const SizedBox(width: 6),
                                      if (isBestSelling)
                                        _badge('Best Selling', ColorRes.green),
                                    ],
                                  ),
                              ],
                            ),
                            SizedBox(height: 20),

                            if (items.isEmpty)
                              Center(
                                child: InkWell(
                                  onTap: () {
                                    controller.selectedCategoryId.value =
                                        widget.categoryId;
                                    controller.selectedCategoryName.value =
                                        widget.categoryName;
                                    controller.selectedServiceNames.clear();
                                    controller.selectedWorkItems.clear();
                                    controller.workItemOptions.clear();

                                    controller.onServiceNameSelected(
                                      value,
                                      label: label,
                                    );

                                    controller.applyFilters({
                                      'serviceNames': label,
                                    });

                                    Get.to(
                                      () => const HireContractorProfileList(),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: ColorRes.primary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: const [
                                        Text(
                                          'View Contractors',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: AppFontSizes.caption,
                                            fontWeight: AppFontWeights.semiBold,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Icon(
                                          Icons.check_circle,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            else
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...List.generate(visibleCount, (i) {
                                    final item = items[i];
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 6),
                                      child: InkWell(
                                        onTap: () {
                                          controller.selectedCategoryId.value =
                                              widget.categoryId;
                                          controller
                                              .selectedCategoryName
                                              .value = widget.categoryName;
                                          controller.selectedServiceNames
                                              .clear();
                                          controller.selectedWorkItems.clear();
                                          controller.workItemOptions.clear();
                                          controller.onServiceNameSelected(
                                            value,
                                            label: label,
                                          );
                                          controller.selectedWorkItems.add(
                                            item,
                                          );
                                          controller.applyFilters({
                                            'serviceNames': label,
                                            'works': item,
                                          });
                                          Get.to(
                                            () =>
                                                const HireContractorProfileList(),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: ColorRes.grey.withOpacity(
                                              0.06,
                                            ),
                                            border: Border.all(
                                              color:
                                                  ColorRes
                                                      .leadGreyColor
                                                      .shade300,
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                size: 14,
                                                color:
                                                    ColorRes
                                                        .leadGreyColor
                                                        .shade700,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Text(
                                                  item,

                                                  style: const TextStyle(
                                                    fontSize:
                                                        AppFontSizes.caption,
                                                    fontWeight:
                                                        AppFontWeights.medium,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  if (items.length > 5)
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (isExpanded) {
                                            expanded.remove(index);
                                          } else {
                                            expanded.add(index);
                                          }
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(6),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 4,
                                          horizontal: 2,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              isExpanded
                                                  ? Icons.expand_less
                                                  : Icons.expand_more,
                                              color: ColorRes.primary,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              isExpanded
                                                  ? 'Show Less'
                                                  : 'Show ${items.length - 5} More',
                                              style: const TextStyle(
                                                color: ColorRes.primary,
                                                fontWeight:
                                                    AppFontWeights.semiBold,
                                                fontSize: AppFontSizes.small,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
