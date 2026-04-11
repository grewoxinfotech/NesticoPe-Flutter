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

class _CategoryServiceExplorerState extends State<CategoryServiceExplorer> 
 with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Set<int> expanded = {};
  final Set<int> showAll = {};
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  String _viewAllLabel(String category, {String? sub}) {

    final cat = category.trim().toLowerCase();

    print("Category Check Any Thing: $cat  ==========   $sub");
    
    if (cat.contains('supply')) {
      return (sub != null && sub.isNotEmpty) ? '$sub Suppliers' : 'Suppliers';
    }
    if (cat.contains('interior')) {
      return (sub != null && sub.isNotEmpty) ? '$sub Designers' : 'Designers';
    }
    if (cat.contains('construction')) {
      return (sub != null && sub.isNotEmpty) ? '$sub Contractors' : 'Contractors';
    }
    if (cat.contains('legal')) {
      return (sub != null && sub.isNotEmpty) ? '$sub Experts' : 'Legal Experts';
    }
    if (cat.contains('packers')) {
      return 'Packers & Movers';
    }
    if (cat.contains('home services')) {
      return (sub != null && sub.isNotEmpty) ? '$sub Experts' : 'Service Experts';
    }
    return 'View All';
  }

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
  return AnimatedBuilder(
    animation: _controller,
    builder: (_, __) {
      
      /// 🎯 Smooth pulse scale (0.95 → 1.05)
      final scale = 0.95 + (_controller.value * 0.1);

      return Transform.scale(
        scale: scale,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: bg.withOpacity(0.15),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: bg.withOpacity(0.4)),
          ),
          child: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment(-1.5 + _controller.value * 3, 0),
                end: Alignment(-0.5 + _controller.value * 3, 0),
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.7),
                  Colors.white,
                  Colors.white.withOpacity(0.7),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 0.5, 0.6, 1.0],
              ).createShader(bounds);
            },
            child: Text(
              text.toUpperCase(),
              style: TextStyle(
                color: bg,
                fontSize: 10,
                fontWeight: AppFontWeights.bold,
                letterSpacing: .3,
              ),
            ),
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HireContractorFilterProfileController>();

    final key = _keyForMap(widget.categoryName);
    print('Category Key : $key');
    final groups = [...controller.getServiceNamesForCategory(key)]..sort((a, b) {
      final aTrend = (a['trending'] as bool?) ?? false;
      final aBest = (a['bestSelling'] as bool?) ?? false;
      final bTrend = (b['trending'] as bool?) ?? false;
      final bBest = (b['bestSelling'] as bool?) ?? false;

      final aScore = (aTrend || aBest) ? 0 : 1;
      final bScore = (bTrend || bBest) ? 0 : 1;

      return aScore.compareTo(bScore);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorRes.white,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            
            Get.back();
            controller.selectedServiceNames.clear();
            controller.selectedWorkItems.clear();
          },
        ),
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
                    final isPackersCategory =
                        widget.categoryName.trim().toLowerCase().contains('packers');
                    final isTrending = (g['trending'] as bool?) ?? false;
                    final isBestSelling = (g['bestSelling'] as bool?) ?? false;
                    final isExpanded = expanded.contains(index);
                    final visibleCount = isExpanded
                        ? (showAll.contains(index)
                            ? items.length
                            : (items.length > 5 ? 5 : items.length))
                        : 0;
                    return Obx(() {
                      final _watchSelectedItemsLen =
                          controller.selectedWorkItems.length;
                      final _watchSelectedServiceLen =
                          controller.selectedServiceNames.length;
                      final selectedCountInCard =
                          items
                              .where(
                                (item) =>
                                    controller.selectedWorkItems.contains(item),
                              )
                              .length;

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
                                          (isTrending || isBestSelling)
                                              ? 2.5
                                              : 1,
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
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isExpanded) {
                                    expanded.remove(index);
                                  } else {
                                    expanded.add(index);
                                  }
                                });
                              },
                              child: Row(
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
                                      const SizedBox(width: 6),
                                      Icon(
                                        isExpanded ? Icons.expand_less : Icons.expand_more,
                                        color: ColorRes.primary,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                              SizedBox(height: 20),

                            if (items.isEmpty && !isPackersCategory)
                              const SizedBox.shrink()
                              else
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (items.isNotEmpty) ...[
                                      ...List.generate(visibleCount, (i) {
                                        final item = items[i];
                                        final isSelected = controller
                                            .selectedWorkItems
                                            .contains(item);
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 6,
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              controller.selectedCategoryId
                                                  .value = widget.categoryId;
                                              controller.selectedCategoryName
                                                  .value = widget.categoryName;
 
                                              if (isSelected) {
                                                controller.selectedWorkItems
                                                    .remove(item);
                                              } else {
                                                controller.onServiceNameSelected(
                                                  value,
                                                  label: label,
                                                );
                                                controller.selectedWorkItems.add(
                                                  item,
                                                );
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    isSelected
                                                        ? ColorRes.primary
                                                            .withOpacity(0.05)
                                                        : ColorRes.grey
                                                            .withOpacity(0.06),
                                                border: Border.all(
                                                  color:
                                                      isSelected
                                                          ? ColorRes.primary
                                                          : ColorRes.leadGreyColor
                                                              .shade300,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    isSelected
                                                        ? Icons.check_box
                                                        : Icons
                                                            .check_box_outline_blank,
                                                    size: 18,
                                                    color:
                                                        isSelected
                                                            ? ColorRes.primary
                                                            : ColorRes
                                                                .leadGreyColor
                                                                .shade700,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      item,
                                                      style: TextStyle(
                                                        fontSize:
                                                            AppFontSizes.caption,
                                                        fontWeight:
                                                            isSelected
                                                                ? AppFontWeights
                                                                    .bold
                                                                : AppFontWeights
                                                                    .medium,
                                                        color:
                                                            isSelected
                                                                ? ColorRes.primary
                                                                : ColorRes
                                                                    .textColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                      if (isExpanded && items.length > 5)
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (showAll.contains(index)) {
                                                showAll.remove(index);
                                              } else {
                                                showAll.add(index);
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
                                                  showAll.contains(index)
                                                      ? Icons.expand_less
                                                      : Icons.expand_more,
                                                  color: ColorRes.primary,
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  showAll.contains(index)
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
                                    if (isPackersCategory || selectedCountInCard > 0)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            final filters = <String, String>{};
                                            if (controller
                                                .selectedServiceNames
                                                .isNotEmpty) {
                                              filters['serviceNames'] =
                                                  controller
                                                      .selectedServiceNames
                                                      .map((e) => e.trim())
                                                      .join(', ');
                                            }
                                            if (controller
                                                .selectedWorkItems
                                                .isNotEmpty) {
                                              filters['works'] = controller
                                                  .selectedWorkItems
                                                  .map((e) => e.trim())
                                                  .join(', ');
                                            }
                                            controller.applyFilters(filters);
                                            Get.to(
                                              () =>
                                                  const HireContractorProfileList(),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: ColorRes.primary,
                                            minimumSize: const Size(
                                              double.infinity,
                                              40,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            'View ${_viewAllLabel(widget.categoryName, sub: label )}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,

                                              fontSize: AppFontSizes.bodySmall,
                                              fontWeight: AppFontWeights.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
      ),
    );
  }
}
