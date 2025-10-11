import 'package:flutter/material.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/constants/size_manager.dart';

class FilterTagList extends StatefulWidget {
  const FilterTagList({Key? key}) : super(key: key);

  @override
  State<FilterTagList> createState() => _FilterTagListState();
}

class _FilterTagListState extends State<FilterTagList> {
  final List<String> tags = ["Buy", "Rent", "Sell", "PG", "Contractor"];
  final List<IconData> icons = [
    Icons.home,
    Icons.key,
    Icons.handshake,
    Icons.bed,
    Icons.home_repair_service_rounded,
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        itemCount: tags.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              width: 90,
              decoration: BoxDecoration(
                color: ColorRes.white, // Always white background
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: isSelected
                    ? Border.all(
                  color: ColorRes.primary,
                  width: 1.5,
                )
                    : null,
                // boxShadow: [
                //   BoxShadow(
                //     color: Color(0x1f939393),
                //     blurRadius: 6,
                //     offset: const Offset(0, 1),
                //   ),
                // ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icons[index],
                    color: isSelected
                        ? ColorRes.primary
                        : ColorRes.leadGreyColor,
                    size: 28,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tags[index],
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                      color: isSelected
                          ? ColorRes.primary
                          : ColorRes.leadGreyColor,
                      fontWeight:
                      isSelected ? AppFontWeights.bold : AppFontWeights.medium,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}