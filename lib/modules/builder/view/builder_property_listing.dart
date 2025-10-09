import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';

class BuilderPropertyListing extends StatelessWidget {
  const BuilderPropertyListing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('My Properties', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {},
          ),
        ],
      ),
      // body: ListView.builder(
      //   padding: const EdgeInsets.all(16),
      //   itemCount: 5,
      //   itemBuilder: (context, index) => _buildPropertyCard(index),
      // ),
    );
  }

  Widget _buildPropertyCard(int index) {
    final properties = [
      {'name': 'Skyline Tower', 'location': 'Ahmedabad', 'units': '120', 'status': 'Active'},
      {'name': 'Green Valley', 'location': 'Surat', 'units': '85', 'status': 'Sold Out'},
      {'name': 'Ocean View', 'location': 'Mumbai', 'units': '200', 'status': 'Active'},
      {'name': 'Palm Heights', 'location': 'Gandhinagar', 'units': '60', 'status': 'Under Construction'},
      {'name': 'Royal Residency', 'location': 'Rajkot', 'units': '95', 'status': 'Active'},
    ];

    final property = properties[index];
    final statusColor = property['status'] == 'Active' ? Colors.green : property['status'] == 'Sold Out' ? Colors.red : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: ColorRes.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              children: [
                Center(child: Icon(Icons.apartment_rounded, size: 60, color: ColorRes.primary.withOpacity(0.3))),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(20)),
                    child: Text(property['status']!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(property['name']!, style: TextStyle(fontSize: AppFontSizes.body, fontWeight: FontWeight.bold, color: ColorRes.textPrimary)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on_rounded, size: 16, color: ColorRes.textSecondary),
                    const SizedBox(width: 4),
                    Text(property['location']!, style: TextStyle(fontSize: AppFontSizes.small, color: ColorRes.textSecondary)),
                    const Spacer(),
                    Icon(Icons.home_rounded, size: 16, color: ColorRes.textSecondary),
                    const SizedBox(width: 4),
                    Text('${property['units']} Units', style: TextStyle(fontSize: AppFontSizes.small, color: ColorRes.textSecondary)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.visibility_rounded, size: 18),
                        label: const Text('View'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: ColorRes.primary,
                          side: BorderSide(color: ColorRes.primary.withOpacity(0.5)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.edit_rounded, size: 18),
                        label: const Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorRes.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
    );
  }
}
