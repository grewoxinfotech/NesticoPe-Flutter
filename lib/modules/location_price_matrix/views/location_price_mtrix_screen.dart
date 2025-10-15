import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/location_price_matrix/model/location_price_matrix_model.dart';

import '../controllers/location_price_matrix_controller.dart';


class LocationPriceMatrixScreen extends StatelessWidget {
  const LocationPriceMatrixScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationPriceMatrixController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Insights'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.propertyResponse.value?.data;
        if (data == null) {
          return const Center(child: Text('No data available'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('🏠 Buy Properties'),
              _buildPropertyMap(data.buy),

              const SizedBox(height: 24),
              _buildSectionTitle('💼 Rent Properties'),
              _buildPropertyMap(data.rent),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
    );
  }

  Widget _buildPropertyMap(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Text('No data available'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: map.entries.map((stateEntry) {
        final state = stateEntry.key;
        final cities = stateEntry.value as Map<String, dynamic>;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            ...cities.entries.map((cityEntry) {
              final city = cityEntry.key;
              final categories = cityEntry.value as Map<String, dynamic>;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 4),
                    child: Text(
                      '📍 $city',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ...categories.entries.map((catEntry) {
                    final cat = catEntry.key;
                    final listings = catEntry.value as List;

                    return Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🏢 $cat (${listings.length} listings)',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ...listings.map((item) {
                            final listing = LocationPriceMatrixListings.fromJson(item);
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      listing.location ?? '-',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Avg Price: ₹${listing.avgPrice ?? 0}'),
                                    if (listing.pricePerSqFt != null)
                                      Text(
                                          'Price/SqFt: ₹${listing.pricePerSqFt?.avg ?? 0}'),
                                    Text('Demand Index: ${listing.demandIndex ?? 0}'),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  }),
                ],
              );
            }),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }
}
