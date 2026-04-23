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
      return (sub != null && sub.isNotEmpty)
          ? '$sub Contractors'
          : 'Contractors';
    }
    if (cat.contains('legal')) {
      return (sub != null && sub.isNotEmpty) ? '$sub Experts' : 'Legal Experts';
    }
    if (cat.contains('packers')) {
      return 'Packers & Movers';
    }
    if (cat.contains('home services')) {
      return (sub != null && sub.isNotEmpty)
          ? '$sub Experts'
          : 'Service Experts';
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
              color: bg,
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
                  color: ColorRes.white,
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
    final groups = [...controller.getServiceNamesForCategory(key)]
      ..sort((a, b) {
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
                    /// 🎨 Gradient palette — cycles by index
                    final gradientPalette = [
                      [Color(0xFF00C6FF), Color(0xFF0072FF)], // sky → deep blue
                      [
                        Color(0xFFFF9A00),
                        Color(0xFFFF3D00),
                      ], // amber → orange red
                      [
                        Color(0xFF7F00FF),
                        Color(0xFFE100FF),
                      ], // purple → magenta
                      [Color(0xFF00F5A0), Color(0xFF00D9F5)], // mint → aqua
                      [Color(0xFFFF512F), Color(0xFFDD2476)], // red → pink
                      [Color(0xFFFFD200), Color(0xFF00A651)], // yellow → green
                      [Color(0xFF1FA2FF), Color(0xFF12D8FA)], // blue → cyan
                      [Color(0xFFF857A6), Color(0xFFFF5858)], // pink → coral
                    ];

                    final cardColors =
                        gradientPalette[index % gradientPalette.length];
                    final g = groups[index];
                    final label = (g['label'] as String?) ?? '';
                    final value = (g['value'] as String?) ?? label;
                    final items =
                        ((g['items'] as List?) ?? const <String>[])
                            .cast<String>();
                    final isPackersCategory = widget.categoryName
                        .trim()
                        .toLowerCase()
                        .contains('packers');
                    final isTrending = (g['trending'] as bool?) ?? false;
                    final isBestSelling = (g['bestSelling'] as bool?) ?? false;
                    final isExpanded = expanded.contains(index);
                    final visibleCount =
                        isExpanded
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
                        borderRadius: BorderRadius.circular(
                          AppRadius.mediumLarge,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppRadius.mediumLarge,
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: CardPatternPainter(
                                    color1: cardColors[0],
                                    color2: cardColors[1],
                                  ),
                                ),
                              ),

                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      cardColors[0].withOpacity(0.5), // was 0.5
                                      Color.lerp(
                                        cardColors[0],
                                        cardColors[1],
                                        0.5,
                                      )!.withOpacity(0.85),
                                      cardColors[1].withOpacity(0.5), // was 0.8
                                      // cardColors[1].withOpacity(0.9),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border:
                                      isTrending || isBestSelling
                                          ? Border.all(
                                            color:
                                                (isTrending)
                                                    ? Color(0xFF7C4DFF)
                                                    : (isBestSelling)
                                                    ? ColorRes.green
                                                    : ColorRes.grey.withOpacity(
                                                      0.2,
                                                    ),
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
                                                _badge(
                                                  'Best Selling',
                                                  ColorRes.green,
                                                ),
                                              const SizedBox(width: 6),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: ColorRes.white,
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                ),
                                                child: Icon(
                                                  isExpanded
                                                      ? Icons.expand_less
                                                      : Icons.expand_more,
                                                  color: ColorRes.primary,
                                                  size: 20,
                                                ),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                    controller
                                                            .selectedCategoryId
                                                            .value =
                                                        widget.categoryId;
                                                    controller
                                                        .selectedCategoryName
                                                        .value = widget
                                                            .categoryName;

                                                    if (isSelected) {
                                                      controller
                                                          .selectedWorkItems
                                                          .remove(item);
                                                    } else {
                                                      controller
                                                          .onServiceNameSelected(
                                                            value,
                                                            label: label,
                                                          );
                                                      controller
                                                          .selectedWorkItems
                                                          .add(item);
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 10,
                                                          vertical: 12,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          isSelected
                                                              ? ColorRes.white
                                                              : ColorRes.white
                                                                  .withOpacity(
                                                                    0.9,
                                                                  ),
                                                      border: Border.all(
                                                        color:
                                                            isSelected
                                                                ? ColorRes
                                                                    .primary
                                                                : ColorRes
                                                                    .leadGreyColor
                                                                    .shade300,
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
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
                                                                  ? ColorRes
                                                                      .primary
                                                                  : ColorRes
                                                                      .leadGreyColor
                                                                      .shade700,
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            item,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  AppFontSizes
                                                                      .caption,
                                                              fontWeight:
                                                                  isSelected
                                                                      ? AppFontWeights
                                                                          .bold
                                                                      : AppFontWeights
                                                                          .medium,
                                                              color:
                                                                  isSelected
                                                                      ? ColorRes
                                                                          .primary
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
                                                    if (showAll.contains(
                                                      index,
                                                    )) {
                                                      showAll.remove(index);
                                                    } else {
                                                      showAll.add(index);
                                                    }
                                                  });
                                                },
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 2,
                                                      ),
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 5,
                                                          vertical: 6,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: ColorRes.primary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            6,
                                                          ),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          showAll.contains(
                                                                index,
                                                              )
                                                              ? Icons
                                                                  .expand_less
                                                              : Icons
                                                                  .expand_more,
                                                          color: ColorRes.white,
                                                          size: 18,
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          showAll.contains(
                                                                index,
                                                              )
                                                              ? 'Show Less'
                                                              : 'Show ${items.length - 5} More',
                                                          style: const TextStyle(
                                                            color:
                                                                ColorRes.white,
                                                            fontWeight:
                                                                AppFontWeights
                                                                    .semiBold,
                                                            fontSize:
                                                                AppFontSizes
                                                                    .caption,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                          if (isPackersCategory ||
                                              selectedCountInCard > 0)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 12,
                                              ),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  final filters =
                                                      <String, String>{};
                                                  if (controller
                                                      .selectedServiceNames
                                                      .isNotEmpty) {
                                                    filters['serviceNames'] =
                                                        controller
                                                            .selectedServiceNames
                                                            .map(
                                                              (e) => e.trim(),
                                                            )
                                                            .join(', ');
                                                  }
                                                  if (controller
                                                      .selectedWorkItems
                                                      .isNotEmpty) {
                                                    filters['works'] =
                                                        controller
                                                            .selectedWorkItems
                                                            .map(
                                                              (e) => e.trim(),
                                                            )
                                                            .join(', ');
                                                  }
                                                  controller.applyFilters(
                                                    filters,
                                                  );
                                                  Get.to(
                                                    () =>
                                                        const HireContractorProfileList(),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      ColorRes.primary,
                                                  minimumSize: const Size(
                                                    double.infinity,
                                                    40,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                ),
                                                child: Text(
                                                  'View ${_viewAllLabel(widget.categoryName, sub: label)}',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.white,

                                                    fontSize:
                                                        AppFontSizes.bodySmall,
                                                    fontWeight:
                                                        AppFontWeights.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                  ],
                                ),
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

class CardPatternPainter extends CustomPainter {
  final Color color1;
  final Color color2;

  CardPatternPainter({required this.color1, required this.color2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    /// 🔵 Large circle — top right
    paint.color = color1.withOpacity(0.55);
    canvas.drawCircle(Offset(size.width * 0.88, size.height * 0.08), 65, paint);

    /// 🔵 Medium circle — bottom left
    paint.color = color2.withOpacity(0.50);
    canvas.drawCircle(Offset(size.width * 0.08, size.height * 0.88), 50, paint);

    /// 🔵 Small circle — center top
    paint.color = color1.withOpacity(0.40);
    canvas.drawCircle(Offset(size.width * 0.5, -10), 35, paint);

    /// 🔵 Tiny circle — bottom right
    paint.color = color2.withOpacity(0.45);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.9), 28, paint);

    /// ➖ Diagonal lines — bottom right corner
    final linePaint =
        Paint()
          ..color = Colors.white.withOpacity(0.6)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

    // for (int i = 0; i < 8; i++) {
    //   final offset = i * 16.0;
    //   canvas.drawLine(
    //     Offset(size.width - 80 + offset, size.height),
    //     Offset(size.width, size.height - 80 + offset),
    //     linePaint,
    //   );
    // }

    /// ✦ Dot grid — top left area
    final dotPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.18)
          ..style = PaintingStyle.fill;

    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        canvas.drawCircle(
          Offset(16.0 + col * 14, 16.0 + row * 14),
          2,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CardPatternPainter old) =>
      old.color1 != color1 || old.color2 != color2;
}
