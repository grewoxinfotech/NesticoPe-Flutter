import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

class PropertyOverviewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> properties;

  const PropertyOverviewScreen({super.key, required this.properties});

  // Dummy data generator - you can replace this with your actual data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          "Property Overview",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: () {}),
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          final property = properties[index];
          return _buildPropertyCard(property);
        },
      ),
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> property) {
    final bool isSold = property['status'] == 'Sold';
    final bool isFeatured = property['featured'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Property Image with Status Badge
              Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      image:
                          property['image'] != null
                              ? DecorationImage(
                                image: NetworkImage(property['image']),
                                fit: BoxFit.cover,
                              )
                              : null,
                    ),
                    child:
                        property['image'] == null
                            ? const Icon(
                              Icons.home,
                              size: 60,
                              color: Colors.grey,
                            )
                            : null,
                  ),
                  // Status Badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSold ? Colors.red : ColorRes.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        property['status'] ?? 'Available',
                        style: TextStyle(
                          color: isSold ? Colors.white : ColorRes.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Featured Badge
                ],
              ),

              // Property Details
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Price
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                property['title'] ?? 'Property Title',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      property['location'] ?? 'Location',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            property['price'] ?? '\$0',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Property Features
                    Row(
                      children: [
                        _buildFeatureChip(
                          Icons.hotel,
                          '${property['bedrooms'] ?? 0} Beds',
                        ),
                        const SizedBox(width: 8),
                        _buildFeatureChip(
                          Icons.bathtub,
                          '${property['bathrooms'] ?? 0} Baths',
                        ),
                        const SizedBox(width: 8),
                        _buildFeatureChip(
                          Icons.square_foot,
                          property['area'] ?? '0 sq ft',
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Divider
                    Container(height: 1, color: Colors.grey[200]),

                    const SizedBox(height: 16),

                    // Analytics Overview
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildAnalyticsItem(
                          Icons.visibility,
                          _formatNumber(property['views'] ?? 0),
                          'Views',
                          ColorRes.primary,
                        ),
                        _buildAnalyticsItem(
                          Icons.favorite,
                          _formatNumber(property['likes'] ?? 0),
                          'Likes',
                          ColorRes.primary,
                        ),
                        _buildAnalyticsItem(
                          Icons.share,
                          _formatNumber(property['shares'] ?? 0),
                          'Shares',
                          ColorRes.primary,
                        ),
                        _buildAnalyticsItem(
                          Icons.people,
                          _formatNumber(property['visits'] ?? 0),
                          'Visits',
                          ColorRes.primary,
                        ),
                        _buildAnalyticsItem(
                          Icons.contact_phone,
                          _formatNumber(property['totalLeads'] ?? 0),
                          'Leads',
                          ColorRes.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsItem(
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        // const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
