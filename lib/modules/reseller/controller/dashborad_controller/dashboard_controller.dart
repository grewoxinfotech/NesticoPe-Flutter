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
//           backgroundColor: Colors.red, colorText: ColorRes.white);
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
//   //         backgroundColor: Colors.red, colorText: ColorRes.white);
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
//           backgroundColor: Colors.green, colorText: ColorRes.white);
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to refresh dashboard',
//           backgroundColor: Colors.red, colorText: ColorRes.white);
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';
import 'package:housing_flutter_app/data/network/property/services/property_service.dart';

import 'package:housing_flutter_app/modules/seller/module/lead_screen/controllers/lead_controller.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../app/constants/color_res.dart';
import '../../../../data/network/property/models/property_model.dart';
import '../../../../data/network/referral/model/referrel_model.dart';
import '../../../../data/network/referral/service/referrel_service.dart';
import '../../../../data/network/reseller/reseller_dashboard/model/reseller_dashboard_model.dart';
import '../../../../data/network/reseller/reseller_dashboard/service/reseller_dashboard_service.dart';
import '../../../../utils/global.dart';
import '../../model/dashboard/dashboard_model.dart';
import '../../model/reseller_lead_model/reseller_lead_overview.dart';

class DashboardController extends GetxController {
  Rxn<ResellerInsightsModel> resellerInsightsModel =
      Rxn<ResellerInsightsModel>();
  RxList<Items> itemData = <Items>[].obs;
  Rxn<ReferralModel> dummyReferral = Rxn<ReferralModel>();
  PropertyService _propertyService = PropertyService();
  Rxn<UserModel> userModel = Rxn<UserModel>();

  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxBool isResellerDetailExpanded = false.obs;
  final isGenerated = false.obs;
  final Rx<DashboardMetrics> metrics =
      DashboardMetrics(
        totalSales: 0,
        totalLeads: 0,
        totalProducts: 0,
        growthPercentage: 0,
      ).obs;

  final RxList<Lead> recentLeads = <Lead>[].obs;
  final RxList<Product> topProducts = <Product>[].obs;
  final RxList<ResellerLeadOverview> _allProducts =
      <ResellerLeadOverview>[].obs;
  final RxList<ResellerLeadOverview> filteredProducts =
      <ResellerLeadOverview>[].obs;
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
  final RxList<Map<String, String>> filterMaps = <Map<String, String>>[].obs;
  final RxString error = ''.obs;
  final RxBool showFilters = false.obs;
  final offerController = TextEditingController();
  final messageController = TextEditingController();
  final leadController = Get.put(LeadController(), tag: "reseller");

  // Categories
  final RxList<String> categories =
      <String>[
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
  final formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final achievementController = TextEditingController();
  final totalDealsController = TextEditingController();
  final totalValueController = TextEditingController();

  var selectedMonth = Rx<DateTime?>(null);
  var selectedStatus = 'Published'.obs;
  var rating = 5.0.obs;
  var imageFile = Rx<File?>(null);

  final statusOptions = ['Published', 'Draft', 'Archived'];

  final picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    itemData.clear();
    loadProducts();
    getCurrentUserData();
    fetchDashboardData();
    fetchReferralService();

    fetchResellerDashboardDataFromApi();
    Get.lazyPut(() => LeadController(), tag: "reseller");
    // Simulate real-time updates every 30 seconds
    _startRealTimeUpdates();
    ever(searchQuery, (_) => applyFilters());
    ever(selectedCategory, (_) => applyFilters());
    ever(filterMinPrice, (_) => applyFilters());
    ever(filterMaxPrice, (_) => applyFilters());
    ever(sortOption, (_) => applySorting());
  }

  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imageFile.value = File(picked.path);
    }
  }


  Future<Rxn<ResellerInsightsModel>> fetchResellerDashboardDataFromApi() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id;
    final data = await ResellerDashboardService.resellerDashboardService
        .fetchResellerDashboard(userId ?? '');
    resellerInsightsModel.value = ResellerInsightsModel.fromJson(data ?? {});
    print("Reseller Dashboard controller${resellerInsightsModel.toJson()}");

    return resellerInsightsModel;
  }

  Future<void> fetchReferralService() async {
    try {
      isLoading.value = true;
      final data = await Referral_Service.instance.fetchReferrals();
      dummyReferral.value = ReferralModel.fromJson(data);
      if (dummyReferral.value != null) isGenerated.value = true;
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getPropertyDetailById(List<TopProperty> item) async {
    // for (int i = 0; i < item.length; i++) {
    //   final data = await _propertyService.getPropertyById(item[i].id);
    //   // print("Items Dtaa= $data");
    //   // itemData.add(data??Items());
    //   if (data != null) {
    //     itemData.add(data);
    //     print("Items Dtaa= ${itemData.value[i].propertyDetails?.financialInfo?.price}");
    //   }
    // }

    final results = await Future.wait(
      item.map((e) => _propertyService.getPropertyById(e.id)),
    );

    if (results.isNotEmpty) {
      // Filter out null values
      final validData = results.whereType<Items>().toList();

      itemData.clear();
      itemData.assignAll(validData);
    }
  }

  Future<void> getCurrentUserData() async {
    userModel.value = await SecureStorage.getUserData();
  }

  void applyFilter(List<Map<String, String>> filterList) {
    // Merge all maps into one
    final mergedFilters = <String, String>{};
    for (var f in filterList) {
      mergedFilters.addAll(f); // combine key-value pairs
    }

    print('Merged Filters: $mergedFilters');

    leadController.applyFilters(mergedFilters);
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
        backgroundColor: ColorRes.error,
        colorText: ColorRes.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadProducts() async {
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
    // ResellerLeadOverview(
    //   id: "Lead005",
    //   createdBy: "Agent999",
    //   updatedBy: "Agent123",
    //   name: "Karan Mehta",
    //   email: "karan.mehta@example.com",
    //   phone: "9988776655",
    //   propertyId: "Prop005",
    //   resellerId: "Reseller005",
    //   source: "broker",
    //   status: "lost",
    //   stage: "deal_lost",
    //   notes: "Client backed out due to high price",
    //   lastContactedAt: DateTime.parse("2025-09-19T16:00:00.000Z"),
    //   isFake: false,
    //   fakeReason: null,
    //   markedFakeBy: null,
    //   markedFakeAt: null,
    //   customFields: Items(
    //     id: "prop_001",
    //     createdBy: "user_123",
    //     updatedBy: "user_456",
    //     title: "Luxury 3BHK Apartment in Pune",
    //     type: "residential",
    //     listingType: "Sale",
    //     propertyType: "apartment",
    //     propertyDescription:
    //         "Spacious 3BHK apartment with modern amenities located in Kalyani Nagar, Pune.",
    //     keywords: ["3BHK", "Balcony", "Furnished", "Near IT Park"],
    //     propertyImages: [
    //       "https://example.com/images/property1.jpg",
    //       "https://example.com/images/property2.jpg",
    //     ],
    //     propertyMedia: PropertyMedia(
    //       images: [
    //         "https://example.com/media/image1.jpg",
    //         "https://example.com/media/image2.jpg",
    //       ],
    //       videos: ["https://example.com/media/video1.mp4"],
    //       documents: ["https://example.com/media/floorplan.pdf"],
    //     ),
    //     propertyDetails: PropertyDetails(
    //       bhk: 3,
    //       balcony: 2,
    //       bathroom: 3,
    //       amenities: ["Gym", "Swimming Pool", "Power Backup", "Parking"],
    //       zoneType: "Residential Zone",
    //       floorInfo: FloorInfo(floorNumber: 5, totalFloors: 12),
    //       furnishInfo: FurnishInfo(
    //         furnishType: "Fully Furnished",
    //         furnishDetails: FurnishDetails(
    //           modularKitchen: true,
    //           wardrobes: true,
    //           acInstalled: true,
    //         ),
    //       ),
    //       parkingInfo: ParkingInfo(covered: true, open: false),
    //       financialInfo: FinancialInfo(
    //         price: 12500000,
    //         propertyRentPerMonth: 0,
    //         maintenance: 2500,
    //         pricePerSqft: 8500,
    //         brokerCommission: 2,
    //         propertySecurityDeposit: 0,
    //         negotiable: true,
    //       ),
    //       possessionInfo: PossessionInfo(
    //         possessionStatus: "Ready to Move",
    //         propertyAgeInYear: "2",
    //       ),
    //       propertyFacing: "East",
    //       propertyCondition: "Excellent",
    //       propertyCarpetArea: 1400.0,
    //       propertyBuiltUpArea: 1650.0,
    //       propertyCarpetAreaUnit: "sqft",
    //       propertyBuiltUpAreaUnit: "sqft",
    //       facilitiesInfo: FacilitiesInfo(
    //         minSeats: 0,
    //         numberOfCabins: 0,
    //         numberOfMeetingRooms: 0,
    //       ),
    //       pgInfo: PgInfo(
    //         pgName: "Elite PG",
    //         pgFor: "Students",
    //         pgSuitedFor: "Boys",
    //         pgMealOffered: "Breakfast, Dinner",
    //         pgCommonArea: "TV Room, Study Hall",
    //         pgManageBy: "Owner",
    //         pgOwnerStaysAtPg: false,
    //         mealChargesPerMonth: 3000,
    //         electricityChargesPerMonth: 1500,
    //         pgRules: PgRules(
    //           nonVegAllowed: true,
    //           smokingAllowed: false,
    //           drinkingAllowed: false,
    //           petsAllowed: false,
    //           lateEntryAllowed: true,
    //           lateEntryTime: "11:00 PM",
    //           visitorAllowed: true,
    //           gurdianAllowed: false,
    //         ),
    //         pgRoomInfo: [
    //           PgRoomInfo(
    //             roomType: "Single Sharing",
    //             totalBeds: 1,
    //             roomFacilityInfo: RoomFacilityInfo(
    //               wifi: true,
    //               tv: true,
    //               ac: true,
    //               other: "Private Balcony",
    //             ),
    //           ),
    //           PgRoomInfo(
    //             roomType: "Double Sharing",
    //             totalBeds: 2,
    //             roomFacilityInfo: RoomFacilityInfo(
    //               wifi: true,
    //               tv: false,
    //               ac: true,
    //               other: "Common Bathroom",
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     address: "Sunshine Residency, Kalyani Nagar",
    //     city: "Pune",
    //     state: "Maharashtra",
    //     zipCode: "411014",
    //     location: "18.5516, 73.9035",
    //     nearbyLocations: [
    //       NearbyLocations(name: "Phoenix Mall", distance: 1.5),
    //       NearbyLocations(name: "Pune Airport", distance: 4.2),
    //     ],
    //     reraId: "RERA-PN-12345",
    //     propertyStatus: "Available",
    //     builderName: "Sunshine Developers",
    //     projectName: "Sunshine Residency",
    //     ownerPhone: "+91 9876543210",
    //     ownerName: "Rahul Mehta",
    //     ownerEmail: "rahul.mehta@example.com",
    //     isVerified: true,
    //     verifiedBy: "admin_user",
    //     verifiedAt: "2025-10-05T12:00:00Z",
    //     totalInquiries: 12,
    //     totalViews: 480,
    //     approvalStatus: "approved",
    //     approvalComment: "All documents verified",
    //     approvedBy: "admin_1",
    //     approvedAt: "2025-10-06T09:00:00Z",
    //     totalFavorites: 14,
    //     totalShares: 5,
    //     totalVisits: 60,
    //     totalSales: 1,
    //     totalCommissions: "50000",
    //     assignedTo: "agent_009",
    //     assignmentDate: "2025-09-01",
    //     assignmentExpiryDate: "2025-12-01",
    //     potentialEarnings: "1,20,000",
    //     assignmentStatus: "active",
    //     performanceScore: "8.5",
    //     expiryDate: "2026-09-01",
    //     lastRenewalDate: "2025-08-01",
    //     renewalCount: 2,
    //     isExpired: false,
    //     totalReports: 0,
    //     isHiddenDueToReports: false,
    //     lastReportedAt: null,
    //     createdAt: "2025-07-01T10:00:00Z",
    //     updatedAt: "2025-09-15T10:00:00Z",
    //   ),
    //   createdAt: DateTime.parse("2025-09-05T14:00:00.000Z"),
    //   updatedAt: DateTime.parse("2025-09-19T16:00:00.000Z"),
    // ),
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

  // void _updatePriceRange() {
  //   if (_allProducts.isNotEmpty) {
  //     double min = _allProducts
  //         .map(
  //           (p) =>
  //               p.customFields.propertyDetails.financialInfo.propertyPrice
  //                   .toDouble(),
  //         )
  //         .reduce((a, b) => a < b ? a : b);
  //     double max = _allProducts
  //         .map(
  //           (p) =>
  //               p.customFields.propertyDetails.financialInfo.propertyPrice
  //                   .toDouble(),
  //         )
  //         .reduce((a, b) => a > b ? a : b);
  //
  //     minPrice.value = min;
  //     maxPrice.value = max;
  //     filterMinPrice.value = min;
  //     filterMaxPrice.value = max;
  //
  //     print(
  //       '💰 Price range: ${min.toStringAsFixed(0)} - ${max.toStringAsFixed(0)}',
  //     );
  //   }
  // }

  void _updatePriceRange() {
    if (_allProducts.isNotEmpty) {
      double min = _allProducts
          .map(
            (p) =>
                p.customFields.propertyDetails?.financialInfo?.price
                    .toDouble() ??
                0,
          )
          .reduce((a, b) => a < b ? a : b);

      double max = _allProducts
          .map(
            (p) =>
                p.customFields.propertyDetails?.financialInfo?.price
                    .toDouble() ??
                0,
          )
          .reduce((a, b) => a > b ? a : b);

      minPrice.value = min;
      maxPrice.value = max;
      filterMinPrice.value = min;
      filterMaxPrice.value = max;

      print(
        '💰 Price range: ${min.toStringAsFixed(0)} - ${max.toStringAsFixed(0)}',
      );
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

  // void applyFilters() {
  //   print('\n🔍 === APPLYING FILTERS ===');
  //   print('Search: "${searchQuery.value}"');
  //   print('Categories: $selectedProductCategories');
  //   print('Price: ${filterMinPrice.value} - ${filterMaxPrice.value}');
  //
  //   List<ResellerLeadOverview> filtered =
  //       _allProducts.where((property) {
  //         // Search filter
  //         bool matchesSearch =
  //             searchQuery.value.isEmpty ||
  //             property.name.toLowerCase().contains(
  //               searchQuery.value.toLowerCase(),
  //             ) ||
  //             property.customFields.builderName.toLowerCase().contains(
  //               searchQuery.value.toLowerCase(),
  //             ) ||
  //             property.customFields.address.toLowerCase().contains(
  //               searchQuery.value.toLowerCase(),
  //             ) ||
  //             property.customFields.city.toLowerCase().contains(
  //               searchQuery.value.toLowerCase(),
  //             );
  //
  //         // Category filter with proper mapping
  //         bool matchesCategory =
  //             selectedProductCategories.isEmpty ||
  //             selectedProductCategories.any((cat) {
  //               String mappedType = _mapCategoryToPropertyType(cat);
  //               bool matches =
  //                   mappedType ==
  //                   property.customFields.propertyType.toLowerCase();
  //               return matches;
  //             });
  //
  //         // Price filter
  //         double propertyPrice =
  //             property.customFields.propertyDetails.financialInfo.propertyPrice
  //                 .toDouble();
  //         bool matchesPrice =
  //             propertyPrice >= filterMinPrice.value &&
  //             propertyPrice <= filterMaxPrice.value;
  //
  //         // Debug individual property
  //         if (!matchesSearch && searchQuery.value.isNotEmpty) {
  //           print('❌ Search miss: ${property.name}');
  //         }
  //         if (!matchesCategory && selectedProductCategories.isNotEmpty) {
  //           print(
  //             '❌ Category miss: ${property.name} (type: ${property.customFields.propertyType})',
  //           );
  //         }
  //         if (!matchesPrice) {
  //           print(
  //             '❌ Price miss: ${property.name} (₹${propertyPrice.toStringAsFixed(0)})',
  //           );
  //         }
  //
  //         return matchesSearch && matchesCategory && matchesPrice;
  //       }).toList();
  //
  //   print('✅ Filtered: ${filtered.length}/${_allProducts.length} properties');
  //   print('=========================\n');
  //
  //   filteredProducts.assignAll(filtered);
  //   applySorting();
  // }
  //
  // void applySorting() {
  //   List<ResellerLeadOverview> sorted = List.from(filteredProducts);
  //
  //   switch (sortOption.value) {
  //     case SortOption.name:
  //       sorted.sort((a, b) => a.name.compareTo(b.name));
  //       break;
  //     case SortOption.priceAsc:
  //       sorted.sort(
  //         (a, b) => a.customFields.propertyDetails.financialInfo.propertyPrice
  //             .compareTo(
  //               b.customFields.propertyDetails.financialInfo.propertyPrice,
  //             ),
  //       );
  //       break;
  //     case SortOption.priceDesc:
  //       sorted.sort(
  //         (a, b) => b.customFields.propertyDetails.financialInfo.propertyPrice
  //             .compareTo(
  //               a.customFields.propertyDetails.financialInfo.propertyPrice,
  //             ),
  //       );
  //       break;
  //     case SortOption.rating:
  //       sorted.sort(
  //         (a, b) => b.customFields.propertyDetails.financialInfo.propertyPrice
  //             .compareTo(
  //               a.customFields.propertyDetails.financialInfo.propertyPrice,
  //             ),
  //       );
  //       break;
  //   }
  //
  //   filteredProducts.assignAll(sorted);
  //   print('🔄 Sorted by: ${sortOption.value}');
  // }

  void applyFilters() {
    print('\n🔍 === APPLYING FILTERS ===');
    print('Search: "${searchQuery.value}"');
    print('Categories: $selectedProductCategories');
    print('Price: ${filterMinPrice.value} - ${filterMaxPrice.value}');

    List<ResellerLeadOverview> filtered =
        _allProducts.where((property) {
          final custom = property.customFields;
          final details = custom.propertyDetails;
          final finance = details?.financialInfo;

          // Safely extract values
          final double propertyPrice = finance?.price.toDouble() ?? 0;
          final String name = property.name.toLowerCase();
          final String builderName = custom.builderName?.toLowerCase() ?? '';
          final String address = custom.address?.toLowerCase() ?? '';
          final String city = custom.city?.toLowerCase() ?? '';
          final String propertyType = custom.propertyType?.toLowerCase() ?? '';

          // Search filter
          bool matchesSearch =
              searchQuery.value.isEmpty ||
              name.contains(searchQuery.value.toLowerCase()) ||
              builderName.contains(searchQuery.value.toLowerCase()) ||
              address.contains(searchQuery.value.toLowerCase()) ||
              city.contains(searchQuery.value.toLowerCase());

          // Category filter
          bool matchesCategory =
              selectedProductCategories.isEmpty ||
              selectedProductCategories.any((cat) {
                String mappedType = _mapCategoryToPropertyType(cat);
                return mappedType == propertyType;
              });

          // Price filter
          bool matchesPrice =
              propertyPrice >= filterMinPrice.value &&
              propertyPrice <= filterMaxPrice.value;

          // Debug
          if (!matchesSearch && searchQuery.value.isNotEmpty) {
            print('❌ Search miss: ${property.name}');
          }
          if (!matchesCategory && selectedProductCategories.isNotEmpty) {
            print('❌ Category miss: ${property.name} (type: $propertyType)');
          }
          if (!matchesPrice) {
            print(
              '❌ Price miss: ${property.name} (₹${propertyPrice.toStringAsFixed(0)})',
            );
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
        sorted.sort(
          (a, b) => (a.customFields.propertyDetails?.financialInfo?.price ?? 0)
              .compareTo(
                (b.customFields.propertyDetails?.financialInfo?.price ?? 0),
              ),
        );
        break;

      case SortOption.priceDesc:
        sorted.sort(
          (a, b) => (b.customFields.propertyDetails?.financialInfo?.price ?? 0)
              .compareTo(
                (a.customFields.propertyDetails?.financialInfo?.price ?? 0),
              ),
        );
        break;

      case SortOption.rating:
        // Placeholder (no rating field yet)
        sorted.sort(
          (a, b) => (b.customFields.propertyDetails?.financialInfo?.price ?? 0)
              .compareTo(
                (a.customFields.propertyDetails?.financialInfo?.price ?? 0),
              ),
        );
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
    filterMinPrice.value = minPrice.value; // ✅ Use actual min
    filterMaxPrice.value = maxPrice.value; // ✅ Use actual max
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
      await fetchResellerDashboardDataFromApi();
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
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh dashboard',
        backgroundColor: Colors.red,
        colorText: ColorRes.white,
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
  void submitForm() {
    if (formKey.currentState!.validate()) {
      Get.snackbar(
        'Success',
        'Story added successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back();
    }
  }
  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    achievementController.dispose();
    totalDealsController.dispose();
    totalValueController.dispose();
    super.onClose();
  }
}
