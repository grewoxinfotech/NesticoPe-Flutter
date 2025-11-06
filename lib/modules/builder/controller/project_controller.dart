import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/widgets/snackbar/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/network/builder/model/builder_model.dart'
    hide ProjectContactInfo, ProjectSize, MediaGallery, Brochure;
import '../../../data/network/builder/model/builder_projectModel.dart';

class ProjectController extends GetxController {
  // final Rx<ProjectItem?> project = Rx<ProjectItem>();
  final RxInt selectedConfigIndex = 0.obs;
  final RxInt selectedImageIndex = 0.obs;
  final RxBool isLoading = true.obs;
  final currentConfigPage = 0.obs;
  RxMap<int, int> variantIndexMap = <int, int>{}.obs;
  late PageController configPageController;
  final showAllConfigurations = false.obs;

  // Add these methods
  void toggleShowAllConfigurations() {
    showAllConfigurations.value = !showAllConfigurations.value;
  }

  void initializeExpandedStates(int count) {
    showAllConfigurations.value = false;
  }

  @override
  void onClose() {
    configPageController.dispose();
    super.onClose();
  }

  void initializeVariantIndices(int configCount) {
    variantIndexMap.clear();
    for (int i = 0; i < configCount; i++) {
      variantIndexMap[i] = 0;
    }
  }

  void updateVariantIndex(int configIndex, int variantIndex) {
    variantIndexMap.value[configIndex] = variantIndex;
  }

  void updateConfigPage(int page) {
    currentConfigPage.value = page;
  }

  @override
  void onInit() {
    super.onInit();
    configPageController = PageController();
    loadProjectData();
  }

  void loadProjectData() {
    // Simulating API call - Replace with actual data loading
    isLoading.value = true;

    // Mock data for demonstration
    // Future.delayed(const Duration(seconds: 1), () {
    //   project.value = ProjectItem(
    //     brochures: [
    //       Brochure(
    //         url: 'https://example.com/docs/brochure.pdf',
    //         name: 'Sunshine Brochure',
    //       ),
    //       Brochure(
    //         url: 'https://example.com/docs/floorplan.pdf',
    //         name: 'Floor Plan',
    //       ),
    //     ],
    //     mediaGallery: MediaGallery(
    //       images: [
    //         'https://images.unsplash.com/photo-1600585154340-be6161a56a0c', // exterior
    //         'https://images.unsplash.com/photo-1600607687920-4e2b53e1e36b', // living room
    //         'https://images.unsplash.com/photo-1600585154200-6a67b1eaf3f2', // amenities
    //       ],
    //       videos: [
    //         'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
    //       ],
    //       documents: [
    //         'https://example.com/docs/project_overview.pdf',
    //         'https://example.com/docs/layout.pdf',
    //       ],
    //     ),
    //     id: '1',
    //     createdBy: 'builder_123',
    //     updatedBy: 'builder_123',
    //     projectId: 'PRJ001',
    //     projectName: 'Sunshine Apartments',
    //     projectArea: '5 Acres',
    //     sizeRange: SizeRange(minSize: 900, maxSize: 1800),
    //     projectSize: ProjectSize(totalUnits: 250, totalBuildings: 4),
    //     launchDate: '2024-01-01',
    //     possessionDate: '2025-12-01',
    //     configuration: [
    //       Configuration(
    //         bhk: 2,
    //         variants: [
    //           Variant(
    //             name: '2 BHK Type A',
    //             price: 10900000,
    //             variantId: 'V1',
    //             carpetArea: 850,
    //             builtUpArea: 1100,
    //             pricePerSqFt: 12824,
    //             totalUnits: 100,
    //             availableUnits: 21,
    //             specifications: ['Spacious Interiors', 'Premium Finishes'],
    //             images: [
    //               'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    //               'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    //               'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    //               'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    //               'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    //             ],
    //             videos: [
    //               'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
    //             ],
    //           ),
    //           Variant(
    //             name: '2 BHK Type A',
    //             price: 1500000,
    //             variantId: 'V2',
    //             carpetArea: 950,
    //             builtUpArea: 2200,
    //             pricePerSqFt: 12844,
    //             totalUnits: 100,
    //             availableUnits: 21,
    //             specifications: ['Spacious Interiors', 'Premium Finishes'],
    //             images: [
    //               'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    //               'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    //               'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    //               'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    //               'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    //             ],
    //             videos: [
    //               'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
    //             ],
    //           ),
    //         ],
    //       ),
    //       Configuration(
    //         bhk: 3,
    //         variants: [
    //           Variant(
    //             name: '3 BHK Type A',
    //             price: 12500000,
    //             variantId: 'V2',
    //             carpetArea: 1250,
    //             builtUpArea: 1600,
    //             pricePerSqFt: 7812,
    //             totalUnits: 80,
    //             availableUnits: 12,
    //             specifications: ['Large Balcony', 'Modern Kitchen'],
    //             images: [
    //               'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    //               'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    //               'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    //               'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    //               'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
    //             ],
    //             videos: [
    //               'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
    //             ],
    //           ),
    //         ],
    //       ),
    //     ],
    //     reraId: 'RERA-MH-2024-00123',
    //     propertyTypes: 'Apartment',
    //     projectContactInfos: ProjectContactInfo(
    //       name: 'Ananya Sharma',
    //       email: 'sales@sunshine.com',
    //       phone: '+91 98765 43210',
    //     ),
    //     status: 'Ongoing',
    //     address: 'Prime Location, Marine Drive',
    //     city: 'Mumbai',
    //     state: 'Maharashtra',
    //     zipCode: '400001',
    //     location: 'Mumbai',
    //     nearbyLocations: [
    //       'Hospital',
    //       'Metro Station',
    //       'Shopping Mall',
    //       'School',
    //     ],
    //     amenities: [
    //       'Swimming Pool',
    //       'Gymnasium',
    //       'Parking',
    //       '24/7 Security',
    //       'Club House',
    //       'Spa & Sauna',
    //       'Games Room',
    //       'Green Park',
    //     ],
    //     approvalStatus: 'Approved',
    //     approvalComment: 'RERA Certified Project',
    //     isVerified: true,
    //     projectHighlights: [
    //       'Prime Location',
    //       'World-class Amenities',
    //       'RERA Approved',
    //     ],
    //     totalViews: 1200,
    //     totalInquiries: 240,
    //     totalShares: 50,
    //     totalFavorites: 180,
    //     isActive: true,
    //     createdAt: '2024-01-01T10:00:00Z',
    //     updatedAt: '2025-01-01T12:00:00Z',
    //   );
    //
    //   isLoading.value = false;
    // });
  }

  void selectConfiguration(int index) {
    selectedConfigIndex.value = index;
  }

  void selectImage(int index) {
    selectedImageIndex.value = index;
  }

  String formatCurrency(double amount) {
    if (amount >= 10000000) {
      return '₹${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '₹${(amount / 100000).toStringAsFixed(2)} L';
    }
    return '₹${amount.toStringAsFixed(0)}';
  }

  Future<void> downloadDocument(String? path) async {
    if (path != null) {
      await launchUrl(Uri.parse(path), mode: LaunchMode.platformDefault);
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Download',
        message: 'Downloading document...',
        contentType: ContentType.success,
      );
    }
  }

  void contactSales(String type) {
    Get.snackbar(
      'Contact',
      'Opening $type...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
