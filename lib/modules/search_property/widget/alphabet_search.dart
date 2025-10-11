import 'package:alphabet_list_view/alphabet_list_view.dart';
import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';

import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';

class CityAlphabetList extends StatefulWidget {
  const CityAlphabetList({super.key, required this.letterCity});

  final Map<String, List<String>> letterCity;

  @override
  State<CityAlphabetList> createState() => _CityAlphabetListState();
}

class _CityAlphabetListState extends State<CityAlphabetList> {
  @override
  Widget build(BuildContext context) {
    final List<AlphabetListViewItemGroup> items =
        widget.letterCity.entries.map((entry) {
          return AlphabetListViewItemGroup(
            tag: entry.key,

            children:
                entry.value
                    .map<Widget>(
                      (city) => GestureDetector(
                        onTap: () {},
                        child: ListTile(
                          title: buildCommonText(
                            city,
                            AppFontSizes.bodySmall,
                            AppFontWeights.semiBold,
                            ColorRes.textColor,
                            1,
                          ),
                          subtitle: buildCommonText(
                            'Gujarat',
                            AppFontSizes.caption,
                            FontWeight.w400,
                            ColorRes.leadGreyColor.shade600,
                            1,
                          ),
                          leading: const Icon(
                            Icons.location_city,
                            color: ColorRes.blueColor,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          );
        }).toList();

    return Scaffold(
      body: AlphabetListView(
        items: items,
        scrollController: ScrollController(),
        options: AlphabetListViewOptions(
          listOptions: ListOptions(
            stickySectionHeader: false,
            listHeaderBuilder:
                (context, symbol) => Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorRes.leadGreyColor.shade200,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  alignment: const Alignment(-0.9, 0.0),
                  child: buildCommonText(
                    symbol,
                    AppFontSizes.bodyMedium,
                    AppFontWeights.medium,
                    ColorRes.textColor,
                    1,
                  ),
                ),
          ),
          scrollbarOptions: ScrollbarOptions(
            symbolBuilder: (context, symbol, state) {
              final isSelected = state == AlphabetScrollbarItemState.active;
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? ColorRes.primary : ColorRes.transparentColor,
                ),
                alignment: Alignment.center,
                child: buildCommonText(
                  symbol,
                  isSelected ? AppFontSizes.medium : AppFontSizes.small,
                  isSelected ? AppFontWeights.semiBold : AppFontWeights.regular,
                  isSelected ? ColorRes.white : ColorRes.grey,
                  1,
                ),
              );
            },
          ),

          overlayOptions: OverlayOptions(
            showOverlay: true,
            overlayBuilder:
                (context, symbol) => Container(
                  alignment: Alignment.center,
                  height: 80,
                  width: 80,
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorRes.primary.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: buildCommonText(
                    symbol,
                    AppFontSizes.displayMediumSmall,
                    AppFontWeights.medium,
                    ColorRes.textColor,
                    1,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
