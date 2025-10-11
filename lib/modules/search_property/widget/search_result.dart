import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';
import '../../../utils/global.dart';

class CityDropdownResult extends StatefulWidget {
  final Function(int index, String city)? onCitySelected; // ✅ callback
  final String? initialCity; // ✅ optional preselected city

  const CityDropdownResult({
    super.key,
    this.onCitySelected,
    this.initialCity,
  });

  @override
  State<CityDropdownResult> createState() => _CityDropdownResultState();
}

class _CityDropdownResultState extends State<CityDropdownResult> {
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    selectedCity = widget.initialCity;
  }

  @override
  Widget build(BuildContext context) {
    final cities = popularCitiesWithAreas.keys.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.small),
      child: DropdownButtonFormField2<String>(
        value: selectedCity,
        isExpanded: false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppPadding.medium,
            vertical: AppPadding.small,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            borderSide: BorderSide(color: ColorRes.leadGreyColor.shade400, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            borderSide: const BorderSide(color: ColorRes.primary, width: 1.5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
        ),
        hint: const Text("Choose a city"),
        items: cities.map((city) {
          return DropdownMenuItem(
            value: city,
            child: buildCommonText(
              city,
              AppFontSizes.bodySmall,
              AppFontWeights.medium,
              ColorRes.textColor,
              1,
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedCity = value;
          });

          if (value != null && widget.onCitySelected != null) {
            final index = cities.indexOf(value);
            widget.onCitySelected!(index, value);
          }
        },
        dropdownStyleData: DropdownStyleData(
          maxHeight: AppSpacing.extraLarge * 6.25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.medium),
          ),
        ),
      ),
    );
  }
}

