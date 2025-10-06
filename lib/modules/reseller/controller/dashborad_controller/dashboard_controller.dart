// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../model/dashboard/dashboard_model.dart';
//
// class DashboardController extends GetxController {
//   final RxBool isLoading = false.obs;
//   final RxBool isRefreshing = false.obs;
//   final Rx<DashboardMetrics> metrics = DashboardMetrics(
//     totalSales: 0,
//     totalLeads: 0,
//     totalProducts: 0,
//     growthPercentage: 0,
//   ).obs;
//
//   final RxList<Lead> recentLeads = <Lead>[].obs;
//   final RxList<Product> topProducts = <Product>[].obs;
//   final RxList<Product> _allProducts = <Product>[].obs;
//   final RxList<Product> filteredProducts = <Product>[].obs;
//   final RxString searchQuery = ''.obs;
//   final RxString selectedCategory = 'All'.obs;
//   final RxDouble minPrice = 0.0.obs;
//   final RxDouble maxPrice = 1000.0.obs;
//   final RxDouble filterMinPrice = 0.0.obs;
//   final RxDouble filterMaxPrice = 1000.0.obs;
//   final Rx<SortOption> sortOption = SortOption.name.obs;
//
//   final RxString error = ''.obs;
//   final RxBool showFilters = false.obs;
//
//   // Categories
//   final RxList<String> categories = <String>[
//     'All',
//     'Electronics',
//     'Clothing',
//     'Books',
//     'Home & Garden',
//     'Sports',
//     'Beauty'
//   ].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadProducts();
//     fetchDashboardData();
//     // Simulate real-time updates every 30 seconds
//     _startRealTimeUpdates();
//     ever(searchQuery, (_) => applyFilters());
//     ever(selectedCategory, (_) => applyFilters());
//     ever(filterMinPrice, (_) => applyFilters());
//     ever(filterMaxPrice, (_) => applyFilters());
//     ever(sortOption, (_) => applySorting());
//   }
//   // Add these methods to your existing DashboardController class
//
// // Lead Management Methods
//   void addLead(Lead lead) {
//     recentLeads.insert(0, lead);
//     // Update metrics
//     final currentMetrics = metrics.value;
//     metrics.value = DashboardMetrics(
//       totalSales: currentMetrics.totalSales,
//       totalLeads: currentMetrics.totalLeads + 1,
//       totalProducts: currentMetrics.totalProducts,
//       growthPercentage: currentMetrics.growthPercentage,
//     );
//   }
//
//   void updateLead(Lead updatedLead) {
//     final index = recentLeads.indexWhere((lead) => lead.id == updatedLead.id);
//     if (index != -1) {
//       recentLeads[index] = updatedLead;
//     }
//   }
//
//   void deleteLead(String leadId) {
//     recentLeads.removeWhere((lead) => lead.id == leadId);
//     // Update metrics
//     final currentMetrics = metrics.value;
//     metrics.value = DashboardMetrics(
//       totalSales: currentMetrics.totalSales,
//       totalLeads: currentMetrics.totalLeads - 1,
//       totalProducts: currentMetrics.totalProducts,
//       growthPercentage: currentMetrics.growthPercentage,
//     );
//   }
//
//   Lead? getLeadById(String id) {
//     try {
//       return recentLeads.firstWhere((lead) => lead.id == id);
//     } catch (e) {
//       return null;
//     }
//   }
//
// // Filter and Search Methods (these were already partially implemented)
//   List<Lead> getFilteredLeads() {
//     List<Lead> filtered = recentLeads.where((lead) {
//       bool matchesSearch = searchQuery.value.isEmpty ||
//           lead.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
//           lead.company.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
//           lead.email.toLowerCase().contains(searchQuery.value.toLowerCase());
//
//       bool matchesCategory = selectedCategory.value == 'All' ||
//           _getStatusText(lead.status) == selectedCategory.value;
//
//       return matchesSearch && matchesCategory;
//     }).toList();
//
//     return filtered;
//   }
//
//   String _getStatusText(LeadStatus status) {
//     switch (status) {
//       case LeadStatus.new_:
//         return 'New';
//       case LeadStatus.contacted:
//         return 'Contacted';
//       case LeadStatus.qualified:
//         return 'Qualified';
//       case LeadStatus.proposal:
//         return 'Proposal';
//       case LeadStatus.closed:
//         return 'Closed';
//       case LeadStatus.lost:
//         return 'Lost';
//     }
//   }
//
// // Update the existing fetchDashboardData method to include more complete lead data
//   Future<void> fetchDashboardData() async {
//     try {
//       isLoading.value = true;
//
//       // Simulate API delay
//       await Future.delayed(const Duration(seconds: 2));
//
//       // Mock data with enhanced lead information
//       metrics.value = DashboardMetrics(
//         totalSales: 125430.50,
//         totalLeads: 45,
//         totalProducts: 12,
//         growthPercentage: 15.7,
//       );
//
//       recentLeads.value = [
//         Lead(
//           id: '1',
//           name: 'John Smith',
//           company: 'Tech Corp',
//           email: 'john@techcorp.com',
//           phone: '+1-555-0123',
//           estimatedValue: 15000,
//           status: LeadStatus.qualified,
//           notes: 'Interested in premium package, scheduled demo for next week.',
//           createdAt: DateTime.now().subtract(const Duration(hours: 2)),
//         ),
//         Lead(
//           id: '2',
//           name: 'Sarah Johnson',
//           company: 'Digital Solutions',
//           email: 'sarah@digitalsolutions.com',
//           phone: '+1-555-0124',
//           estimatedValue: 25000,
//           status: LeadStatus.proposal,
//           notes: 'Requested custom proposal with additional features.',
//           createdAt: DateTime.now().subtract(const Duration(hours: 5)),
//         ),
//         Lead(
//           id: '3',
//           name: 'Mike Wilson',
//           company: 'StartupXYZ',
//           email: 'mike@startupxyz.com',
//           phone: '+1-555-0125',
//           estimatedValue: 8000,
//           status: LeadStatus.contacted,
//           notes: 'Initial contact made, follow up scheduled for next week.',
//           createdAt: DateTime.now().subtract(const Duration(days: 1)),
//         ),
//         Lead(
//           id: '4',
//           name: 'Emma Davis',
//           company: 'Global Inc',
//           email: 'emma@globalinc.com',
//           phone: '+1-555-0126',
//           estimatedValue: 35000,
//           status: LeadStatus.new_,
//           notes: 'High value prospect, needs immediate attention.',
//           createdAt: DateTime.now().subtract(const Duration(days: 2)),
//         ),
//         Lead(
//           id: '5',
//           name: 'Robert Brown',
//           company: 'Innovation Labs',
//           email: 'robert@innovationlabs.com',
//           phone: '+1-555-0127',
//           estimatedValue: 12000,
//           status: LeadStatus.qualified,
//           notes: 'Ready for product demo, very interested.',
//           createdAt: DateTime.now().subtract(const Duration(days: 3)),
//         ),
//         Lead(
//           id: '6',
//           name: 'Lisa Anderson',
//           company: 'Future Tech',
//           email: 'lisa@futuretech.com',
//           phone: '+1-555-0128',
//           estimatedValue: 45000,
//           status: LeadStatus.closed,
//           notes: 'Deal closed successfully, payment received.',
//           createdAt: DateTime.now().subtract(const Duration(days: 5)),
//         ),
//       ];
//
//       topProducts.value = [
//         Product(
//           id: '1',
//           name: 'RedStone Station',
//           category: '22 Crystal St, NY', // address
//           price: 3095,                   // rent/price
//           rating: 4.8,
//           stock: 1,
//           image: 'https://picsum.photos/100/100?random=1',
//           description: 'Modern villa with large living area',
//           beds: 6,
//           area: 200,
//           garage: 2,
//         ),
//         Product(
//           id: '2',
//           name: 'Blue Lagoon House',
//           category: '45 Ocean Dr, Miami',
//           price: 2950,
//           rating: 4.7,
//           stock: 1,
//           image: 'https://picsum.photos/100/100?random=2',
//           description: 'Beautiful seaside home with ocean view',
//           beds: 4,
//           area: 180,
//           garage: 1,
//         ),
//         Product(
//           id: '3',
//           name: 'City Loft Apartment',
//           category: '10 High St, Chicago',
//           price: 1800,
//           rating: 4.3,
//           stock: 1,
//           image: 'https://picsum.photos/100/100?random=3',
//           description: 'Modern city loft with open floor plan',
//           beds: 2,
//           area: 90,
//           garage: 0,
//         ),
//       ];
//
//
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to load dashboard data',
//           backgroundColor: Colors.red, colorText: Colors.white);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void loadProducts() {
//     isLoading.value = true;
//     error.value = '';
//
//     try {
//       // Simulate API call
//       Future.delayed(Duration(seconds: 1), () {
//         _allProducts.assignAll(_generateDummyProducts());
//         _updatePriceRange();
//         applyFilters();
//         isLoading.value = false;
//       });
//     } catch (e) {
//       error.value = 'Failed to load products';
//       isLoading.value = false;
//     }
//   }
//
//   List<Product> _generateDummyProducts() {
//     return [
//       Product(
//         id: '1',
//         name: 'RedStone Station',
//         category: '22 Crystal St, NY',
//         price: 3095,
//         rating: 4.8,
//         stock: 1,
//         image: 'https://picsum.photos/400/250?random=1',
//         description: 'Modern villa with large living area',
//         beds: 6,
//         area: 200,
//         garage: 2,
//       ),
//       Product(
//         id: '2',
//         name: 'Blue Lagoon House',
//         category: '45 Ocean Dr, Miami',
//         price: 2950,
//         rating: 4.7,
//         stock: 1,
//         image: 'https://picsum.photos/400/250?random=2',
//         description: 'Beautiful seaside home with ocean view',
//         beds: 4,
//         area: 180,
//         garage: 1,
//       ),
//       Product(
//         id: '3',
//         name: 'Green Valley Villa',
//         category: '78 Pine Rd, Denver',
//         price: 2500,
//         rating: 4.5,
//         stock: 1,
//         image: 'https://picsum.photos/400/250?random=3',
//         description: 'Spacious villa surrounded by nature',
//         beds: 5,
//         area: 220,
//         garage: 2,
//       ),
//       Product(
//         id: '4',
//         name: 'City Loft Apartment',
//         category: '10 High St, Chicago',
//         price: 1800,
//         rating: 4.3,
//         stock: 1,
//         image: 'https://picsum.photos/400/250?random=4',
//         description: 'Modern city loft with open floor plan',
//         beds: 2,
//         area: 90,
//         garage: 0,
//       ),
//       Product(
//         id: '5',
//         name: 'Sunny Side Residence',
//         category: '501 Sunset Blvd, LA',
//         price: 2700,
//         rating: 4.6,
//         stock: 1,
//         image: 'https://picsum.photos/400/250?random=5',
//         description: 'Bright home with large backyard',
//         beds: 3,
//         area: 150,
//         garage: 1,
//       ),
//       Product(
//         id: '6',
//         name: 'Hilltop Mansion',
//         category: '90 Hillview, SF',
//         price: 4800,
//         rating: 4.9,
//         stock: 1,
//         image: 'https://picsum.photos/400/250?random=6',
//         description: 'Luxury mansion on hilltop with city view',
//         beds: 7,
//         area: 350,
//         garage: 3,
//       ),
//       Product(
//         id: '7',
//         name: 'Lakeview Cottage',
//         category: '77 Lake Rd, Seattle',
//         price: 2100,
//         rating: 4.4,
//         stock: 1,
//         image: 'https://picsum.photos/400/250?random=7',
//         description: 'Cozy cottage near the lake',
//         beds: 3,
//         area: 120,
//         garage: 1,
//       ),
//       Product(
//         id: '8',
//         name: 'Downtown Condo',
//         category: '12 Center St, Boston',
//         price: 1600,
//         rating: 4.2,
//         stock: 1,
//         image: 'https://picsum.photos/400/250?random=8',
//         description: 'Affordable condo in downtown area',
//         beds: 2,
//         area: 80,
//         garage: 0,
//       ),
//       Product(
//         id: '9',
//         name: 'Palm Beach Villa',
//         category: '300 Palm St, Florida',
//         price: 3500,
//         rating: 4.7,
//         stock: 1,
//         image: 'https://picsum.photos/400/250?random=9',
//         description: 'Villa with private pool and palm garden',
//         beds: 5,
//         area: 230,
//         garage: 2,
//       ),
//       Product(
//         id: '10',
//         name: 'Maplewood House',
//         category: '120 Maple Ave, Austin',
//         price: 1900,
//         rating: 4.3,
//         stock: 1,
//         image: 'https://picsum.photos/400/250?random=10',
//         description: 'Family-friendly house in quiet neighborhood',
//         beds: 3,
//         area: 140,
//         garage: 1,
//       ),
//     ];
//   }
//
//
//   void _updatePriceRange() {
//     if (_allProducts.isNotEmpty) {
//       double min = _allProducts.map((p) => p.price).reduce((a, b) => a < b ? a : b);
//       double max = _allProducts.map((p) => p.price).reduce((a, b) => a > b ? a : b);
//       minPrice.value = min;
//       maxPrice.value = max;
//       filterMinPrice.value = min;
//       filterMaxPrice.value = max;
//     }
//   }
//
//   void applyFilters() {
//     List<Product> filtered = _allProducts.where((product) {
//       bool matchesSearch = searchQuery.value.isEmpty ||
//           product.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
//           product.description.toLowerCase().contains(searchQuery.value.toLowerCase());
//
//       bool matchesCategory = selectedCategory.value == 'All' ||
//           product.category == selectedCategory.value;
//
//       bool matchesPrice = product.price >= filterMinPrice.value &&
//           product.price <= filterMaxPrice.value;
//
//       return matchesSearch && matchesCategory && matchesPrice;
//     }).toList();
//
//     filteredProducts.assignAll(filtered);
//     applySorting();
//   }
//
//   void applySorting() {
//     List<Product> sorted = List.from(filteredProducts);
//
//     switch (sortOption.value) {
//       case SortOption.name:
//         sorted.sort((a, b) => a.name.compareTo(b.name));
//         break;
//       case SortOption.priceAsc:
//         sorted.sort((a, b) => a.price.compareTo(b.price));
//         break;
//       case SortOption.priceDesc:
//         sorted.sort((a, b) => b.price.compareTo(a.price));
//         break;
//       case SortOption.rating:
//         sorted.sort((a, b) => b.rating.compareTo(a.rating));
//         break;
//     }
//
//     filteredProducts.assignAll(sorted);
//   }
//
//   void updateSearch(String query) {
//     searchQuery.value = query;
//   }
//
//   void updateCategory(String category) {
//     selectedCategory.value = category;
//   }
//
//   void updatePriceRange(double min, double max) {
//     filterMinPrice.value = min;
//     filterMaxPrice.value = max;
//   }
//
//   void updateSortOption(SortOption option) {
//     sortOption.value = option;
//   }
//
//   void clearFilters() {
//     searchQuery.value = '';
//     selectedCategory.value = 'All';
//     filterMinPrice.value = minPrice.value;
//     filterMaxPrice.value = maxPrice.value;
//     sortOption.value = SortOption.name;
//   }
//
//   void toggleFilters() {
//     showFilters.value = !showFilters.value;
//   }
//
//
//
//   void _startRealTimeUpdates() {
//     Stream.periodic(const Duration(seconds: 30)).listen((_) {
//       if (!isRefreshing.value) {
//         _updateMetricsRealTime();
//       }
//     });
//   }
//   //
//   // Future<void> fetchDashboardData() async {
//   //   try {
//   //     isLoading.value = true;
//   //
//   //     // Simulate API delay
//   //     await Future.delayed(const Duration(seconds: 2));
//   //
//   //     // Mock data
//   //     metrics.value = DashboardMetrics(
//   //       totalSales: 125430.50,
//   //       totalLeads: 45,
//   //       totalProducts: 12,
//   //       growthPercentage: 15.7,
//   //     );
//   //
//   //     recentLeads.value = [
//   //       Lead(
//   //         id: '1',
//   //         name: 'John Smith',
//   //         company: 'Tech Corp',
//   //         estimatedValue: 15000,
//   //         status: LeadStatus.qualified,
//   //         createdAt: DateTime.now().subtract(const Duration(hours: 2)),
//   //       ),
//   //       Lead(
//   //         id: '2',
//   //         name: 'Sarah Johnson',
//   //         company: 'Digital Solutions',
//   //         estimatedValue: 25000,
//   //         status: LeadStatus.proposal,
//   //         createdAt: DateTime.now().subtract(const Duration(hours: 5)),
//   //       ),
//   //       Lead(
//   //         id: '3',
//   //         name: 'Mike Wilson',
//   //         company: 'StartupXYZ',
//   //         estimatedValue: 8000,
//   //         status: LeadStatus.contacted,
//   //         createdAt: DateTime.now().subtract(const Duration(days: 1)),
//   //       ),
//   //       Lead(
//   //         id: '4',
//   //         name: 'Emma Davis',
//   //         company: 'Global Inc',
//   //         estimatedValue: 35000,
//   //         status: LeadStatus.new_,
//   //         createdAt: DateTime.now().subtract(const Duration(days: 2)),
//   //       ),
//   //     ];
//   //
//   //
//   //
//   //   } catch (e) {
//   //     Get.snackbar('Error', 'Failed to load dashboard data',
//   //         backgroundColor: Colors.red, colorText: Colors.white);
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }
//
//   Future<void> refreshDashboard() async {
//     try {
//       isRefreshing.value = true;
//       await Future.delayed(const Duration(seconds: 1));
//
//       // Update metrics with new values
//       final currentMetrics = metrics.value;
//       metrics.value = DashboardMetrics(
//         totalSales: currentMetrics.totalSales + (50 + (DateTime.now().millisecond % 500)),
//         totalLeads: currentMetrics.totalLeads + (DateTime.now().second % 3),
//         totalProducts: currentMetrics.totalProducts,
//         growthPercentage: currentMetrics.growthPercentage + ((DateTime.now().millisecond % 100 - 50) / 100),
//       );
//
//       Get.snackbar('Success', 'Dashboard refreshed',
//           backgroundColor: Colors.green, colorText: Colors.white);
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to refresh dashboard',
//           backgroundColor: Colors.red, colorText: Colors.white);
//     } finally {
//       isRefreshing.value = false;
//     }
//   }
//
//   void _updateMetricsRealTime() {
//     final currentMetrics = metrics.value;
//     metrics.value = DashboardMetrics(
//       totalSales: currentMetrics.totalSales + (10 + (DateTime.now().millisecond % 100)),
//       totalLeads: currentMetrics.totalLeads + (DateTime.now().second % 5 == 0 ? 1 : 0),
//       totalProducts: currentMetrics.totalProducts,
//       growthPercentage: currentMetrics.growthPercentage + ((DateTime.now().millisecond % 20 - 10) / 100),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/global.dart';
import '../../model/dashboard/dashboard_model.dart';
import '../../model/reseller_lead_model/reseller_lead_overview.dart';

class DashboardController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isResellerDetailExpanded = false.obs;
  final Rx<DashboardMetrics> metrics =
      DashboardMetrics(
        totalSales: 0,
        totalLeads: 0,
        totalProducts: 0,
        growthPercentage: 0,
      ).obs;

  final RxList<Lead> recentLeads = <Lead>[].obs;
  final RxList<Product> topProducts = <Product>[].obs;
  final RxList<ResellerLeadOverview> _allProducts = <ResellerLeadOverview>[]
      .obs;
  final RxList<ResellerLeadOverview> filteredProducts = <ResellerLeadOverview>[]
      .obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString selectedCategoryInLead = "All".obs;
  final RxList<String> selectedProductCategories = <String>[].obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 1000.0.obs;
  final RxDouble filterMinPrice = 0.0.obs;
  final RxDouble filterMaxPrice = 1000.0.obs;
  final Rx<SortOption> sortOption = SortOption.name.obs;
  RxDouble submittedOfferAmount = 0.0.obs;
  final RxList<String> selectedLeadFilters = <String>[].obs;
  final RxString error = ''.obs;
  final RxBool showFilters = false.obs;
  final offerController = TextEditingController();
  final messageController = TextEditingController();

  // Categories
  final RxList<String> categories = <String>[
    'All',
    'Apartment',
    'Villa',
    'Plot',
    'Independent Floor',
    'Showroom',

    'Independent House',
    'Penthouse',
    'Office',
  ].obs;


  @override
  void onInit() {
    super.onInit();
    loadProducts();
    fetchDashboardData();
    // Simulate real-time updates every 30 seconds
    _startRealTimeUpdates();
    ever(searchQuery, (_) => applyFilters());
    ever(selectedCategory, (_) => applyFilters());
    ever(filterMinPrice, (_) => applyFilters());
    ever(filterMaxPrice, (_) => applyFilters());
    ever(sortOption, (_) => applySorting());
  }

  void toggleExpanded() {
    isResellerDetailExpanded.value = !isResellerDetailExpanded.value;
  }

  // var selectedStage = ''.obs;
  // void updateLeadStage(String stage) {
  //   selectedStage.value = stage;
  // }
  void addLeadFilter(String filter) {
    if (!selectedLeadFilters.contains(filter)) {
      selectedLeadFilters.add(filter);
    }
  }

  void removeLeadFilter(String filter) {
    selectedLeadFilters.remove(filter);
  }

  void clearLeadFilters() {
    selectedLeadFilters.clear();
  }

  // Lead Management Methods
  void addLead(Lead lead) {
    recentLeads.insert(0, lead);
    // Update metrics
    final currentMetrics = metrics.value;
    metrics.value = DashboardMetrics(
      totalSales: currentMetrics.totalSales,
      totalLeads: currentMetrics.totalLeads + 1,
      totalProducts: currentMetrics.totalProducts,
      growthPercentage: currentMetrics.growthPercentage,
    );
  }

  void updateLead(Lead updatedLead) {
    final index = recentLeads.indexWhere((lead) => lead.id == updatedLead.id);
    if (index != -1) {
      recentLeads[index] = updatedLead;
    }
  }

  void deleteLead(String leadId) {
    recentLeads.removeWhere((lead) => lead.id == leadId);
    // Update metrics
    final currentMetrics = metrics.value;
    metrics.value = DashboardMetrics(
      totalSales: currentMetrics.totalSales,
      totalLeads: currentMetrics.totalLeads - 1,
      totalProducts: currentMetrics.totalProducts,
      growthPercentage: currentMetrics.growthPercentage,
    );
  }

  Lead? getLeadById(String id) {
    try {
      return recentLeads.firstWhere((lead) => lead.id == id);
    } catch (e) {
      return null;
    }
  }

  // Updated controller methods for multi-select filtering

  // Filter and Search Methods
  List<Lead> getFilteredLeads() {
    List<Lead> filtered =
    recentLeads.where((lead) {
      // Search filter
      bool matchesSearch =
          searchQuery.value.isEmpty ||
              lead.name.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ) ||
              lead.company.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              ) ||
              lead.email.toLowerCase().contains(
                searchQuery.value.toLowerCase(),
              );

      // Multi-filter selection logic
      bool matchesFilters = true;

      if (selectedLeadFilters.isNotEmpty) {
        // Separate stage and status filters
        final stageFilters =
        selectedLeadFilters
            .where((f) => f.startsWith('Stage:'))
            .map((f) => f.split(':')[1].trim())
            .toList();

        final statusFilters =
        selectedLeadFilters
            .where((f) => f.startsWith('Status:'))
            .map((f) => f.split(':')[1].trim())
            .toList();

        bool matchesStage =
            stageFilters.isEmpty; // Default true if no stage filters
        bool matchesStatus =
            statusFilters.isEmpty; // Default true if no status filters

        // Get lead's stage and status text
        final leadStageText = _getStageText(lead.stage);
        final leadStatusText = _getStatusText(lead.status);

        // If stage filters exist, check if lead's stage matches any of them
        if (stageFilters.isNotEmpty) {
          matchesStage = stageFilters.contains(leadStageText);
        }

        // If status filters exist, check if lead's status matches any of them
        if (statusFilters.isNotEmpty) {
          matchesStatus = statusFilters.contains(leadStatusText);
        }

        matchesFilters = matchesStage && matchesStatus;
      }

      return matchesSearch && matchesFilters;
    }).toList();

    return filtered;
  }


  String _getStatusText(LeadStatus status) {
    switch (status) {
      case LeadStatus.new_:
        return 'New';
      case LeadStatus.contacted:
        return 'Contacted';
      case LeadStatus.qualified:
        return 'Qualified';
      case LeadStatus.negotiation:
        return 'Negotiating';
      case LeadStatus.lost:
        return 'Lost';
      case LeadStatus.convert:
        return 'Converted';
      case LeadStatus.all:
      default:
        return 'All';
    }
  }

  String _getStageText(LeadStage stage) {
    switch (stage) {
      case LeadStage.newLead:
        return 'New Lead';
      case LeadStage.contacted:
        return 'Contacted';
      case LeadStage.interested:
        return 'Interested';
      case LeadStage.siteVisit:
        return 'Site Visit';
      case LeadStage.sell:
        return 'Sell';
      case LeadStage.all:
      default:
        return 'All';
    }
  }

  // Fetch Dashboard Data with Property Seller Focus
  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock data with property seller information
      metrics.value = DashboardMetrics(
        totalSales: 2850000.00, // Total property sales
        totalLeads: 28, // Active buyer leads
        totalProducts: 12, // Listed properties
        growthPercentage: 18.5, // Sales growth
      );

      recentLeads.value = [
        Lead(
          id: '1',
          name: 'Michael Anderson',
          company: 'Downtown Manhattan, NY',
          email: 'michael.a@gmail.com',
          phone: '+1-555-0201',
          estimatedValue: 850000,
          status: LeadStatus.qualified,
          property: 'Luxury Lakeside Villa with Private Pool',
          // ✅ new enum
          stage: LeadStage.interested,
          // add stage
          notes:
          'Looking for 3-bed luxury apartment, prefers high floor with city view. Budget flexible.',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
        Lead(
          id: '2',
          name: 'Jennifer Wu',
          company: 'Brooklyn Heights, NY',
          email: 'jennifer.wu@outlook.com',
          phone: '+1-555-0202',
          estimatedValue: 620000,
          status: LeadStatus.negotiation,
          // was proposal
          property: 'Spacious 4BHK Apartment with City View',
          stage: LeadStage.siteVisit,
          notes:
          'Interested in RedStone Station property. Submitted offer, awaiting seller response.',
          createdAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),
        Lead(
          id: '3',
          name: 'Robert Martinez',
          company: 'Queens, NY',
          email: 'r.martinez@gmail.com',
          phone: '+1-555-0203',
          property: 'Prime Office Space in Connaught Place',
          estimatedValue: 480000,
          status: LeadStatus.contacted,
          stage: LeadStage.contacted,
          notes:
          'First-time buyer, needs mortgage assistance. Showed 2 properties, following up.',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Lead(
          id: '4',
          name: 'Emily Thompson',
          company: 'Upper West Side, NY',
          email: 'emily.t@hotmail.com',
          phone: '+1-555-0204',
          estimatedValue: 1200000,
          status: LeadStatus.new_,
          // ✅ new enum
          property: 'Sea-facing 3BHK Apartment',
          stage: LeadStage.newLead,
          notes:
          'High-value prospect, wants 4+ bed penthouse. Urgent - relocating in 2 months.',
          createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        ),
        Lead(
          id: '5',
          name: 'David Kim',
          company: 'Chelsea, Manhattan',
          email: 'david.kim@gmail.com',
          phone: '+1-555-0205',
          estimatedValue: 720000,
          status: LeadStatus.qualified,
          stage: LeadStage.siteVisit,
          property: 'Modern 2BHK Flat near IT Park',
          notes:
          'Shown Blue Lagoon House, very interested. Ready for site visit this weekend.',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Lead(
          id: '6',
          name: 'Sarah Johnson',
          company: 'Financial District, NY',
          email: 'sarah.j@company.com',
          phone: '+1-555-0206',
          estimatedValue: 950000,
          status: LeadStatus.convert,
          // was closed
          stage: LeadStage.sell,
          property: '4BHK Penthouse with Private Terrace',
          notes:
          'Deal closed! Purchased City Loft Apartment. Payment received, closing scheduled.',
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
        Lead(
          id: '7',
          name: 'James Wilson',
          company: 'Tribeca, NY',
          email: 'j.wilson@email.com',
          phone: '+1-555-0207',
          estimatedValue: 1500000,
          status: LeadStatus.negotiation,
          // was proposal
          property: '3BHK Luxury Flat with Park View',
          stage: LeadStage.siteVisit,
          notes:
          'Negotiating on Hilltop Mansion. Counter-offer submitted. High probability close.',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Lead(
          id: '8',
          name: 'Lisa Chen',
          company: 'Soho, NY',
          email: 'lisa.chen@startup.com',
          phone: '+1-555-0208',
          estimatedValue: 580000,
          status: LeadStatus.contacted,
          property: 'Affordable 1BHK Studio Apartment',
          stage: LeadStage.contacted,
          notes:
          'Young professional, interested in modern lofts. Scheduled viewing next Tuesday.',
          createdAt: DateTime.now().subtract(const Duration(hours: 18)),
        ),
      ];

      topProducts.value = [
        Product(
          id: '1',
          name: 'RedStone Station',
          category: '22 Crystal St, NY',
          price: 3095,
          rating: 4.8,
          stock: 1,
          image: 'https://picsum.photos/400/250?random=2',
          description: 'Modern villa with large living area',
          beds: 6,
          area: 200,
          garage: 2,
        ),
        Product(
          id: '2',
          name: 'Blue Lagoon House',
          category: '45 Ocean Dr, Miami',
          price: 2950,
          rating: 4.7,
          stock: 1,
          image: 'https://picsum.photos/400/250?random=3',
          description: 'Beautiful seaside home with ocean view',
          beds: 4,
          area: 180,
          garage: 1,
        ),
        Product(
          id: '3',
          name: 'City Loft Apartment',
          category: '10 High St, Chicago',
          price: 1800,
          rating: 4.3,
          stock: 1,
          image: 'https://picsum.photos/400/250?random=4',
          description: 'Modern city loft with open floor plan',
          beds: 2,
          area: 90,
          garage: 0,
        ),
      ];
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load dashboard data',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void loadProducts() {
    isLoading.value = true;
    error.value = '';

    try {
      Future.delayed(Duration(seconds: 1), () {
        _allProducts.assignAll(dummyResellerLeads);
        _updatePriceRange(); // ✅ This sets min/max prices
        applyFilters(); // ✅ This applies initial filters
        isLoading.value = false;
        print('✅ Loaded ${_allProducts.length} products');
      });
    } catch (e) {
      error.value = 'Failed to load products';
      isLoading.value = false;
      print('❌ Error loading products: $e');
    }
  }

  final List<ResellerLeadOverview> dummyResellerLeads = [
    // ───── Existing Leads ─────
    ResellerLeadOverview(
      id: "wZuCaH0VeeY2MmHGfDsl7Xu",
      createdBy: "Dn6Qh1b5eErAyjNUR8feRWC",
      updatedBy: "Agent123",
      name: "John Doe",
      email: "john.doe@example.com",
      phone: "9876543210",
      propertyId: "PcXNBFWtmuCNN1mpFbjeeZn",
      resellerId: "T3PWXm5AlA7XUEP1Iv5EK2v",
      source: "direct",
      status: "new",
      stage: "new_lead",
      notes: "Interested in scheduling a site visit next week",
      lastContactedAt: DateTime.parse("2025-09-28T15:30:00.000Z"),
      isFake: false,
      fakeReason: "",
      markedFakeBy: "",
      markedFakeAt: DateTime.parse("2025-09-26T11:48:01.000Z"),
      customFields: ResellerLeadCustomFields(
        city: "Udaipur",
        type: "residential",
        state: "Rajasthan",
        title: "Luxury Lakeside Villa with Private Pool",
        address: "42 Lake View Road, Villa Enclave",
        zipCode: "313001",
        builderName: "Prestige Luxury Homes",
        listingType: "Sell",
        projectName: "Lake Shore Villas",
        propertyType: "villa",
        propertyDetails: ResellerLeadPropertyDetails(
          bhk: 5,
          balcony: 3,
          bathroom: 6,
          amenities: [
            "Swimming Pool",
            "Garden",
            "Security",
            "Gym",
            "Home Theater",
            "BBQ Area",
          ],
          zoneType: "Residential",
          floorInfo: ResellerLeadFloorInfo(floorNumber: 0, totalFloors: 2),
          furnishInfo: ResellerLeadFurnishInfo(
            furnishType: "fully-furnished",
            furnishDetails: ResellerLeadFurnishDetails(
              bed: 5,
              fan: 10,
              other: "Home theater, Wine cellar, Library",
              balcony: true,
              kitchen: true,
              bathroom: true,
            ),
          ),
          parkingInfo: ResellerLeadParkingInfo(
            openParking: true,
            coveredParking: true,
          ),
          ///jhgfrehgki
          financialInfo: ResellerLeadFinancialInfo(
            negotiable: true,
            propertyPrice: 65000000,
            brokerCommission: 200000,
          ),
          possessionInfo: ResellerLeadPossessionInfo(
            possessionStatus: "Ready to Move",
            propertyAgeInYears: 2,
          ),
          propertyFacing: "East",
          propertyCondition: "ready-to-move",
          propertyCarpetArea: 4500,
          propertyBuiltUpArea: 5800,
        ),
      ),
      createdAt: DateTime.parse("2025-09-26T11:48:01.000Z"),
      updatedAt: DateTime.parse("2025-09-26T11:48:01.000Z"),
    ),
    ResellerLeadOverview(
      id: "XyZaB1C2dEfG3HiJkLmnOp",
      createdBy: "AbCdEfGhIjKlMnOpQrStUv",
      updatedBy: null,
      name: "Jane Smith",
      email: "jane.smith@example.com",
      phone: "9123456780",
      propertyId: "QrStUvWxYz1234567890",
      resellerId: "LmNoPqRsTuVwXyZaBcDeF",
      source: "referral",
      status: "contacted",
      stage: "follow_up",
      notes: "Interested in villa with garden",
      lastContactedAt: DateTime.parse("2025-09-28T10:30:00.000Z"),
      isFake: false,
      fakeReason: null,
      markedFakeBy: null,
      markedFakeAt: null,
      customFields: ResellerLeadCustomFields(
        city: "Jaipur",
        type: "residential",
        state: "Rajasthan",
        title: "Spacious 4BHK Apartment with City View",
        address: "101 City Center, Jaipur",
        zipCode: "302001",
        builderName: "Royal Estates",
        listingType: "Sell",
        projectName: "Royal Heights",
        propertyType: "apartment",
        propertyDetails: ResellerLeadPropertyDetails(
          bhk: 4,
          balcony: 2,
          bathroom: 4,
          amenities: ["Gym", "Swimming Pool", "Clubhouse", "Parking"],
          zoneType: "Residential",
          floorInfo: ResellerLeadFloorInfo(floorNumber: 3, totalFloors: 10),
          furnishInfo: ResellerLeadFurnishInfo(
            furnishType: "semi-furnished",
            furnishDetails: ResellerLeadFurnishDetails(
              bed: 4,
              fan: 6,
              other: "Modular Kitchen, Wardrobes",
              balcony: true,
              kitchen: true,
              bathroom: true,
            ),
          ),
          parkingInfo: ResellerLeadParkingInfo(
            openParking: true,
            coveredParking: false,
          ),
          financialInfo: ResellerLeadFinancialInfo(
            negotiable: false,
            propertyPrice: 35000000,
            brokerCommission: 150000,
          ),
          possessionInfo: ResellerLeadPossessionInfo(
            possessionStatus: "Under Construction",
            propertyAgeInYears: 0,
          ),
          propertyFacing: "North",
          propertyCondition: "under-construction",
          propertyCarpetArea: 2200,
          propertyBuiltUpArea: 2500,
        ),
      ),
      createdAt: DateTime.parse("2025-09-20T09:00:00.000Z"),
      updatedAt: DateTime.parse("2025-09-28T10:30:00.000Z"),
    ),

    // ───── Additional Dummy Leads ─────
    ResellerLeadOverview(
      id: "Lead003",
      createdBy: "Agent789",
      updatedBy: "Agent456",
      name: "Rahul Verma",
      email: "rahul.verma@example.com",
      phone: "9812345678",
      propertyId: "Prop003",
      resellerId: "Reseller003",
      source: "social_media",
      status: "negotiating",
      stage: "proposal_sent",
      notes: "Client negotiating on price, asked for lower commission",
      lastContactedAt: DateTime.parse("2025-09-27T12:00:00.000Z"),
      isFake: false,
      fakeReason: "",
      markedFakeBy: "",
      markedFakeAt: null,
      customFields: ResellerLeadCustomFields(
        city: "Delhi",
        type: "commercial",
        state: "Delhi",
        title: "Prime Office Space in Connaught Place",
        address: "E Block, Connaught Place",
        zipCode: "110001",
        builderName: "Metro Builders",
        listingType: "Lease",
        projectName: "Metro Towers",
        propertyType: "office",
        propertyDetails: ResellerLeadPropertyDetails(
          bhk: 0,
          balcony: 0,
          bathroom: 2,
          amenities: ["Central AC", "Power Backup", "Conference Room"],
          zoneType: "Commercial",
          floorInfo: ResellerLeadFloorInfo(floorNumber: 5, totalFloors: 12),
          furnishInfo: ResellerLeadFurnishInfo(
            furnishType: "fully-furnished",
            furnishDetails: ResellerLeadFurnishDetails(
              bed: 0,
              fan: 20,
              other: "Conference Room Setup",
              balcony: false,
              kitchen: false,
              bathroom: true,
            ),
          ),
          parkingInfo: ResellerLeadParkingInfo(
            openParking: false,
            coveredParking: true,
          ),
          financialInfo: ResellerLeadFinancialInfo(
            negotiable: true,
            propertyPrice: 1200000,
            brokerCommission: 50000,
          ),
          possessionInfo: ResellerLeadPossessionInfo(
            possessionStatus: "Immediate",
            propertyAgeInYears: 5,
          ),
          propertyFacing: "West",
          propertyCondition: "ready-to-move",
          propertyCarpetArea: 3000,
          propertyBuiltUpArea: 3500,
        ),
      ),
      createdAt: DateTime.parse("2025-09-15T10:00:00.000Z"),
      updatedAt: DateTime.parse("2025-09-27T12:00:00.000Z"),
    ),
    ResellerLeadOverview(
      id: "Lead004",
      createdBy: "Agent001",
      updatedBy: null,
      name: "Ayesha Khan",
      email: "ayesha.khan@example.com",
      phone: "9900112233",
      propertyId: "Prop004",
      resellerId: "Reseller004",
      source: "website",
      status: "sold",
      stage: "deal_closed",
      notes: "Villa sold successfully, awaiting commission",
      lastContactedAt: DateTime.parse("2025-09-22T18:30:00.000Z"),
      isFake: false,
      fakeReason: null,
      markedFakeBy: null,
      markedFakeAt: null,
      customFields: ResellerLeadCustomFields(
        city: "Mumbai",
        type: "residential",
        state: "Maharashtra",
        title: "Sea-facing 3BHK Apartment",
        address: "Marine Drive, Mumbai",
        zipCode: "400001",
        builderName: "Oceanic Realty",
        listingType: "Sell",
        projectName: "Marine Heights",
        propertyType: "apartment",
        propertyDetails: ResellerLeadPropertyDetails(
          bhk: 3,
          balcony: 2,
          bathroom: 3,
          amenities: ["Swimming Pool", "Gym", "Security"],
          zoneType: "Residential",
          floorInfo: ResellerLeadFloorInfo(floorNumber: 7, totalFloors: 20),
          furnishInfo: ResellerLeadFurnishInfo(
            furnishType: "furnished",
            furnishDetails: ResellerLeadFurnishDetails(
              bed: 3,
              fan: 6,
              other: "Sea view balcony",
              balcony: true,
              kitchen: true,
              bathroom: true,
            ),
          ),
          parkingInfo: ResellerLeadParkingInfo(
            openParking: false,
            coveredParking: true,
          ),
          financialInfo: ResellerLeadFinancialInfo(
            negotiable: false,
            propertyPrice: 75000000,
            brokerCommission: 300000,
          ),
          possessionInfo: ResellerLeadPossessionInfo(
            possessionStatus: "Ready to Move",
            propertyAgeInYears: 1,
          ),
          propertyFacing: "South",
          propertyCondition: "ready-to-move",
          propertyCarpetArea: 1800,
          propertyBuiltUpArea: 2200,
        ),
      ),
      createdAt: DateTime.parse("2025-09-10T09:30:00.000Z"),
      updatedAt: DateTime.parse("2025-09-22T18:30:00.000Z"),
    ),
    ResellerLeadOverview(
      id: "Lead005",
      createdBy: "Agent999",
      updatedBy: "Agent123",
      name: "Karan Mehta",
      email: "karan.mehta@example.com",
      phone: "9988776655",
      propertyId: "Prop005",
      resellerId: "Reseller005",
      source: "broker",
      status: "lost",
      stage: "deal_lost",
      notes: "Client backed out due to high price",
      lastContactedAt: DateTime.parse("2025-09-19T16:00:00.000Z"),
      isFake: false,
      fakeReason: null,
      markedFakeBy: null,
      markedFakeAt: null,
      customFields: ResellerLeadCustomFields(
        city: "Pune",
        type: "residential",
        state: "Maharashtra",
        title: "Modern 2BHK Flat near IT Park",
        address: "Hinjewadi, Pune",
        zipCode: "411057",
        builderName: "TechCity Developers",
        listingType: "Sell",
        projectName: "IT Heights",
        propertyType: "apartment",
        propertyDetails: ResellerLeadPropertyDetails(
          bhk: 2,
          balcony: 1,
          bathroom: 2,
          amenities: ["Gym", "Security", "Power Backup"],
          zoneType: "Residential",
          floorInfo: ResellerLeadFloorInfo(floorNumber: 10, totalFloors: 15),
          furnishInfo: ResellerLeadFurnishInfo(
            furnishType: "unfurnished",
            furnishDetails: ResellerLeadFurnishDetails(
              bed: 0,
              fan: 0,
              other: "Bare shell",
              balcony: true,
              kitchen: true,
              bathroom: true,
            ),
          ),
          parkingInfo: ResellerLeadParkingInfo(
            openParking: true,
            coveredParking: false,
          ),
          financialInfo: ResellerLeadFinancialInfo(
            negotiable: true,
            propertyPrice: 8500000,
            brokerCommission: 50000,
          ),
          possessionInfo: ResellerLeadPossessionInfo(
            possessionStatus: "Under Construction",
            propertyAgeInYears: 0,
          ),
          propertyFacing: "East",
          propertyCondition: "under-construction",
          propertyCarpetArea: 1100,
          propertyBuiltUpArea: 1300,
        ),
      ),
      createdAt: DateTime.parse("2025-09-05T14:00:00.000Z"),
      updatedAt: DateTime.parse("2025-09-19T16:00:00.000Z"),
    ),
    // Add these at the end of your dummyResellerLeads list:
    ResellerLeadOverview(
      id: "Lead006",
      createdBy: "Agent777",
      updatedBy: "Agent888",
      name: "Neha Sharma",
      email: "neha.sharma@example.com",
      phone: "9876001122",
      propertyId: "Prop006",
      resellerId: "Reseller006",
      source: "email_campaign",
      status: "new",
      stage: "initial_contact",
      notes: "Requested brochure for 1BHK studio apartments",
      lastContactedAt: DateTime.parse("2025-09-29T11:00:00.000Z"),
      isFake: false,
      fakeReason: null,
      markedFakeBy: null,
      markedFakeAt: null,
      customFields: ResellerLeadCustomFields(
        city: "Bengaluru",
        type: "residential",
        state: "Karnataka",
        title: "Affordable 1BHK Studio Apartment",
        address: "Electronic City Phase 1, Bengaluru",
        zipCode: "560100",
        builderName: "Urban Homes",
        listingType: "Sell",
        projectName: "Urban Studios",
        propertyType: "apartment",
        propertyDetails: ResellerLeadPropertyDetails(
          bhk: 1,
          balcony: 1,
          bathroom: 1,
          amenities: ["Security", "Lift", "Power Backup"],
          zoneType: "Residential",
          floorInfo: ResellerLeadFloorInfo(floorNumber: 2, totalFloors: 8),
          furnishInfo: ResellerLeadFurnishInfo(
            furnishType: "semi-furnished",
            furnishDetails: ResellerLeadFurnishDetails(
              bed: 1,
              fan: 2,
              other: "Basic Wardrobe",
              balcony: true,
              kitchen: true,
              bathroom: true,
            ),
          ),
          parkingInfo: ResellerLeadParkingInfo(
            openParking: true,
            coveredParking: false,
          ),
          financialInfo: ResellerLeadFinancialInfo(
            negotiable: true,
            propertyPrice: 2500000,
            brokerCommission: 30000,
          ),
          possessionInfo: ResellerLeadPossessionInfo(
            possessionStatus: "Ready to Move",
            propertyAgeInYears: 1,
          ),
          propertyFacing: "West",
          propertyCondition: "ready-to-move",
          propertyCarpetArea: 600,
          propertyBuiltUpArea: 700,
        ),
      ),
      createdAt: DateTime.parse("2025-09-29T10:00:00.000Z"),
      updatedAt: DateTime.parse("2025-09-29T11:00:00.000Z"),
    ),
    ResellerLeadOverview(
      id: "Lead007",
      createdBy: "Agent222",
      updatedBy: "Agent333",
      name: "Siddharth Jain",
      email: "siddharth.jain@example.com",
      phone: "9823456712",
      propertyId: "Prop007",
      resellerId: "Reseller007",
      source: "referral",
      status: "contacted",
      stage: "site_visit_scheduled",
      notes: "Site visit scheduled for weekend",
      lastContactedAt: DateTime.parse("2025-09-30T09:30:00.000Z"),
      isFake: false,
      fakeReason: null,
      markedFakeBy: null,
      markedFakeAt: null,
      customFields: ResellerLeadCustomFields(
        city: "Chandigarh",
        type: "residential",
        state: "Chandigarh",
        title: "3BHK Luxury Flat with Park View",
        address: "Sector 22, Chandigarh",
        zipCode: "160022",
        builderName: "Green Estates",
        listingType: "Sell",
        projectName: "Green Residency",
        propertyType: "apartment",
        propertyDetails: ResellerLeadPropertyDetails(
          bhk: 3,
          balcony: 2,
          bathroom: 3,
          amenities: ["Clubhouse", "Parking", "Security"],
          zoneType: "Residential",
          floorInfo: ResellerLeadFloorInfo(floorNumber: 4, totalFloors: 12),
          furnishInfo: ResellerLeadFurnishInfo(
            furnishType: "furnished",
            furnishDetails: ResellerLeadFurnishDetails(
              bed: 3,
              fan: 6,
              other: "Modular Kitchen",
              balcony: true,
              kitchen: true,
              bathroom: true,
            ),
          ),
          parkingInfo: ResellerLeadParkingInfo(
            openParking: false,
            coveredParking: true,
          ),
          financialInfo: ResellerLeadFinancialInfo(
            negotiable: true,
            propertyPrice: 5500000,
            brokerCommission: 75000,
          ),
          possessionInfo: ResellerLeadPossessionInfo(
            possessionStatus: "Under Construction",
            propertyAgeInYears: 0,
          ),
          propertyFacing: "East",
          propertyCondition: "under-construction",
          propertyCarpetArea: 1400,
          propertyBuiltUpArea: 1600,
        ),
      ),
      createdAt: DateTime.parse("2025-09-25T08:00:00.000Z"),
      updatedAt: DateTime.parse("2025-09-30T09:30:00.000Z"),
    ),
    ResellerLeadOverview(
      id: "Lead008",
      createdBy: "Agent555",
      updatedBy: null,
      name: "Priya Desai",
      email: "priya.desai@example.com",
      phone: "9977886655",
      propertyId: "Prop008",
      resellerId: "Reseller008",
      source: "call_center",
      status: "negotiating",
      stage: "price_discussion",
      notes: "Negotiating final price for penthouse",
      lastContactedAt: DateTime.parse("2025-10-01T14:15:00.000Z"),
      isFake: false,
      fakeReason: null,
      markedFakeBy: null,
      markedFakeAt: null,
      customFields: ResellerLeadCustomFields(
        city: "Ahmedabad",
        type: "residential",
        state: "Gujarat",
        title: "4BHK Penthouse with Private Terrace",
        address: "Satellite, Ahmedabad",
        zipCode: "380015",
        builderName: "Skyline Developers",
        listingType: "Sell",
        projectName: "Skyline Heights",
        propertyType: "penthouse",
        propertyDetails: ResellerLeadPropertyDetails(
          bhk: 4,
          balcony: 3,
          bathroom: 5,
          amenities: ["Swimming Pool", "Gym", "Private Terrace"],
          zoneType: "Residential",
          floorInfo: ResellerLeadFloorInfo(floorNumber: 15, totalFloors: 15),
          furnishInfo: ResellerLeadFurnishInfo(
            furnishType: "fully-furnished",
            furnishDetails: ResellerLeadFurnishDetails(
              bed: 4,
              fan: 8,
              other: "Jacuzzi, Terrace Garden",
              balcony: true,
              kitchen: true,
              bathroom: true,
            ),
          ),
          parkingInfo: ResellerLeadParkingInfo(
            openParking: true,
            coveredParking: true,
          ),
          financialInfo: ResellerLeadFinancialInfo(
            negotiable: false,
            propertyPrice: 95000000,
            brokerCommission: 400000,
          ),
          possessionInfo: ResellerLeadPossessionInfo(
            possessionStatus: "Ready to Move",
            propertyAgeInYears: 1,
          ),
          propertyFacing: "South-East",
          propertyCondition: "ready-to-move",
          propertyCarpetArea: 3000,
          propertyBuiltUpArea: 3500,
        ),
      ),
      createdAt: DateTime.parse("2025-09-18T12:00:00.000Z"),
      updatedAt: DateTime.parse("2025-10-01T14:15:00.000Z"),
    ),

  ];



  // void _updatePriceRange() {
  //   if (_allProducts.isNotEmpty) {
  //     double min = _allProducts
  //         .map((p) => p.customFields.propertyDetails.financialInfo.propertyPrice.toDouble())
  //         .reduce((a, b) => a < b ? a : b);
  //     double max = _allProducts
  //         .map((p) => p.customFields.propertyDetails.financialInfo.propertyPrice.toDouble())
  //         .reduce((a, b) => a > b ? a : b);
  //
  //     minPrice.value = min;
  //     maxPrice.value = max;
  //     filterMinPrice.value = min;
  //     filterMaxPrice.value = max;
  //
  //     print('Price range updated: $min - $max'); // Debug log
  //   }
  // }

  String _mapCategoryToPropertyType(String category) {
    final Map<String, String> categoryMap = {
      'villa': 'villa',
      'apartment': 'apartment',
      'independent floor': 'independent floor',
      'independent house': 'independent house',
      'plot': 'plot',
      'showroom': 'showroom',
      'office': 'office',
      'penthouse': 'penthouse',
    };

    return categoryMap[category.toLowerCase()] ?? category.toLowerCase();
  }

  void _updatePriceRange() {
    if (_allProducts.isNotEmpty) {
      double min = _allProducts
          .map((p) =>
          p.customFields.propertyDetails.financialInfo.propertyPrice.toDouble())
          .reduce((a, b) => a < b ? a : b);
      double max = _allProducts
          .map((p) =>
          p.customFields.propertyDetails.financialInfo.propertyPrice.toDouble())
          .reduce((a, b) => a > b ? a : b);

      minPrice.value = min;
      maxPrice.value = max;
      filterMinPrice.value = min;
      filterMaxPrice.value = max;

      print('💰 Price range: ${min.toStringAsFixed(0)} - ${max.toStringAsFixed(
          0)}');
    }
  }


  //
  // void applyFilters() {
  //   List<ResellerLeadOverview> filtered = _allProducts.where((property) {
  //     bool matchesSearch = searchQuery.value.isEmpty ||
  //         property.customFields.builderName.toLowerCase().contains(
  //           searchQuery.value.toLowerCase(),
  //         ) ||
  //         property.customFields.address.toLowerCase().contains(
  //           searchQuery.value.toLowerCase(),
  //         ) ||
  //         property.customFields.builderName.toLowerCase().contains(
  //           searchQuery.value.toLowerCase(),
  //         );
  //
  //     // FIX: Category matching (case-insensitive comparison)
  //     bool matchesCategory = selectedProductCategories.isEmpty ||
  //         selectedProductCategories.any((cat) =>
  //         cat.toLowerCase() == property.customFields.propertyType.toLowerCase()
  //         );
  //
  //     // FIX: Price filter with proper type casting
  //     double propertyPrice = property.customFields.propertyDetails.financialInfo.propertyPrice.toDouble();
  //     bool matchesPrice = propertyPrice >= filterMinPrice.value &&
  //         propertyPrice <= filterMaxPrice.value;
  //
  //     // Debug logging
  //     if (!matchesCategory && selectedProductCategories.isNotEmpty) {
  //       print('❌ ${property.name}: propertyType="${property.customFields.propertyType}" not in $selectedProductCategories');
  //     }
  //     if (!matchesPrice) {
  //       print('❌ ${property.name}: price=$propertyPrice not in range ${filterMinPrice.value}-${filterMaxPrice.value}');
  //     }
  //
  //     return matchesSearch && matchesCategory && matchesPrice;
  //   }).toList();
  //
  //   print('✅ Filtered ${filtered.length} properties from ${_allProducts.length}');
  //   filteredProducts.assignAll(filtered);
  //   applySorting();
  // }


  void applyFilters() {
    print('\n🔍 === APPLYING FILTERS ===');
    print('Search: "${searchQuery.value}"');
    print('Categories: $selectedProductCategories');
    print('Price: ${filterMinPrice.value} - ${filterMaxPrice.value}');

    List<ResellerLeadOverview> filtered = _allProducts.where((property) {
      // Search filter
      bool matchesSearch = searchQuery.value.isEmpty ||
          property.name.toLowerCase().contains(
              searchQuery.value.toLowerCase()) ||
          property.customFields.builderName.toLowerCase().contains(
              searchQuery.value.toLowerCase()) ||
          property.customFields.address.toLowerCase().contains(
              searchQuery.value.toLowerCase()) ||
          property.customFields.city.toLowerCase().contains(
              searchQuery.value.toLowerCase());

      // Category filter with proper mapping
      bool matchesCategory = selectedProductCategories.isEmpty ||
          selectedProductCategories.any((cat) {
            String mappedType = _mapCategoryToPropertyType(cat);
            bool matches = mappedType ==
                property.customFields.propertyType.toLowerCase();
            return matches;
          });

      // Price filter
      double propertyPrice = property.customFields.propertyDetails.financialInfo
          .propertyPrice.toDouble();
      bool matchesPrice = propertyPrice >= filterMinPrice.value &&
          propertyPrice <= filterMaxPrice.value;

      // Debug individual property
      if (!matchesSearch && searchQuery.value.isNotEmpty) {
        print('❌ Search miss: ${property.name}');
      }
      if (!matchesCategory && selectedProductCategories.isNotEmpty) {
        print('❌ Category miss: ${property.name} (type: ${property.customFields
            .propertyType})');
      }
      if (!matchesPrice) {
        print('❌ Price miss: ${property.name} (₹${propertyPrice.toStringAsFixed(
            0)})');
      }

      return matchesSearch && matchesCategory && matchesPrice;
    }).toList();

    print('✅ Filtered: ${filtered.length}/${_allProducts.length} properties');
    print('=========================\n');

    filteredProducts.assignAll(filtered);
    applySorting();
  }

  void applySorting() {
    List<ResellerLeadOverview> sorted = List.from(filteredProducts);

    switch (sortOption.value) {
      case SortOption.name:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.priceAsc:
        sorted.sort((a, b) =>
            a.customFields.propertyDetails.financialInfo.propertyPrice
                .compareTo(
                b.customFields.propertyDetails.financialInfo.propertyPrice));
        break;
      case SortOption.priceDesc:
        sorted.sort((a, b) =>
            b.customFields.propertyDetails.financialInfo.propertyPrice
                .compareTo(
                a.customFields.propertyDetails.financialInfo.propertyPrice));
        break;
      case SortOption.rating:
        sorted.sort((a, b) =>
            b.customFields.propertyDetails.financialInfo.propertyPrice
                .compareTo(
                a.customFields.propertyDetails.financialInfo.propertyPrice));
        break;
    }

    filteredProducts.assignAll(sorted);
    print('🔄 Sorted by: ${sortOption.value}');
  }



  // void applySorting() {
  //   List<ResellerLeadOverview> sorted = List.from(filteredProducts);
  //
  //   switch (sortOption.value) {
  //     case SortOption.name:
  //       sorted.sort((a, b) => a.name.compareTo(b.name));
  //       break;
  //     case SortOption.priceAsc:
  //       sorted.sort((a, b) =>
  //           a.customFields.propertyDetails.financialInfo.propertyPrice
  //               .compareTo(b.customFields.propertyDetails.financialInfo.propertyPrice));
  //       break;
  //     case SortOption.priceDesc:
  //       sorted.sort((a, b) =>
  //           b.customFields.propertyDetails.financialInfo.propertyPrice
  //               .compareTo(a.customFields.propertyDetails.financialInfo.propertyPrice));
  //       break;
  //     case SortOption.rating:
  //     // If you add rating to ResellerLeadOverview, sort by it
  //       sorted.sort((a, b) =>
  //           b.customFields.propertyDetails.financialInfo.propertyPrice
  //               .compareTo(a.customFields.propertyDetails.financialInfo.propertyPrice));
  //       break;
  //   }
  //
  //   filteredProducts.assignAll(sorted); // ✅ Keep the filtered & sorted results
  // }

  void updateSearch(String query) {
    searchQuery.value = query;
  }

  void updateCategory(String category) {
    selectedCategory.value = category;
  }

  void updateLeadCategory(String category) {
    selectedCategoryInLead.value = category;
  }

  void updatePriceRange(double min, double max) {
    filterMinPrice.value = min;
    filterMaxPrice.value = max;
    print('💰 Price range updated: $min - $max');
  }

  void updateSortOption(SortOption option) {
    sortOption.value = option;
    print('📊 Sort updated: $option');
  }

  void clearFilters() {
    print('🧹 Clearing all filters');
    searchQuery.value = '';
    selectedProductCategories.clear();
    filterMinPrice.value = minPrice.value;  // ✅ Use actual min
    filterMaxPrice.value = maxPrice.value;  // ✅ Use actual max
    sortOption.value = SortOption.name;
    applyFilters();
  }

  void toggleFilters() {
    showFilters.value = !showFilters.value;
  }

  void _startRealTimeUpdates() {
    Stream.periodic(const Duration(seconds: 30)).listen((_) {
      if (!isRefreshing.value) {
        _updateMetricsRealTime();
      }
    });
  }

  Future<void> refreshDashboard() async {
    try {
      isRefreshing.value = true;
      await Future.delayed(const Duration(seconds: 1));

      // Update metrics with new values
      final currentMetrics = metrics.value;
      metrics.value = DashboardMetrics(
        totalSales:
            currentMetrics.totalSales +
            (5000 + (DateTime.now().millisecond % 50000)),
        totalLeads: currentMetrics.totalLeads + (DateTime.now().second % 3),
        totalProducts: currentMetrics.totalProducts,
        growthPercentage:
            currentMetrics.growthPercentage +
            ((DateTime.now().millisecond % 100 - 50) / 100),
      );

      Get.snackbar(
        'Success',
        'Dashboard refreshed',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh dashboard',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  void _updateMetricsRealTime() {
    final currentMetrics = metrics.value;
    metrics.value = DashboardMetrics(
      totalSales:
          currentMetrics.totalSales +
          (1000 + (DateTime.now().millisecond % 10000)),
      totalLeads:
          currentMetrics.totalLeads + (DateTime.now().second % 5 == 0 ? 1 : 0),
      totalProducts: currentMetrics.totalProducts,
      growthPercentage:
          currentMetrics.growthPercentage +
          ((DateTime.now().millisecond % 20 - 10) / 100),
    );
  }

  void resetValues() {
    // loading states
    isLoading.value = false;
    isRefreshing.value = false;

    // metrics back to zero
    metrics.value = DashboardMetrics(
      totalSales: 0,
      totalLeads: 0,
      totalProducts: 0,
      growthPercentage: 0,
    );

    // clear lists
    recentLeads.clear();
    topProducts.clear();
    _allProducts.clear();
    filteredProducts.clear();

    // search & category
    searchQuery.value = '';
    selectedCategory.value = 'All';
    selectedCategoryInLead.value = 'All';
    selectedProductCategories.clear(); // NEW: Clear product categories

    // Clear filter selections
    selectedLeadFilters.clear();

    // price filters
    minPrice.value = 0.0;
    maxPrice.value = 1000.0;
    filterMinPrice.value = 0.0;
    filterMaxPrice.value = 1000.0;

    // sorting
    sortOption.value = SortOption.name;

    // error & filters visibility
    error.value = '';
    showFilters.value = false;
  }
}
