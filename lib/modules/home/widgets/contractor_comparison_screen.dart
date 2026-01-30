import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractor_profile_model/contractor_profile_model.dart';
import 'package:housing_flutter_app/modules/home/controllers/contractor_profile_controller/contractor_compare_manager.dart';
import 'package:intl/intl.dart';

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
                  child: const Center(
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: ColorRes.primary,
                      child: Icon(
                        Icons.engineering, // 👈 replace with any icon you like
                        color: ColorRes.white,
                        size: 35, // adjust as needed
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



class _ContractorComparisonTable extends StatefulWidget {
  final ContractorDataResponse a;
  final ContractorDataResponse b;

  const _ContractorComparisonTable({required this.a, required this.b});

  @override
  State<_ContractorComparisonTable> createState() =>
      _ContractorComparisonTableState();
}

class _ContractorComparisonTableState
    extends State<_ContractorComparisonTable> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Collect all unique services
    Map<String, Map<String, dynamic>> allServices = {};

    for (var category in widget.a.data.servicesByCategory) {
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

    for (var category in widget.b.data.servicesByCategory) {
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

    return Column(
      children: [
        SizedBox(
          height: 550,
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              // Contractor A Card
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _ContractorServicesCard(
                  contractor: widget.a,
                  activeServices: widget.a.data.totalActiveServices.toString(),
                  servicesByCategory: servicesByCategory,
                  totalServices: widget.a.data.totalServices.toString(),
                  contractorType: widget.a.data.profile.contractorType,
                  location:widget.a.data.contractor.city??'' ,
                  title: widget.a.data.contractor.username,
                  membershipSince: formatMemberSince(widget.a.data.contractor.memberSince.toIso8601String()),
                ),
              ),
              // Contractor B Card
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _ContractorServicesCard(
                  activeServices: widget.b.data.totalActiveServices.toString(),
                  contractor: widget.b,
                  servicesByCategory: servicesByCategory,
                  totalServices: widget.b.data.totalServices.toString(),
                  contractorType: widget.b.data.profile.contractorType,
                  location:widget.b.data.contractor.city??'' ,

                  membershipSince: formatMemberSince(widget.b.data.contractor.memberSince.toIso8601String()),
                  title: widget.b.data.contractor.username,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Page Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            2,
                (index) => GestureDetector(
              onTap: () {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? ColorRes.primary
                      : ColorRes.leadGreyColor[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ContractorServicesCard extends StatelessWidget {
  final ContractorDataResponse contractor;
  final Map<String, List<MapEntry<String, Map<String, dynamic>>>>
  servicesByCategory;
  final String title;
  final String totalServices;
  final String activeServices;
  final String contractorType;
  final String location;
  final String membershipSince;

  const _ContractorServicesCard({
    required this.contractor,
    required this.servicesByCategory,
    required this.title, required this.totalServices, required this.activeServices, required this.contractorType, required this.location, required this.membershipSince,
  });

  Service _findService(String serviceName) {
    for (var category in contractor.data.servicesByCategory) {
      for (var service in category.services) {
        if (service.serviceName == serviceName) {
          return service;
        }
      }
    }
    return Service.fromJson({});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 32,
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.grey.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          // Header with contractor name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: ColorRes.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                topRight: Radius.circular(11),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.bold,
                      color: ColorRes.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),





          // Services List in Slider
          SizedBox(
            height: 500,
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                contractorBasicDetails('Total Services',totalServices),
                Divider(color: ColorRes.leadGreyColor.shade300,),
                contractorBasicDetails('Active Services',activeServices),
                Divider(color: ColorRes.leadGreyColor.shade300,),
                contractorBasicDetails('Contractor Type',contractorType),
                Divider(color: ColorRes.leadGreyColor.shade300,),
                contractorBasicDetails('Location',location),
                Divider(color: ColorRes.leadGreyColor.shade300,),
                contractorBasicDetails('Member Since',membershipSince),


                ...servicesByCategory.entries.expand((categoryEntry) {
                  String categoryName = categoryEntry.key;
                  List<MapEntry<String, Map<String, dynamic>>> services =
                      categoryEntry.value;

                  return [
                    // Category Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: ColorRes.primary.withOpacity(0.1),
                        border: Border(
                          bottom: BorderSide(
                              color: ColorRes.leadGreyColor[200]!, width: 1),
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
                    ),
                    // Services in this category
                    ...services.map((serviceEntry) {
                      String serviceName = serviceEntry.value['serviceName'];
                      final service = _findService(serviceName);
                      bool isLast = services.last == serviceEntry &&
                          categoryEntry.key ==
                              servicesByCategory.entries.last.key;

                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          border: isLast
                              ? null
                              : Border(
                              bottom: BorderSide(color: Colors.grey[300]!)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Service Name
                            Expanded(
                              flex: 2,
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
                            const SizedBox(width: 12),
                            // Service Details
                            _buildServiceDetails(service),
                          ],
                        ),
                      );
                    }).toList(),
                  ];
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding contractorBasicDetails(String title,String value) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    fontWeight: AppFontWeights.medium,
                    color: ColorRes.leadGreyColor[700],
                  ),
                ),
              ),
              SizedBox(width: 10,),
              Text(

                value,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textColor,
                ),
              ),
            ],
          ),
        );
  }

  Widget _buildServiceDetails(Service service) {
    if (service == null) {
      return const Center(
        child: Text(
          'N/A',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.small,
            color: ColorRes.textDisabled,
            fontWeight: AppFontWeights.medium,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Rating
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star,
              color: ColorRes.homeYellow,
              size: 13,
            ),
            const SizedBox(width: 3),
            Text(
              '${service.rating}',
              style: const TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textColor,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(${service.totalReviews} reviews)',
              style: const TextStyle(
                fontSize: AppFontSizes.extraSmall,
                color: ColorRes.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 4,),

        // Price
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: Formatter.formatPrice(service.meta.price),
                style: const TextStyle(
                  fontSize: AppFontSizes.medium,
                  fontWeight: AppFontWeights.bold,
                  color: ColorRes.primary,
                ),
              ),
              TextSpan(
                text: ' /${service.meta.priceModel}',
                style: const TextStyle(
                  fontSize: AppFontSizes.extraSmall,
                  color: ColorRes.textSecondary,
                ),
              ),
            ],
          ),
        )

      ],
    );
  }
}




String formatMemberSince(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    // Format: Jan 2026
    return DateFormat('MMM yyyy').format(date);
  } catch (e) {
    return '';
  }
}