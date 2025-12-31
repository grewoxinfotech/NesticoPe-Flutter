import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractor_profile_model/contractor_profile_model.dart';
import 'package:housing_flutter_app/modules/home/controllers/contractor_profile_controller/contractor_compare_manager.dart';

import '../../../data/network/contractor/model/contractor_compare_model/contractor_compare_model.dart';
import '../../../data/network/contractor/service/contractor_compare_service.dart';

class ContractorComparisonScreen extends StatefulWidget {
  const ContractorComparisonScreen({super.key});

  @override
  State<ContractorComparisonScreen> createState() =>
      _ContractorComparisonScreenState();
}

class _ContractorComparisonScreenState
    extends State<ContractorComparisonScreen> {
  final ContractorCompareManager _compareManager =
  Get.find<ContractorCompareManager>();

  final RxBool _isLoading = false.obs;
  final RxMap<String, ContractorDataResponse> _contractorData =
      <String, ContractorDataResponse>{}.obs;
  final RxString _error = ''.obs;

  @override
  void initState() {
    super.initState();
    _loadContractorData();
  }

  Future<void> _loadContractorData() async {
    _isLoading.value = true;
    _error.value = '';

    try {
      final selectedContractors = _compareManager.selectedList;

      if (selectedContractors.isEmpty) {
        _error.value = 'No contractors selected for comparison';
        _isLoading.value = false;
        return;
      }

      for (var contractor in selectedContractors) {
        try {
          final response = await ContractorCompareService.service
              .getContractorById(contractor.userId);
          if (response.isNotEmpty) {
            final contractorResponse =
            ContractorDataResponse.fromJson(response);
            _contractorData[contractor.userId] = contractorResponse;
          }
        } catch (e) {
          print('Error loading contractor ${contractor.id}: $e');
        }
      }

      if (_contractorData.isEmpty) {
        _error.value = 'Failed to load contractor data';
      }
    } catch (e) {
      _error.value = 'Error loading data: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.leadGreyColor[50],
      appBar: AppBar(
        backgroundColor: ColorRes.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorRes.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Contractor Comparison',
          style: TextStyle(
            color: ColorRes.black,
            fontWeight: AppFontWeights.bold,
          ),
        ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.clear_all, color: ColorRes.black, size: 20),
        //     onPressed: () {
        //       _compareManager.clear();
        //       Get.back();
        //     },
        //   ),
        // ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            if (_isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(color: ColorRes.primary),
              );
            }

            if (_error.value.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        size: 64, color: ColorRes.leadGreyColor[400]),
                    const SizedBox(height: 16),
                    Text(
                      _error.value,
                      style: const TextStyle(fontSize: AppFontSizes.medium),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadContractorData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRes.primary,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (_contractorData.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.compare_arrows,
                        size: 64,
                        color: ColorRes.leadGreyColor[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No contractors selected',
                        style: TextStyle(
                          fontSize: AppFontSizes.medium,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.leadGreyColor[700],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            final contractors = _contractorData.values.toList();

            if (contractors.length == 1) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ContractorCardForCompare(
                      contractor: contractors[0],
                      onRemove: () {
                        final userId = _contractorData.entries
                            .firstWhere((e) => e.value == contractors[0])
                            .key;
                        _contractorData.remove(userId);
                      },
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(
                              Icons.add_circle_outline,
                              size: 25,
                              color: ColorRes.primary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Select one more contractor to compare',
                            style: TextStyle(
                              fontSize: AppFontSizes.medium,
                              fontWeight: AppFontWeights.medium,
                              color: ColorRes.leadGreyColor[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            final a = contractors[0];
            final b = contractors[1];

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ContractorCardForCompare(
                    contractor: a,
                    onRemove: () {
                      final userId = _contractorData.entries
                          .firstWhere((e) => e.value == a)
                          .key;
                      _contractorData.remove(userId);
                    },
                  ),
                  const SizedBox(height: 12),
                  _ContractorCardForCompare(
                    contractor: b,
                    onRemove: () {
                      final userId = _contractorData.entries
                          .firstWhere((e) => e.value == b)
                          .key;
                      _contractorData.remove(userId);
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Detailed Comparison',
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.bold,
                      color: ColorRes.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ContractorComparisonTable(a: a, b: b),
                  const SizedBox(height: 10),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _ContractorCardForCompare extends StatelessWidget {
  final ContractorDataResponse contractor;
  final VoidCallback? onRemove;

  const _ContractorCardForCompare({
    required this.contractor,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final c = contractor.data.contractor;
    final p = contractor.data.profile;

    return Material(
      color: ColorRes.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      shadowColor: ColorRes.black.withOpacity(0.06),
      child: Container(
        height: 115,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                // Avatar Section
                Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: ColorRes.primary.withOpacity(0.1),
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(11),
                    ),
                  ),
                  child: Center(
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: ColorRes.primary,
                      child: Text(
                        (c.username.isNotEmpty
                            ? c.username[0].toUpperCase()
                            : '?'),
                        style: const TextStyle(
                          color: ColorRes.white,
                          fontSize: AppFontSizes.displaySmall,
                          fontWeight: AppFontWeights.bold,
                        ),
                      ),
                    ),
                  ),
                ),

                // Content Section
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Username (only if available)
                        if ((c.username).isNotEmpty)
                          Text(
                            c.username,
                            style: const TextStyle(
                              fontSize: AppFontSizes.bodyMedium,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.textColor,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                        // Location (only if any non-null)
                        if ((c.city != null && c.city!.isNotEmpty) ||
                            (c.state != null && c.state!.isNotEmpty))
                          Text(
                            '${c.city ?? ''}${c.city != null && c.state != null ? ', ' : ''}${c.state ?? ''}',
                            style: TextStyle(
                              fontSize: AppFontSizes.caption,
                              color: ColorRes.leadGreyColor[600],
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                        // Rating & Services (only if data exists)
                        if (p.overallRating != null ||
                            (p.totalServices != null && p.totalServices > 0))
                          Row(
                            children: [
                              if (p.overallRating != null)
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: ColorRes.homeYellow,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${p.overallRating}',
                                      style: const TextStyle(
                                        fontSize: AppFontSizes.small,
                                        fontWeight: AppFontWeights.semiBold,
                                      ),
                                    ),
                                  ],
                                ),
                              if (p.overallRating != null &&
                                  (p.totalServices != null &&
                                      p.totalServices > 0))
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                                  child: Container(
                                    width: 3,
                                    height: 3,
                                    decoration: const BoxDecoration(
                                      color: ColorRes.grey,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              if (p.totalServices != null &&
                                  p.totalServices > 0)
                                Text(
                                  '${p.totalServices} Services',
                                  style: TextStyle(
                                    fontSize: AppFontSizes.small,
                                    color: ColorRes.leadGreyColor[600],
                                  ),
                                ),
                            ],
                          ),

                        // View Profile Button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorRes.primary,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'View Profile',
                                  style: TextStyle(
                                    fontWeight: AppFontWeights.semiBold,
                                    fontSize: AppFontSizes.small,
                                    color: ColorRes.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Remove button
            if (onRemove != null)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onRemove,
                  child: const Icon(
                    Icons.cancel,
                    color: ColorRes.error,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}


class _ContractorComparisonTable extends StatelessWidget {
  final ContractorDataResponse a;
  final ContractorDataResponse b;

  const _ContractorComparisonTable({required this.a, required this.b});

  @override
  Widget build(BuildContext context) {
    // Collect all unique services
    Map<String, Map<String, dynamic>> allServices = {};

    for (var category in a.data.servicesByCategory) {
      for (var service in category.services) {
        String key = '${category.categoryName}|${service.serviceName}';
        if (!allServices.containsKey(key)) {
          allServices[key] = {
            'categoryName': category.categoryName,
            'serviceName': service.serviceName,
          };
        }
      }
    }

    for (var category in b.data.servicesByCategory) {
      for (var service in category.services) {
        String key = '${category.categoryName}|${service.serviceName}';
        if (!allServices.containsKey(key)) {
          allServices[key] = {
            'categoryName': category.categoryName,
            'serviceName': service.serviceName,
          };
        }
      }
    }

    // Group by category
    Map<String, List<MapEntry<String, Map<String, dynamic>>>>
    servicesByCategory = {};
    for (var entry in allServices.entries) {
      String categoryName = entry.value['categoryName'];
      if (!servicesByCategory.containsKey(categoryName)) {
        servicesByCategory[categoryName] = [];
      }
      servicesByCategory[categoryName]!.add(entry);
    }

    return Container(
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.grey.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          _header(),
          ...servicesByCategory.entries.expand((categoryEntry) {
            String categoryName = categoryEntry.key;
            List<MapEntry<String, Map<String, dynamic>>> services =
                categoryEntry.value;

            return [
              // Category Header
              _CategoryHeader(categoryName: categoryName),
              // Services in this category
              ...services.map((serviceEntry) {
                String serviceName = serviceEntry.value['serviceName'];
                return _ServiceComparisonRow(
                  serviceName: serviceName,
                  contractorA: a,
                  contractorB: b,
                  isLast: services.last == serviceEntry &&
                      categoryEntry.key ==
                          servicesByCategory.entries.last.key,
                );
              }).toList(),
            ];
          }).toList(),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ColorRes.leadGreyColor[200]!),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            child: Text(
              'Service Name',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              a.data.contractor.username,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              b.data.contractor.username,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final String categoryName;

  const _CategoryHeader({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: ColorRes.primary.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: ColorRes.leadGreyColor[200]!, width: 1),
        ),
      ),
      child: Text(
        categoryName.toUpperCase(),
        style: const TextStyle(
          fontSize: AppFontSizes.small,
          fontWeight: AppFontWeights.bold,
          color: ColorRes.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ServiceComparisonRow extends StatelessWidget {
  final String serviceName;
  final ContractorDataResponse contractorA;
  final ContractorDataResponse contractorB;
  final bool isLast;

  const _ServiceComparisonRow({
    required this.serviceName,
    required this.contractorA,
    required this.contractorB,
    this.isLast = false,
  });

  dynamic _findService(ContractorDataResponse contractor, String serviceName) {
    for (var category in contractor.data.servicesByCategory) {
      for (var service in category.services) {
        if (service.serviceName == serviceName) {
          return service;
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final serviceA = _findService(contractorA, serviceName);
    final serviceB = _findService(contractorB, serviceName);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Service Name
          Expanded(
            child: Text(
              serviceName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.leadGreyColor[700],
              ),
            ),
          ),

          // Contractor A Details
          Expanded(
            child: _buildServiceDetails(serviceA),
          ),

          // Contractor B Details
          Expanded(
            child: _buildServiceDetails(serviceB),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDetails(dynamic service) {
    if (service == null) {
      return const Center(
        child: Text(
          'Not Available',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.small,
            color: ColorRes.textDisabled,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Rating
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star,
              color: ColorRes.homeYellow,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              '${service.rating}',
              style: const TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textColor,
              ),
            ),
          ],
        ),
        Text(
          '(${service.totalReviews} reviews)',
          style: const TextStyle(
            fontSize: AppFontSizes.extraSmall,
            color: ColorRes.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        // Price
        Text(
          '₹${service.meta.price}',
          style: const TextStyle(
            fontSize: AppFontSizes.medium,
            fontWeight: AppFontWeights.bold,
            color: ColorRes.primary,
          ),
        ),
        Text(
          '/${service.meta.priceModel}',
          style: const TextStyle(
            fontSize: AppFontSizes.extraSmall,
            color: ColorRes.textSecondary,
          ),
        ),
      ],
    );
  }
}