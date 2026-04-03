/*
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/data/network/contractor/model/contractor_profile_model/contractor_profile_model.dart';
import 'package:nesticope_app/modules/home/controllers/contractor_profile_controller/contractor_compare_manager.dart';
import 'package:intl/intl.dart';

import '../../../data/network/contractor/model/contractor_compare_model/contractor_compare_model.dart';
import '../../../data/network/contractor/service/contractor_compare_service.dart';
import '../../../utils/logger/app_logger.dart';
import '../../../data/network/contractor/service/contractor_profile_service.dart';


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
  String _activeId = '';
  

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
            final contractorResponse = ContractorDataResponse.fromJson(
              response,
            );
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
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: ColorRes.leadGreyColor[400],
                    ),
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
                        final userId =
                            _contractorData.entries
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
                      final userId =
                          _contractorData.entries
                              .firstWhere((e) => e.value == a)
                              .key;
                      _contractorData.remove(userId);
                    },
                  ),
                  const SizedBox(height: 12),
                  _ContractorCardForCompare(
                    contractor: b,
                    onRemove: () {
                      final userId =
                          _contractorData.entries
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

  const _ContractorCardForCompare({required this.contractor, this.onRemove});

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
                  child: FutureBuilder(
                    future: TopContractorsService()
                        .fetchUserModelById(c.id),
                    builder: (context, snapshot) {
                      final url = snapshot.hasData
                          ? (snapshot.data as dynamic).profilePic as String? ?? ''
                          : '';
                      return Center(
                        child: ClipOval(
                          child: url.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: url,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  placeholder: (context, u) =>
                                      ShimmerShapes.circle(size: 70),
                                  errorWidget: (context, u, e) => CircleAvatar(
                                    radius: 35,
                                    backgroundColor: ColorRes.primary,
                                    child: const Icon(
                                      Icons.design_services_outlined,
                                      color: Colors.white,
                                      size: 35,
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 35,
                                  backgroundColor: ColorRes.primary,
                                  child: const Icon(
                                    Icons.design_services_outlined,
                                    color: Colors.white,
                                    size: 35,
                                  ),
                                ),
                        ),
                      );
                    },
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
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
  bool _didInitialNotify = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_didInitialNotify && widget.contractors.isNotEmpty) {
        widget.onActiveChange?.call(widget.contractors[0].data.contractor.id);
        _didInitialNotify = true;
      }
    });
  }
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
                  location: widget.a.data.contractor.city ?? '',
                  title: widget.a.data.contractor.username,
                  membershipSince: formatMemberSince(
                    widget.a.data.contractor.memberSince.toIso8601String(),
                  ),
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
                  location: widget.b.data.contractor.city ?? '',

                  membershipSince: formatMemberSince(
                    widget.b.data.contractor.memberSince.toIso8601String(),
                  ),
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
                  color:
                      _currentPage == index
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
    required this.title,
    required this.totalServices,
    required this.activeServices,
    required this.contractorType,
    required this.location,
    required this.membershipSince,
  });

  Service? _findService(String serviceName) {
    for (var category in contractor.data.servicesByCategory) {
      for (var service in category.services) {
        if (service.serviceName == serviceName) {
          return service;
        }
      }
    }
    return null;
  }
  // Fix Bug 2: pass categoryName into _findService
  */
/*Service? _findService(String categoryName, String serviceName) {
    for (var category in contractor.data.servicesByCategory) {
      if (category.categoryName == categoryName) {
        for (var service in category.services) {
          if (service.serviceName == serviceName) {
            return service;
          }
        }
      }
    }
    return null; // return null if not found
  }*/ /*


  @override
  Widget build(BuildContext context) {
    final ownCategories = contractor.data.servicesByCategory;
    return SafeArea(
      child: Container(
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
                  contractorBasicDetails('Total Services', totalServices),
                  Divider(color: ColorRes.leadGreyColor.shade300),
                  contractorBasicDetails('Active Services', activeServices),
                  Divider(color: ColorRes.leadGreyColor.shade300),
                  contractorBasicDetails('Contractor Type', contractorType),
                  Divider(color: ColorRes.leadGreyColor.shade300),
                  contractorBasicDetails('Location', location),
                  Divider(color: ColorRes.leadGreyColor.shade300),
                  contractorBasicDetails('Member Since', membershipSince),
      
                  */
/*...servicesByCategory.entries.expand((categoryEntry) {
                    String categoryName = categoryEntry.key;
                    List<MapEntry<String, Map<String, dynamic>>> services =
                        categoryEntry.value;*/ /*

      ...servicesByCategory.entries.expand((categoryEntry) {
      String categoryName = categoryEntry.key;
      List<MapEntry<String, Map<String, dynamic>>> services = categoryEntry.value;
      
                    return [
                      // Category Header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: ColorRes.primary.withOpacity(0.1),
                          border: Border(
                            bottom: BorderSide(
                              color: ColorRes.leadGreyColor[200]!,
                              width: 1,
                            ),
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
                      if (services.isEmpty)...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: ColorRes.leadGreyColor.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: ColorRes.leadGreyColor.shade200),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info_outline, size: 14, color: ColorRes.leadGreyColor[400]),
                                const SizedBox(width: 6),
                                Text(
                                  'Not Available',
                                  style: TextStyle(
                                    fontSize: AppFontSizes.small,
                                    color: ColorRes.leadGreyColor[500],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )]
                      else...[ ...services.map((serviceEntry) {
                        String serviceName = serviceEntry.value['serviceName'];
                        String categoryName = serviceEntry.value['categoryName']; // ← add this
      
                        final service = _findService( serviceName);  // ← pass both
                        bool isLast =
                            services.last == serviceEntry &&
                                categoryEntry.key == servicesByCategory.entries.last.key;
      
      
      
                        AppLogger.structured("Check any filed missing ",service?.toMap());
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: isLast
                                ? null
                                : Border(
                              bottom: BorderSide(
                                color: Colors.grey[300]!,
                              ),
                            ),
                          ),
                          child:service == null
                          // ── Service not offered by this contractor ──
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: ColorRes.leadGreyColor.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: ColorRes.leadGreyColor.shade200,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.info_outline,
                                      size: 14,
                                      color: ColorRes.leadGreyColor[400],
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Data not available',
                                      style: TextStyle(
                                        fontSize: AppFontSizes.small,
                                        color: ColorRes.leadGreyColor[500],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                          // ── Service found ──────────────────────────
                              : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service?.serviceName??'',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: AppFontSizes.medium,
                                  fontWeight: AppFontWeights.semiBold,
                                  color: ColorRes.textColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.star, color: ColorRes.homeYellow, size: 13),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${service?.rating}',
                                    style: const TextStyle(
                                      fontSize: AppFontSizes.small,
                                      fontWeight: AppFontWeights.semiBold,
                                      color: ColorRes.textColor,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '(${service?.totalReviews})',
                                    style: const TextStyle(
                                      fontSize: AppFontSizes.extraSmall,
                                      color: ColorRes.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: Formatter.formatPriceRange(
                                        service?.meta.minPrice??0,
                                        service?.meta.maxPrice??0,
                                      ),
                                      style: const TextStyle(
                                        fontSize: AppFontSizes.medium,
                                        fontWeight: AppFontWeights.bold,
                                        color: ColorRes.textColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' /${service?.meta.priceModel}',
                                      style: const TextStyle(
                                        fontSize: AppFontSizes.extraSmall,
                                        color: ColorRes.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            if(service!=null)...[
                              _buildServiceDetails(service),
                            ]
                            ],
                          ),
                        );
                      }).toList(),
        ],
                    ];
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding contractorBasicDetails(String title, String value) {
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
          SizedBox(width: 10),
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
    final meta = service.meta;

    // Collect all non-empty meta rows
    List<Widget> _buildAllMetaWidgets() {
      final List<Widget> rows = [];

      Widget chip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: ColorRes.leadGreyColor.shade100,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: AppFontSizes.extraSmall,
            color: ColorRes.textSecondary,
          ),
        ),
      );

      void addRow(String label, List<String>? values) {
        if (values == null || values.isEmpty) return;
        rows.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 95,
                  child: Text(
                    '$label:',
                    style: const TextStyle(
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: values.map((v) => chip(v)).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      void addString(String label, String? value) {
        if (value == null || value.isEmpty) return;
        rows.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 95,
                  child: Text(
                    '$label:',
                    style: const TextStyle(
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: AppFontSizes.extraSmall,
                      color: ColorRes.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      void addYesNo(String label, String? value) {
        if (value == null || value.isEmpty) return;
        final isYes = value == 'YES';
        rows.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 95,
                  child: Text(
                    '$label:',
                    style: const TextStyle(
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isYes ? Colors.green.shade50 : ColorRes.leadGreyColor.shade100,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isYes ? Colors.green.shade300 : ColorRes.leadGreyColor.shade300,
                    ),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: AppFontSizes.extraSmall,
                      fontWeight: AppFontWeights.semiBold,
                      color: isYes ? Colors.green.shade700 : ColorRes.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Visit Charge
      if (meta.visitCharge > 0) addString('Visit Charge', '₹${meta.visitCharge}');

      // Brands
      addString('Brands', meta.brandsUsed);

      // Material Lists
      addRow('Cement', meta.cementBrand);
      addRow('Steel', meta.steelBrand);
      addRow('Bricks', meta.brickType);
      addRow('Sand', meta.sandSource);
      addRow('Elec. Wires', meta.electricalWiresBrand);
      addRow('Switches', meta.electricalSwitchesBrand);
      addRow('Plumbing', meta.plumbingPipesBrand);
      addRow('Sanitary', meta.sanitaryFittingsBrand);
      addRow('Water Tank', meta.waterTankBrand);
      addRow('Flooring', meta.flooringTilesBrand);
      addRow('Int. Paint', meta.interiorPaintBrand);
      addRow('Ext. Paint', meta.exteriorPaintBrand);
      addRow('Doors', meta.doorsType);
      addRow('Windows', meta.windowsType);
      addRow('Structure', meta.structure);
      addRow('Plaster', meta.plasterType);
      addRow('Waterproofing', meta.waterproofing);
      addRow('Chokhat', meta.chokhatType);
      addRow('Railing', meta.railingType);
      addRow('False Ceiling', meta.falseCeiling);
      addRow('Fabrication', meta.fabricationWork);

      // Yes / No
      addYesNo('3D Design', meta.threeDDesign);
      addYesNo('Mod. Kitchen', meta.modularKitchen);
      addYesNo('Bore & Pump', meta.boreAndPump);
      addYesNo('Security', meta.securitySystems);
      addYesNo('Home Auto.', meta.homeAutomation);
      addYesNo('Solar', meta.solarSolutions);

      // Payment & Billing
      addRow('Payment', meta.acceptedPaymentModes);
      addString('Billing', meta.billingType == 'gst' ? 'GST' : 'Non-GST');
      if (meta.advanceRequiredPercentage > 0) {
        addString('Advance', '${meta.advanceRequiredPercentage}%');
      }

      return rows;
    }

    const int minVisible = 4;

    return StatefulBuilder(
      builder: (context, setState) {
        bool isExpanded = false; // local state per card

        return StatefulBuilder(
          builder: (context, setInnerState) {
            final allRows = _buildAllMetaWidgets();
            final hasMore = allRows.length > minVisible;
            final visibleRows = isExpanded ? allRows : allRows.take(minVisible).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Rating & Reviews ──────────────────────────
              */
/*  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: ColorRes.homeYellow, size: 13),
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
                const SizedBox(height: 4),

                // ── Price ──────────────────────────────────────
                Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: Formatter.formatPriceRange(meta.minPrice, meta.maxPrice),
                          style: const TextStyle(
                            fontSize: AppFontSizes.medium,
                            fontWeight: AppFontWeights.bold,
                            color: ColorRes.primary,
                          ),
                        ),
                        TextSpan(
                          text: ' /${meta.priceModel}',
                          style: const TextStyle(
                            fontSize: AppFontSizes.extraSmall,
                            color: ColorRes.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
*/ /*

                // ── Meta Rows ──────────────────────────────────
                if (allRows.isEmpty)
                  const Center(
                    child: Text(
                      'No additional details',
                      style: TextStyle(
                        fontSize: AppFontSizes.extraSmall,
                        color: ColorRes.textDisabled,
                      ),
                    ),
                  )
                else
                  ...visibleRows,

                // ── Show More / Less Button ────────────────────
                if (hasMore)
                  GestureDetector(
                    onTap: () => setInnerState(() => isExpanded = !isExpanded),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isExpanded
                                ? 'Show Less'
                                : '+${allRows.length - minVisible} more',
                            style: const TextStyle(
                              fontSize: AppFontSizes.small,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 16,
                            color: ColorRes.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
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
*/

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/app/widgets/shimmer/shimmer_widget.dart';
import 'package:nesticope_app/data/network/contractor/model/contractor_profile_model/contractor_profile_model.dart';
import 'package:nesticope_app/data/network/contractor/service/contractor_profile_service.dart';
import 'package:nesticope_app/modules/home/controllers/contractor_profile_controller/contractor_compare_manager.dart';
import 'package:intl/intl.dart';
import 'package:nesticope_app/modules/home/controllers/contractor_profile_controller/contractor_profile_controller.dart';
import 'package:nesticope_app/modules/home/widgets/contractor_profile_screen.dart';

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
String _activeId = '';
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
            final contractorResponse = ContractorDataResponse.fromJson(
              response,
            );
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
      // backgroundColor: ColorRes.leadGreyColor[50],
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
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: ColorRes.leadGreyColor[400],
                  ),
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
        
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                   SizedBox(height: 16),
                ...contractors.map((c) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ContractorCardForCompare(
                      contractor: c,
                      isActive: c.data.contractor.id == _activeId,
                      onRemove: () {
                        final userId = _contractorData.entries
                            .firstWhere((e) => e.value == c)
                            .key;
                        _contractorData.remove(userId);
                        ContractorCompareManager.to
                            .remove(c.data.contractor.id);
                      },
                    ),
                  );
                }).toList(),
                if (contractors.length < 5)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    child: Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: const Icon(
                              Icons.add_circle_outline,
                              size: 30,
                              color: ColorRes.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add up to ${5 - contractors.length} more contractor${5 - contractors.length > 1 ? 's' : ''} to compare',
                            style: TextStyle(
                              fontSize: AppFontSizes.small,
                              fontWeight: AppFontWeights.medium,
                              color: ColorRes.leadGreyColor[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                 Padding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.medium,),

                  child: Text(
                    'Detailed Comparison',
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.bold,
                      color: ColorRes.black,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _ContractorComparisonTable(
                  contractors: contractors,
                  onActiveChange: (id) {
                    setState(() {
                      _activeId = id;
                    });
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _ContractorCardForCompare extends StatelessWidget {
  final ContractorDataResponse contractor;
  final VoidCallback? onRemove;
  final bool isActive;

  const _ContractorCardForCompare({
    required this.contractor,
    this.onRemove,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    TopContractorsController topContractorsController =
        Get.isRegistered<TopContractorsController>()
            ? Get.find<TopContractorsController>()
            : Get.put(TopContractorsController(), permanent: true);
    final c = contractor.data.contractor;
    Contractor? contractorProfile;
    final p = contractor.data.profile;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.medium,),
      child: Material(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        shadowColor: ColorRes.black.withOpacity(0.06),
        child: Container(
          height: 115,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive ? ColorRes.primary : ColorRes.leadGreyColor.shade200,
              width: isActive ? 2 : 1,
            ),
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  // Avatar Section
                  // Container(
                  //   width: 120,
                  //   decoration: BoxDecoration(
                  //     color: ColorRes.primary.withOpacity(0.1),
                  //     borderRadius: const BorderRadius.horizontal(
                  //       left: Radius.circular(11),
                  //     ),
                  //   ),
                  //   child: const Center(
                  //     child: CircleAvatar(
                  //       radius: 35,
                  //       backgroundColor: ColorRes.primary,
                  //       child: Icon(
                  //         Icons.engineering, // 👈 replace with any icon you like
                  //         color: ColorRes.white,
                  //         size: 35, // adjust as needed
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    width: 120,
                    decoration: BoxDecoration(
                      color: ColorRes.primary.withOpacity(0.1),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(11),
                      ),
                    ),
                    child: Center(
                      child: ClipOval(
                        child: (contractor.data.contractor.profilePic ?? '').isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: (contractor.data.contractor.profilePic ?? ''),
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => ShimmerShapes.circle(size: 70),
                                errorWidget: (_, __, ___) => _fallbackAvatar(),
                              )
                            : _fallbackAvatar(),
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
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
                                onTap: () async {
                                  contractorProfile =
                                      await topContractorsController
                                          .getContractorById(c.id);
                                  contractorProfile?.username = c.username ?? '';
      
                                  log(
                                    'contractorProfile with id ${c.id}: ${contractorProfile?.toJson()}',
                                  );
                                  if (contractorProfile != null) {
                                    Get.to(
                                      () => ContractorProfileDetailsScreen(
                                        contractor:
                                            contractorProfile ??
                                            Contractor.fromJson({}),
                                      ),
                                    );
                                  }
                                },
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
      ),
    );
  }

  Widget _fallbackAvatar() {
    return CircleAvatar(
      radius: 35,
      backgroundColor: ColorRes.primary,
      child: const Icon(
        Icons.design_services_outlined,
        color: Colors.white,
        size: 35,
      ),
    );
  }
}

class _ContractorComparisonTable extends StatefulWidget {
  final List<ContractorDataResponse> contractors;
  final ValueChanged<String>? onActiveChange;

  const _ContractorComparisonTable({
    required this.contractors,
    this.onActiveChange,
  });

  @override
  State<_ContractorComparisonTable> createState() =>
      _ContractorComparisonTableState();
}

class _ContractorComparisonTableState
    extends State<_ContractorComparisonTable> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  bool _didInitialNotify = false;
void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_didInitialNotify && widget.contractors.isNotEmpty) {
        widget.onActiveChange?.call(widget.contractors[0].data.contractor.id);
        _didInitialNotify = true;
      }
    });
  }
  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Collect all unique services
    Map<String, Map<String, dynamic>> allServices = {};

    for (var contractor in widget.contractors) {
      for (var category in contractor.data.servicesByCategory) {
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
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.contractors.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              final contractor = widget.contractors[index];
              widget.onActiveChange?.call(contractor.data.contractor.id);
            },
            itemBuilder: (context, index) {
              final contractor = widget.contractors[index];
              return _ContractorServicesCard(
                contractor: contractor,
                activeServices:
                    contractor.data.totalActiveServices.toString(),
                totalServices: contractor.data.totalServices.toString(),
                contractorType: contractor.data.profile.contractorType,
                location: contractor.data.contractor.city ?? '',
                title: contractor.data.contractor.username,
                membershipSince: formatMemberSince(
                  contractor.data.contractor.memberSince.toIso8601String(),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        // Page Indicator Dots
        if (widget.contractors.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.contractors.length,
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

  final String title;
  final String totalServices;
  final String activeServices;
  final String contractorType;
  final String location;
  final String membershipSince;

  const _ContractorServicesCard({
    required this.contractor,

    required this.title,
    required this.totalServices,
    required this.activeServices,
    required this.contractorType,
    required this.location,
    required this.membershipSince,
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
    final ownCategories = contractor.data.servicesByCategory;
    return Container(
      width: MediaQuery.of(context).size.width - 32,
           margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            height: 484,
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: [
                contractorBasicDetails('Total Services', totalServices),
                Divider(color: ColorRes.leadGreyColor.shade300),
                contractorBasicDetails('Active Services', activeServices),
                Divider(color: ColorRes.leadGreyColor.shade300),
                contractorBasicDetails('Contractor Type', contractorType),
                Divider(color: ColorRes.leadGreyColor.shade300),
                contractorBasicDetails('Location', location),
                Divider(color: ColorRes.leadGreyColor.shade300),
                contractorBasicDetails('Member Since', membershipSince),

                /* ...servicesByCategory.entries.expand((categoryEntry) {
                  String categoryName = categoryEntry.key;
                  List<MapEntry<String, Map<String, dynamic>>> services =
                      categoryEntry.value;
*/
                ...ownCategories.expand((category) {
                  final services = category.services;
                  final isLastCategory = category == ownCategories.last;
                  
                  return [
                    // Category Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: ColorRes.primary.withOpacity(0.1),
                        border: Border(
                          bottom: BorderSide(
                            color: ColorRes.leadGreyColor[200]!,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Text(
                        category.categoryName.toUpperCase(),
                        style: const TextStyle(
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.bold,
                          color: ColorRes.primary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    // Services in this category
                    /* ...services.map((serviceEntry) {
                      String serviceName = serviceEntry.value['serviceName'];
                      final service = _findService(serviceName);
                      bool isLast =
                          services.last == serviceEntry &&
                          categoryEntry.key ==
                              servicesByCategory.entries.last.key;
*/
                    ...services.map((service) {
                      final isLast = service == services.last && isLastCategory;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border:
                              isLast
                                  ? null
                                  : Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Service Name ──────────────────────────────
                            Text(
                              service.serviceName?.capitalize?.replaceAll(
                                    '_',
                                    ' ',
                                  ) ??
                                  '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: AppFontSizes.medium,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.textColor,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // ── Rating ────────────────────────────────────
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
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
                                  '(${service.totalReviews})',
                                  style: const TextStyle(
                                    fontSize: AppFontSizes.extraSmall,
                                    color: ColorRes.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),

                            // ── Price ─────────────────────────────────────
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: Formatter.formatPriceRange(
                                      service.meta.minPrice,
                                      service.meta.maxPrice,
                                    ),
                                    style: const TextStyle(
                                      fontSize: AppFontSizes.medium,
                                      fontWeight: AppFontWeights.bold,
                                      color: ColorRes.textColor,
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
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),

                            // ── Bottom Meta Section (unchanged) ───────────
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

  Padding contractorBasicDetails(String title, String value) {
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
          SizedBox(width: 10),
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
    final meta = service.meta;

    // Collect all non-empty meta rows
    List<Widget> _buildAllMetaWidgets() {
      final List<Widget> rows = [];

      Widget chip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: ColorRes.leadGreyColor.shade100,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: AppFontSizes.extraSmall,
            color: ColorRes.textSecondary,
          ),
        ),
      );

      void addRow(String label, List<String>? values) {
        if (values == null || values.isEmpty) return;
        rows.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 95,
                  child: Text(
                    '$label:',
                    style: const TextStyle(
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: values.map((v) => chip(v)).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      void addString(String label, String? value) {
        if (value == null || value.isEmpty) return;
        rows.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 95,
                  child: Text(
                    '$label:',
                    style: const TextStyle(
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: AppFontSizes.extraSmall,
                      color: ColorRes.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      void addYesNo(String label, String? value) {
        if (value == null || value.isEmpty) return;
        final isYes = value == 'YES';
        rows.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                SizedBox(
                  width: 95,
                  child: Text(
                    '$label:',
                    style: const TextStyle(
                      fontSize: AppFontSizes.small,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textColor,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isYes
                            ? Colors.green.shade50
                            : ColorRes.leadGreyColor.shade100,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color:
                          isYes
                              ? Colors.green.shade300
                              : ColorRes.leadGreyColor.shade300,
                    ),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: AppFontSizes.extraSmall,
                      fontWeight: AppFontWeights.semiBold,
                      color:
                          isYes
                              ? Colors.green.shade700
                              : ColorRes.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Visit Charge
      if (meta.visitCharge > 0)
        addString('Visit Charge', '₹${meta.visitCharge}');

      // Brands
      addString('Brands', meta.brandsUsed);

      // Material Lists
      addRow('Cement', meta.cementBrand);
      addRow('Steel', meta.steelBrand);
      addRow('Bricks', meta.brickType);
      addRow('Sand', meta.sandSource);
      addRow('Elec. Wires', meta.electricalWiresBrand);
      addRow('Switches', meta.electricalSwitchesBrand);
      addRow('Plumbing', meta.plumbingPipesBrand);
      addRow('Sanitary', meta.sanitaryFittingsBrand);
      addRow('Water Tank', meta.waterTankBrand);
      addRow('Flooring', meta.flooringTilesBrand);
      addRow('Int. Paint', meta.interiorPaintBrand);
      addRow('Ext. Paint', meta.exteriorPaintBrand);
      addRow('Doors', meta.doorsType);
      addRow('Windows', meta.windowsType);
      addRow('Structure', meta.structure);
      addRow('Plaster', meta.plasterType);
      addRow('Waterproofing', meta.waterproofing);
      addRow('Chokhat', meta.chokhatType);
      addRow('Railing', meta.railingType);
      addRow('False Ceiling', meta.falseCeiling);
      addRow('Fabrication', meta.fabricationWork);

      // Yes / No
      addYesNo('3D Design', meta.threeDDesign);
      addYesNo('Mod. Kitchen', meta.modularKitchen);
      addYesNo('Bore & Pump', meta.boreAndPump);
      addYesNo('Security', meta.securitySystems);
      addYesNo('Home Auto.', meta.homeAutomation);
      addYesNo('Solar', meta.solarSolutions);

      // Payment & Billing
      addRow('Payment', meta.acceptedPaymentModes);
      addString('Billing', meta.billingType == 'gst' ? 'GST' : 'Non-GST');
      if (meta.advanceRequiredPercentage > 0) {
        addString('Advance', '${meta.advanceRequiredPercentage}%');
      }

      return rows;
    }

    const int minVisible = 4;

    return StatefulBuilder(
      builder: (context, setState) {
        bool isExpanded = false; // local state per card

        return StatefulBuilder(
          builder: (context, setInnerState) {
            final allRows = _buildAllMetaWidgets();
            final hasMore = allRows.length > minVisible;
            final visibleRows =
                isExpanded ? allRows : allRows.take(minVisible).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Rating & Reviews ──────────────────────────
                /*  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: ColorRes.homeYellow, size: 13),
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
                const SizedBox(height: 4),

                // ── Price ──────────────────────────────────────
                Center(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: Formatter.formatPriceRange(meta.minPrice, meta.maxPrice),
                          style: const TextStyle(
                            fontSize: AppFontSizes.medium,
                            fontWeight: AppFontWeights.bold,
                            color: ColorRes.primary,
                          ),
                        ),
                        TextSpan(
                          text: ' /${meta.priceModel}',
                          style: const TextStyle(
                            fontSize: AppFontSizes.extraSmall,
                            color: ColorRes.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
*/
                // ── Meta Rows ──────────────────────────────────
                if (allRows.isEmpty)
                  const Center(
                    child: Text(
                      'No additional details',
                      style: TextStyle(
                        fontSize: AppFontSizes.extraSmall,
                        color: ColorRes.textDisabled,
                      ),
                    ),
                  )
                else
                  ...visibleRows,

                // ── Show More / Less Button ────────────────────
                if (hasMore)
                  GestureDetector(
                    onTap: () => setInnerState(() => isExpanded = !isExpanded),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isExpanded
                                ? 'Show Less'
                                : '+${allRows.length - minVisible} more',
                            style: const TextStyle(
                              fontSize: AppFontSizes.small,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 16,
                            color: ColorRes.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
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
