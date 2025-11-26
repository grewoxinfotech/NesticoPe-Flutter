import 'dart:convert';
import 'package:flutter/material.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';

class FilterChipsBar extends StatelessWidget {
  final Map<String, String> filters;
  final VoidCallback onClearAll;
  final Function(String key) onRemoveFilter;
  final String Function(dynamic min, dynamic max)? priceRangeFormatter;

  const FilterChipsBar({
    super.key,
    required this.filters,
    required this.onClearAll,
    required this.onRemoveFilter,
    this.priceRangeFormatter,
  });

  @override
  Widget build(BuildContext context) {
    if (filters.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorRes.white,
        boxShadow: [
          BoxShadow(color: ColorRes.black.withOpacity(0.05), blurRadius: 2),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // CLEAR ALL BUTTON
            GestureDetector(
              onTap: onClearAll,
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ColorRes.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorRes.primary.withOpacity(0.3)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Clear All",
                      style: TextStyle(
                        fontSize: AppFontSizes.small,
                        color: ColorRes.primary,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.close, size: 16, color: ColorRes.primary),
                  ],
                ),
              ),
            ),

            // FILTER CHIPS
            ...filters.entries.map((entry) {
              final key = entry.key;
              final value = entry.value;

              if (value.toString().trim().isEmpty) {
                return const SizedBox.shrink();
              }

              String displayValue;

              try {
                final parsed = jsonDecode(value);

                if (parsed is Map &&
                    parsed.containsKey('min') &&
                    parsed.containsKey('max')) {
                  final min = parsed['min'];
                  final max = parsed['max'];

                  // Use custom formatter OR default
                  if (priceRangeFormatter != null) {
                    displayValue = priceRangeFormatter!(min, max);
                  } else {
                    displayValue = "$min - $max";
                  }
                } else {
                  displayValue = value.toString();
                }
              } catch (e) {
                displayValue = value.toString(); // Non-JSON value
              }

              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: ColorRes.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: ColorRes.primary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "$key: $displayValue",
                      style: const TextStyle(
                        fontSize: AppFontSizes.small,
                        color: ColorRes.primary,
                        fontWeight: AppFontWeights.medium,
                      ),
                    ),
                    const SizedBox(width: 6),

                    // REMOVE SINGLE FILTER
                    GestureDetector(
                      onTap: () => onRemoveFilter(key),
                      child: const Icon(
                        Icons.close,
                        size: 16,
                        color: ColorRes.primary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
