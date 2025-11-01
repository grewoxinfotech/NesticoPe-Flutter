import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/data/network/location_price_matrix/model/location_price_matrix_model.dart';
import '../../../app/constants/color_res.dart';
import '../controllers/location_price_matrix_controller.dart';

class LocationPriceMatrixScreen extends StatelessWidget {
  const LocationPriceMatrixScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LocationPriceMatrixController());

    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: ColorRes.white,
        leading: const Icon(Icons.arrow_back, color: ColorRes.textPrimary),
        title: Text(
          'Property Insights',
          style: TextStyle(
            fontWeight: AppFontWeights.bold,
            color: ColorRes.textPrimary,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.propertyResponse.value?.data;
        if (data == null) {
          return const Center(child: Text('No data available'));
        }

        return DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: ColorRes.white,
                  border: Border(
                    bottom: BorderSide(
                      color: ColorRes.leadGreyColor.withOpacity(0.3),
                    ),
                  ),
                ),
                child: TabBar(
                  labelColor: ColorRes.primary,
                  unselectedLabelColor: ColorRes.leadGreyColor,
                  indicatorWeight: 3,
                  dividerColor: ColorRes.leadGreyColor.shade300,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: ColorRes.primary,
                  tabs: [Tab(text: 'Buy'), Tab(text: 'Rent')],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildPropertyView(data.buy),
                    _buildPropertyView(data.rent),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPropertyView(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: map.entries.length,
      itemBuilder: (context, index) {
        final stateEntry = map.entries.elementAt(index);
        final state = stateEntry.key;
        final cities = stateEntry.value as Map<String, dynamic>;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STATE HEADER
            Container(
              padding: EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: ColorRes.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    state,
                    style: TextStyle(
                      color: ColorRes.white,
                      fontWeight: AppFontWeights.medium,
                      fontSize: AppFontSizes.medium,
                    ),
                  ),
                ],
              ),
            ),

            // CITIES
            ...cities.entries.map((cityEntry) {
              final city = cityEntry.key;
              final categories = cityEntry.value as Map<String, dynamic>;
              return _buildCityCard(city, categories);
            }),

            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  Widget _buildCityCard(String city, Map<String, dynamic> categories) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: ColorRes.leadGreyColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),

        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          iconColor: ColorRes.primary,
          childrenPadding: const EdgeInsets.only(bottom: 8),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorRes.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.apartment, color: ColorRes.primary, size: 25),
          ),
          title: Text(
            city,
            style: TextStyle(
              fontWeight: AppFontWeights.bold,
              fontSize: AppFontSizes.bodyMedium,
            ),
          ),
          subtitle: Text(
            '${categories.length} categories',
            style: TextStyle(
              fontSize: AppFontSizes.caption,

              color: ColorRes.leadGreyColor[700],
            ),
          ),
          children:
              categories.entries.map((catEntry) {
                final cat = catEntry.key;
                final listings = catEntry.value as List;
                return _buildCategorySection(cat, listings);
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategorySection(String category, List listings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorRes.orangeColor.withOpacity(0.3),
                    width: 1,
                  ),
                  color: ColorRes.orangeColor.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  category,
                  style: TextStyle(
                    fontSize: AppFontSizes.extraSmall,
                    fontWeight: FontWeight.w600,
                    color: ColorRes.orangeColor,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${listings.length} listings',
                style: TextStyle(
                  fontSize: AppFontSizes.extraSmall,
                  color: ColorRes.leadGreyColor[700],
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ],
          ),
        ),

        // LISTINGS
        ...listings.map((item) {
          final listing = LocationPriceMatrixListings.fromJson(item);
          return _buildListingItem(listing);
        }),
      ],
    );
  }

  Widget _buildListingItem(LocationPriceMatrixListings listing) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorRes.leadGreyColor[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Row(
            children: [
              Expanded(
                child: Text(
                  listing.location ?? '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: AppFontWeights.semiBold,
                    fontSize: AppFontSizes.small,
                    color: Colors.black87,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: _getDemandColor(listing.demandIndex),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Demand: ${listing.demandIndex ?? 0}',
                  style: TextStyle(
                    fontSize: AppFontSizes.mini,
                    color: ColorRes.white,
                    fontWeight: AppFontWeights.semiBold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Price Info
          Row(
            children: [
              _buildInfoChip(
                Icons.currency_rupee,
                _formatPrice(listing.avgPrice ?? 0),
                ColorRes.green,
              ),
              if (listing.pricePerSqFt != null) ...[
                const SizedBox(width: 8),
                _buildInfoChip(
                  Icons.area_chart,
                  '₹${listing.pricePerSqFt?.avg ?? 0}/sqft',
                  ColorRes.primary,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.semiBold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDemandColor(num? demand) {
    if (demand == null) return ColorRes.leadGreyColor;
    if (demand >= 80) return ColorRes.green;
    if (demand >= 50) return ColorRes.orangeColor;
    return ColorRes.error;
  }

  String _formatPrice(num price) {
    if (price >= 10000000) {
      return '${(price / 10000000).toStringAsFixed(2)}Cr';
    } else if (price >= 100000) {
      return '${(price / 100000).toStringAsFixed(2)}L';
    }
    return price.toString();
  }
}
