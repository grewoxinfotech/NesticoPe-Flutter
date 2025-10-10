import 'package:flutter/material.dart';

import '../../constants/color_res.dart';
import '../../constants/size_manager.dart';

class CustomSearchAppBar extends StatelessWidget {
  const CustomSearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.only(left: 12.0, right: 12, top: 24),
        child: Column(
          children: [
            // Row 1: Search Bar + Sort Icon
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: ColorRes.leadGreyColor.shade100,
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                      border: Border.all(color: ColorRes.leadGreyColor.shade300),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: ColorRes.leadGreyColor.shade200,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_downward_outlined),
                    onPressed: () {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Row 2: Filter icon + Chips
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: ColorRes.leadGreyColor.shade200,
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('3 BHK'),
                          onSelected: (val) {},
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text('Fully Furnished'),
                          onSelected: (val) {},
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text('₹50L - ₹1Cr'),
                          onSelected: (val) {},
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text('Ready to Move'),
                          onSelected: (val) {},
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
  }
}