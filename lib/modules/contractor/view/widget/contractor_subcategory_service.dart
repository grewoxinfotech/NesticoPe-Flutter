import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/hire_contractor/controller/hire_contractor_filter_controller.dart';
import '../../../../../app/constants/app_font_sizes.dart';

class ContractorCategoryServiceExplorer extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  const ContractorCategoryServiceExplorer({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<ContractorCategoryServiceExplorer> createState() =>
      _ContractorCategoryServiceExplorerState();
}

class _ContractorCategoryServiceExplorerState extends State<ContractorCategoryServiceExplorer> {
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

  @override
  Widget build(BuildContext context) {
  final controller = Get.isRegistered<HireContractorFilterProfileController>()
    ? Get.find<HireContractorFilterProfileController>()
    : Get.put(HireContractorFilterProfileController());

    final key = _keyForMap(widget.categoryName);
    print('Category Key : $key');
    final groups = controller.getServiceNamesForCategory(key);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(fontWeight: AppFontWeights.semiBold),
        ),
      
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
                    final displayItems = items.isNotEmpty ? items : [label];
                    final isExpanded = expanded.contains(index);
                    final visibleCount =
                        isExpanded
                            ? displayItems.length
                            : (displayItems.length > 5 ? 5 : displayItems.length);
                    return Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: ColorRes.grey.withOpacity(0.2),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
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
                              ],
                            ),
                            const SizedBox(height: 20),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...List.generate(visibleCount, (i) {
                                  final item = displayItems[i];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 6),
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
                                  );
                                }),
                                if (displayItems.length > 5)
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
                                                : 'Show ${displayItems.length - 5} More',
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
