import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';

class BuilderLeads extends StatelessWidget {
  const BuilderLeads({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Leads', style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: ColorRes.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
        ],
      ),
      // body: Column(
      //   children: [
      //     Container(
      //       color: ColorRes.white,
      //       padding: const EdgeInsets.all(16),
      //       child: Row(
      //         children: [
      //           Expanded(child: _buildStatusChip('All', 156, true)),
      //           const SizedBox(width: 8),
      //           Expanded(child: _buildStatusChip('New', 45, false)),
      //           const SizedBox(width: 8),
      //           Expanded(child: _buildStatusChip('Hot', 23, false)),
      //         ],
      //       ),
      //     ),
      //     Expanded(
      //       child: ListView.builder(
      //         padding: const EdgeInsets.all(16),
      //         itemCount: 8,
      //         itemBuilder: (context, index) => _buildLeadCard(index),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildStatusChip(String label, int count, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? ColorRes.primary : Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text('$count', style: TextStyle(fontSize: AppFontSizes.body, fontWeight: FontWeight.bold, color: isSelected ? ColorRes.white : ColorRes.textPrimary)),
          Text(label, style: TextStyle(fontSize: AppFontSizes.small, color: isSelected ? ColorRes.white.withOpacity(0.9) : ColorRes.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildLeadCard(int index) {
    final leads = [
      {'name': 'Rajesh Kumar', 'property': 'Skyline Tower', 'budget': '₹85L', 'status': 'Hot'},
      {'name': 'Priya Shah', 'property': 'Green Valley', 'budget': '₹1.2Cr', 'status': 'New'},
      {'name': 'Amit Patel', 'property': 'Ocean View', 'budget': '₹95L', 'status': 'Hot'},
      {'name': 'Sneha Modi', 'property': 'Palm Heights', 'budget': '₹75L', 'status': 'Warm'},
      {'name': 'Karan Desai', 'property': 'Royal Residency', 'budget': '₹1.5Cr', 'status': 'Hot'},
      {'name': 'Neha Joshi', 'property': 'Skyline Tower', 'budget': '₹90L', 'status': 'New'},
      {'name': 'Vikas Sharma', 'property': 'Green Valley', 'budget': '₹1.1Cr', 'status': 'Warm'},
      {'name': 'Ritu Mehta', 'property': 'Ocean View', 'budget': '₹80L', 'status': 'New'},
    ];

    final lead = leads[index];
    final statusColor = lead['status'] == 'Hot' ? Colors.red : lead['status'] == 'New' ? Colors.blue : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: ColorRes.primary.withOpacity(0.1),
            child: Text(lead['name']![0], style: TextStyle(fontSize: AppFontSizes.large, fontWeight: FontWeight.bold, color: ColorRes.primary)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(lead['name']!, style: TextStyle(fontSize: AppFontSizes.bodySmall, fontWeight: FontWeight.bold, color: ColorRes.textPrimary))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: Text(lead['status']!, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor)),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.apartment_rounded, size: 14, color: ColorRes.textSecondary),
                    const SizedBox(width: 4),
                    Expanded(child: Text(lead['property']!, style: TextStyle(fontSize: AppFontSizes.small, color: ColorRes.textSecondary))),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.currency_rupee_rounded, size: 14, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(lead['budget']!, style: TextStyle(fontSize: AppFontSizes.small, fontWeight: FontWeight.w600, color: Colors.green)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.call_rounded, color: ColorRes.primary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
