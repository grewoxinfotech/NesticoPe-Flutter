// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';
// import 'package:housing_flutter_app/modules/auth/views/login_screen.dart';
//
// import '../../../app/constants/app_font_sizes.dart';
// import '../../../data/network/contractor/model/contractor_profile_model/contractor_profile_model.dart';
// import '../../../data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
// import '../controllers/contractor_profile_service_controller/contractor_profile_service_controller.dart';
//
// class ContractorProfileScreen extends StatelessWidget {
//   final Contractor contractor;
//   ContractorProfileScreen({super.key, required this.contractor});
//
//   RxBool _isListSelectAble = false.obs;
//
//   void contactContractor() {}
//
//   @override
//   Widget build(BuildContext context) {
//     final contractorServiceController = Get.put(
//       ContractorServiceController(contractorId: contractor.userId),
//     );
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         title: const Text(
//           "Contractor Profile",
//           style: TextStyle(color: Colors.black),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black),
//       ),
//       body: SingleChildScrollView(
//         physics: AlwaysScrollableScrollPhysics(),
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 12),
//
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: ColorRes.leadGreyColor.shade300),
//                 color: ColorRes.white,
//               ),
//
//               child: Column(
//                 children: [
//                   // ---------------- PROFILE HEADER ----------------
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       color: ColorRes.white,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           height: 60,
//                           width: 60,
//                           decoration: BoxDecoration(
//                             color: ColorRes.primary.withOpacity(0.3),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.build,
//                             size: 32,
//                             color: ColorRes.primary,
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               contractor.username,
//                               style: TextStyle(
//                                 fontSize: AppFontSizes.body,
//                                 fontWeight: AppFontWeights.semiBold,
//                                 color: ColorRes.primary,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Row(
//                               children: [
//                                 Icon(
//                                   Icons.star,
//                                   color: ColorRes.warning,
//                                   size: 18,
//                                 ),
//                                 SizedBox(width: 4),
//                                 Text(
//                                   "${double.tryParse(contractor.overallRating)}  (${contractor.totalReviews})",
//                                   style: TextStyle(
//                                     fontSize: AppFontSizes.bodySmall,
//                                     fontWeight: AppFontWeights.medium,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   const SizedBox(height: 12),
//
//                   // ---------------- LOGIN BUTTON ----------------
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (UserHelper.isGuest) {
//                           Get.to(() => LoginScreen());
//                         } else {
//                           contactContractor();
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: ColorRes.primary,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       child: Text(
//                         UserHelper.isGuest ? "Login to Contact" : 'Contact',
//                         style: TextStyle(
//                           fontSize: AppFontSizes.bodySmall,
//                           fontWeight: AppFontWeights.semiBold,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 12),
//
//                   // ---------------- STATS GRID ----------------
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       _statCard(
//                         "Total Services",
//                         contractor.totalServices.toString(),
//                       ),
//                       _statCard(
//                         "Active Services",
//                         contractor.activeServices.toString(),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 12),
//
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       _statCard(
//                         "Projects",
//                         contractor.projectStats.totalProjects.toString(),
//                       ),
//                       _statCard(
//                         "Experience",
//                         "${contractor.totalExperience} years",
//                         highlight: true,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 30),
//
//             // ---------------- SECTION TITLE ----------------
//             Row(
//               children: [
//                 Text(
//                   "Services Offered (${contractor.totalServices})",
//                   style: TextStyle(
//                     fontSize: AppFontSizes.body,
//                     fontWeight: AppFontWeights.semiBold,
//                     color: ColorRes.textPrimary,
//                   ),
//                 ),
//                 Spacer(),
//                 ElevatedButton(
//                   onPressed: () {
//                     _isListSelectAble.value = !_isListSelectAble.value;
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: ColorRes.primary,
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: Text(
//                     "Select Services",
//                     style: TextStyle(
//                       fontSize: AppFontSizes.bodySmall,
//                       fontWeight: AppFontWeights.semiBold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 14),
//
//             // ---------------- LOGIN ALERT ----------------
//             if (UserHelper.isGuest) ...[
//               Container(
//                 padding: const EdgeInsets.all(14),
//                 decoration: BoxDecoration(
//                   color: ColorRes.primary.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Row(
//                   children: const [
//                     Icon(Icons.info_outline, color: ColorRes.primary),
//                     SizedBox(width: 10),
//                     Expanded(
//                       child: Text(
//                         "Please login to select services and contact the contractor.",
//                         style: TextStyle(fontSize: 14),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//
//             // ---------------- SERVICE CARDS ----------------
//             Obx(() {
//               if (contractorServiceController.isLoading.value &&
//                   contractorServiceController.items.isEmpty) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               if (!contractorServiceController.isLoading.value &&
//                   contractorServiceController.items.isEmpty) {
//                 return const Center(child: Text("No services found."));
//               }
//               return NotificationListener<ScrollEndNotification>(
//                 onNotification: (notification) {
//                   final metrics = notification.metrics;
//
//                   if (metrics.pixels == metrics.maxScrollExtent) {
//                     contractorServiceController.loadMore();
//                   }
//                   return true;
//                 },
//                 child: ListView.separated(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   itemBuilder: (context, index) {
//                     final data = contractorServiceController.items[index];
//                     return ServiceCard(
//                       service: data,
//                       isSelectable: _isListSelectAble.value,
//                     );
//                   },
//                   separatorBuilder: (context, index) => SizedBox(height: 20),
//                   itemCount: contractorServiceController.items.length,
//                 ),
//               );
//             }),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
//
//   // ----------------------------------------------------------
//   //                   REUSABLE WIDGETS
//   // ----------------------------------------------------------
//
//   Widget _statCard(String title, String value, {bool highlight = false}) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         margin: const EdgeInsets.only(right: 10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: ColorRes.leadGreyColor.shade300),
//         ),
//         child: Column(
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: AppFontSizes.bodySmall,
//                 fontWeight: AppFontWeights.medium,
//                 color: ColorRes.grey,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: AppFontSizes.body,
//                 fontWeight: AppFontWeights.semiBold,
//                 color: highlight ? ColorRes.primary : ColorRes.black,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ServiceCard extends StatelessWidget {
//   final bool isSelectable;
//   final ContractorServiceItem service;
//   const ServiceCard({
//     super.key,
//     required this.service,
//     required this.isSelectable,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final contractorController = Get.find<ContractorServiceController>();
//     return Obx(
//       () => Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // header ------------------
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   if (isSelectable) ...[
//                     Checkbox(
//                       value: contractorController.selectedItems.contains(
//                         service,
//                       ),
//                       onChanged: (value) {
//                         contractorController.toggleSelectedService(service);
//                       },
//                     ),
//                   ],
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         service.serviceName,
//                         style: TextStyle(
//                           fontSize: AppFontSizes.body,
//                           fontWeight: AppFontWeights.semiBold,
//                           color: ColorRes.primary,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         service.description,
//                         style: TextStyle(
//                           fontSize: AppFontSizes.bodySmall,
//                           fontWeight: AppFontWeights.medium,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       Icon(Icons.star, color: ColorRes.warning, size: 20),
//                       SizedBox(width: 2),
//                       Text(
//                         '${service.averageRating.toString()} (${service.totalReviews})',
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
//
//             // Middle section ----------
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _detailColumn("PRICE", service.meta.priceRange),
//                   _detailColumn("AVAILABILITY", service.meta.workAvailability),
//                   _detailColumn(
//                     "STATUS",
//                     service.isActive ? "Active" : "Inactive",
//                     highlight: true,
//                   ),
//                 ],
//               ),
//             ),
//
//             Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
//
//             // Features list -----------
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Column(
//                 children: [
//                   _feature(service.meta.provideMaterials, "Materials Provided"),
//                   _feature(
//                     service.meta.equipmentProvided,
//                     "Equipment Provided",
//                   ),
//                   _feature(
//                     service.meta.insuranceAvailable,
//                     "Insurance Available",
//                   ),
//                 ],
//               ),
//             ),
//
//             Divider(color: Colors.grey.shade300, height: 1),
//
//             // Bottom section ----------
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _detailColumn(
//                     "ADVANCE REQUIRED",
//                     "${service.meta.advanceRequiredPercentage}%",
//                   ),
//                   _detailColumn(
//                     "PAYMENT MODES",
//                     service.meta.acceptedPaymentModes
//                         .map((e) => e.replaceAll("_", " ").capitalize)
//                         .join(", "),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _detailColumn(String title, String value, {bool highlight = false}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 12, color: Colors.black54),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: AppFontSizes.bodySmall,
//             fontWeight: AppFontWeights.semiBold,
//             color: highlight ? ColorRes.green : ColorRes.textPrimary,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _feature(bool value, String title) {
//     return Row(
//       children: [
//         Icon(
//           value ? Icons.check : Icons.close,
//           color: value ? ColorRes.green : ColorRes.error,
//           size: 18,
//         ),
//         const SizedBox(width: 8),
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: AppFontSizes.bodySmall,
//             fontWeight: AppFontWeights.medium,
//             color: ColorRes.grey,
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:housing_flutter_app/modules/auth/views/login_screen.dart';
import '../../../app/constants/app_font_sizes.dart';
import '../../../data/network/contractor/model/contractor_profile_model/contractor_profile_model.dart';
import '../../../data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
import '../controllers/contractor_profile_service_controller/contractor_profile_service_controller.dart';

class ContractorProfileScreen extends StatelessWidget {
  final Contractor contractor;
  ContractorProfileScreen({super.key, required this.contractor});

  // Make this an instance variable accessible to the controller
  final RxBool isListSelectable = false.obs;

  void contactContractor() {
    // Your contact logic here
  }

  @override
  Widget build(BuildContext context) {
    final contractorServiceController = Get.put(
      ContractorServiceController(contractorId: contractor.userId),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Contractor Profile",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ColorRes.leadGreyColor.shade300),
                color: ColorRes.white,
              ),
              child: Column(
                children: [
                  // ---------------- PROFILE HEADER ----------------
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: ColorRes.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: ColorRes.primary.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.build,
                            size: 32,
                            color: ColorRes.primary,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contractor.username,
                                style: TextStyle(
                                  fontSize: AppFontSizes.body,
                                  fontWeight: AppFontWeights.semiBold,
                                  color: ColorRes.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: ColorRes.warning,
                                    size: 18,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    "${double.tryParse(contractor.overallRating)}  (${contractor.totalReviews})",
                                    style: TextStyle(
                                      fontSize: AppFontSizes.bodySmall,
                                      fontWeight: AppFontWeights.medium,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // ---------------- CONTACT BUTTON ----------------
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (UserHelper.isGuest) {
                            Get.to(() => LoginScreen());
                          } else {
                            if (contractorServiceController
                                .selectedItems
                                .isNotEmpty) {
                              contactContractor();
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              UserHelper.isGuest
                                  ? ColorRes.primary
                                  : contractorServiceController
                                      .selectedItems
                                      .isEmpty
                                  ? ColorRes.leadGreyColor.shade500
                                  : ColorRes.primary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          UserHelper.isGuest
                              ? "Login to Contact"
                              : 'Contact Now',
                          style: TextStyle(
                            fontSize: AppFontSizes.bodySmall,
                            fontWeight: AppFontWeights.semiBold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // ---------------- STATS GRID ----------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statCard(
                        "Total Services",
                        contractor.totalServices.toString(),
                      ),
                      _statCard(
                        "Active Services",
                        contractor.activeServices.toString(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _statCard(
                        "Projects",
                        contractor.projectStats.totalProjects.toString(),
                      ),
                      _statCard(
                        "Experience",
                        "${contractor.totalExperience} years",
                        highlight: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // ---------------- SECTION TITLE ----------------
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Services Offered (${contractor.totalServices})",
                    style: TextStyle(
                      fontSize: AppFontSizes.body,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                ),
                Obx(
                  () => ElevatedButton(
                    onPressed: () {
                      isListSelectable.value = !isListSelectable.value;
                      // Clear selections when toggling off
                      if (!isListSelectable.value) {
                        contactContractor();
                        // contractorServiceController.clearSelection();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isListSelectable.value
                              ? ColorRes.green
                              : ColorRes.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      isListSelectable.value ? "Done" : "Select Services",
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // ---------------- SELECTED SERVICES COUNT ----------------
            Obx(() {
              if (contractorServiceController.selectedItems.isNotEmpty) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: ColorRes.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ColorRes.primary),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${contractorServiceController.selectedItems.length} service(s) selected",
                        style: TextStyle(
                          fontSize: AppFontSizes.bodySmall,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.primary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          contractorServiceController.clearSelection();
                        },
                        child: Text(
                          "Clear All",
                          style: TextStyle(
                            fontSize: AppFontSizes.bodySmall,
                            color: ColorRes.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            // ---------------- LOGIN ALERT ----------------
            if (UserHelper.isGuest) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: ColorRes.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: ColorRes.primary),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Please login to select services and contact the contractor.",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            // ---------------- SERVICE CARDS ----------------
            Obx(() {
              if (contractorServiceController.isLoading.value &&
                  contractorServiceController.items.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (!contractorServiceController.isLoading.value &&
                  contractorServiceController.items.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text("No services found."),
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final data = contractorServiceController.items[index];
                  return Obx(
                    () => ServiceCard(
                      service: data,
                      isSelectable: isListSelectable.value,
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 16),
                itemCount: contractorServiceController.items.length,
              );
            }),
            // Loading indicator for pagination
            Obx(() {
              if (contractorServiceController.isLoading.value &&
                  contractorServiceController.items.isNotEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return const SizedBox.shrink();
            }),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, {bool highlight = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorRes.leadGreyColor.shade300),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: AppFontSizes.bodySmall,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.grey,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: AppFontWeights.semiBold,
                color: highlight ? ColorRes.primary : ColorRes.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final bool isSelectable;
  final ContractorServiceItem service;

  const ServiceCard({
    super.key,
    required this.service,
    required this.isSelectable,
  });

  @override
  Widget build(BuildContext context) {
    final contractorController = Get.find<ContractorServiceController>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isSelectable &&
                      contractorController.selectedItems.contains(service)
                  ? ColorRes.primary
                  : ColorRes.leadGreyColor.shade300,
          width:
              isSelectable &&
                      contractorController.selectedItems.contains(service)
                  ? 2
                  : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with checkbox ------------------
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isSelectable) ...[
                  Obx(
                    () => Checkbox(
                      value: contractorController.selectedItems.contains(
                        service,
                      ),
                      onChanged: (value) {
                        contractorController.toggleSelectedService(service);
                      },
                      activeColor: ColorRes.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              service.serviceName,
                              style: TextStyle(
                                fontSize: AppFontSizes.body,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: ColorRes.warning,
                                size: 18,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${service.averageRating} (${service.totalReviews})',
                                style: TextStyle(
                                  fontSize: AppFontSizes.bodySmall,
                                  fontWeight: AppFontWeights.medium,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        service.description,
                        style: TextStyle(
                          fontSize: AppFontSizes.bodySmall,
                          fontWeight: AppFontWeights.medium,
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
          // Middle section ----------
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _detailColumn("PRICE", service.meta.priceRange),
                _detailColumn("AVAILABILITY", service.meta.workAvailability),
                _detailColumn(
                  "STATUS",
                  service.isActive ? "Active" : "Inactive",
                  highlight: true,
                ),
              ],
            ),
          ),
          Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
          // Features list -----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                _feature(service.meta.provideMaterials, "Materials Provided"),
                const SizedBox(height: 6),
                _feature(service.meta.equipmentProvided, "Equipment Provided"),
                const SizedBox(height: 6),
                _feature(
                  service.meta.insuranceAvailable,
                  "Insurance Available",
                ),
              ],
            ),
          ),
          Divider(color: ColorRes.leadGreyColor.shade300, height: 1),
          // Bottom section ----------
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _detailColumn(
                  "ADVANCE REQUIRED",
                  "${service.meta.advanceRequiredPercentage}%",
                ),
                Expanded(
                  child: _detailColumn(
                    "PAYMENT MODES",
                    service.meta.acceptedPaymentModes
                        .map((e) => e.replaceAll("_", " ").capitalize)
                        .join(", "),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailColumn(String title, String value, {bool highlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: AppFontSizes.bodySmall,
            fontWeight: AppFontWeights.semiBold,
            color: highlight ? ColorRes.green : ColorRes.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _feature(bool value, String title) {
    return Row(
      children: [
        Icon(
          value ? Icons.check_circle : Icons.cancel,
          color: value ? ColorRes.green : ColorRes.error,
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: AppFontSizes.bodySmall,
            fontWeight: AppFontWeights.medium,
            color: ColorRes.grey,
          ),
        ),
      ],
    );
  }
}
