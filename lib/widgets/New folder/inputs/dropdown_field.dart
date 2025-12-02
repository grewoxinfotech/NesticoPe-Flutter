import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../../../app/constants/ic_res.dart';
import '../../../app/constants/size_manager.dart';
import '../../display/ic.dart';

class NesticoPeDropdownField<T> extends StatelessWidget {
  final String? title;
  final dynamic value;
  final List<DropdownMenuItem<T>> items;
  final Function(dynamic) onChanged;
  final bool isRequired;
  final String? hintText;
  final IconData? prefixIcon;
  final String? Function(dynamic)? validator;
  final bool enabled;
  final FocusNode? focusNode;
  final double? width;
  final bool isMultiSelect;
  final bool showSelectedItems;
  final double fontsize;
  final FontWeight fontWight;
  final bool darkText;
  final VoidCallback? onMenuOpened;

  const NesticoPeDropdownField({
    super.key,
    this.title,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isRequired = false,
    this.hintText,

    this.prefixIcon,
    this.validator,
    this.enabled = true,
    this.focusNode,
    this.width,
    this.isMultiSelect = false,
    this.showSelectedItems = true,
    this.onMenuOpened,  this.fontsize=AppFontSizes.medium,  this.fontWight=AppFontWeights.bold,  this.darkText=false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(title != null && title!.isNotEmpty)
        Row(
          children: [
            Text(
              title!,
              style: TextStyle(
                fontSize: fontsize,
                color:darkText?ColorRes.textColor: Get.theme.colorScheme.onSecondary,
                fontWeight: fontWight,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: TextStyle(
                  color: Get.theme.colorScheme.error,
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.bold,
                ),
              ),
          ],
        ),
        AppSpacing.verticalSmall,
        if (isMultiSelect) _buildMultiSelect() else _buildSingleSelect(),
      ],
    );
  }

  Widget _buildSingleSelect() {
    // Check if the value exists in the dropdown items
    bool valueExists = false;
    if (value != null) {
      valueExists = items.any((item) => item.value == value);
    }

    // Use null if the value doesn't exist in the items
    final safeValue = valueExists ? value as T? : null;

    return DropdownButtonFormField<T>(
      initialValue: safeValue,
      borderRadius: BorderRadius.circular(AppRadius.large),
      items: items,
      onChanged: enabled ? (val) => onChanged(val) : null,
      onTap: onMenuOpened,
      validator: validator,
      focusNode: focusNode,
      style: TextStyle(
        fontSize: AppFontSizes.bodyMedium,
        color: Get.theme.colorScheme.onSurface,
        fontWeight: AppFontWeights.medium,
      ),
      decoration: _getInputDecoration(),
      isExpanded: true,
      icon: NesticoPeIc(iconPath: ICRes.down, color: Get.theme.colorScheme.primary),
      dropdownColor: Get.theme.colorScheme.surface,
      menuMaxHeight: 300,
      itemHeight: 50,
    );
  }

  Widget _buildMultiSelect() {
    final selectedValues = (value as List<T>?) ?? [];

    return FormField<List<T>>(
      initialValue: selectedValues,
      validator: validator,
      builder: (FormFieldState<List<T>> state) {
        return InputDecorator(
          decoration: _getInputDecoration(state: state),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showSelectedItems && selectedValues.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children:
                      selectedValues
                          .map(
                            (item) => Chip(
                              label: Text(item.toString()),
                              onDeleted:
                                  enabled
                                      ? () {
                                        final newValue = List<T>.from(
                                          selectedValues,
                                        )..remove(item);
                                        onChanged(newValue);
                                      }
                                      : null,
                            ),
                          )
                          .toList(),
                ),
              DropdownButton<T>(
                value: null,
                hint: Text(
                  selectedValues.isEmpty
                      ? (hintText ?? 'Select items')
                      : 'Add more',
                  style: TextStyle(
                    color: Get.theme.colorScheme.onSurface.withAlpha(128),
                  ),
                ),
                items:
                    items
                        .where((item) => !selectedValues.contains(item.value))
                        .toList(),
                onChanged:
                    enabled
                        ? (T? newValue) {
                          if (newValue != null) {
                            final newList = List<T>.from(selectedValues)
                              ..add(newValue);
                            onChanged(newList);
                            state.didChange(newList);
                          }
                        }
                        : null,
                isExpanded: true,
                icon: NesticoPeIc(
                  iconPath: ICRes.down,
                  color: Get.theme.colorScheme.primary,
                ),
                underline: const SizedBox(),
              ),
            ],
          ),
        );
      },
    );
  }

  InputDecoration _getInputDecoration({FormFieldState? state}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(AppPadding.small),
      filled: true,
      fillColor:
          enabled
              ? Get.theme.colorScheme.surface
              : Get.theme.colorScheme.surface.withAlpha(128),
      hintText: hintText,
      hintStyle: TextStyle(
        color: Get.theme.colorScheme.onSurface.withAlpha(128),
        fontSize: AppFontSizes.bodyMedium,
        fontWeight: FontWeight.w400,
      ),
      prefixIcon:
          prefixIcon != null
              ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Icon(
                  prefixIcon,
                  size: 20,
                  color: Get.theme.colorScheme.primary,
                ),
              )
              : null,
      prefixIconConstraints: const BoxConstraints(minWidth: 40),
      enabledBorder: tile(Get.theme.dividerColor),
      focusedBorder: tile(Get.theme.colorScheme.primary),
      errorBorder: tile(Get.theme.colorScheme.error),
      focusedErrorBorder: tile(Get.theme.colorScheme.error),
      errorText: state?.hasError == true ? state?.errorText : null,
      errorStyle: TextStyle(
        color: Get.theme.colorScheme.error,
        fontSize: AppFontSizes.small,
        fontWeight: AppFontWeights.medium,
      ),
    );
  }
}

InputBorder? tile(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.medium),
    borderSide: BorderSide(color: color, width: 1),
  );
}
