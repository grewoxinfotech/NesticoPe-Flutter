// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
// import '../../controller/contractor_my_service_controller.dart';
//
//
// class ContractorProject extends StatelessWidget {
//   const ContractorProject({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(ContractorMyServiceController());
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Services'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add_circle_outline_rounded),
//             onPressed: () {
//               // TODO: open Add Service Form
//             },
//           )
//         ],
//       ),
//       body: Obx(() {
//         final items = controller.items;
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (items.isEmpty) {
//           return const Center(child: Text("No services available"));
//         }
//
//         return ListView.builder(
//           padding: const EdgeInsets.all(12),
//           itemCount: items.length,
//           itemBuilder: (context, index) {
//             final item = items[index];
//             return ServiceCard(item: item);
//           },
//         );
//       }),
//     );
//   }
// }
//
// class ServiceCard extends StatefulWidget {
//   final ContractorServiceItem item;
//
//   const ServiceCard({super.key, required this.item});
//
//   @override
//   State<ServiceCard> createState() => _ServiceCardState();
// }
//
// class _ServiceCardState extends State<ServiceCard> {
//   bool expanded = false;
//
//   @override
//   Widget build(BuildContext context) {
//     final meta = widget.item.meta;
//     final acceptedPayments = meta.acceptedPaymentModes;
//
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       margin: const EdgeInsets.only(bottom: 16),
//       elevation: 1,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Header Row
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     widget.item.serviceName,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     _buildStatusBadge(widget.item.isActive ? "Active" : "Inactive"),
//                     IconButton(
//                       icon: const Icon(Icons.edit, color: Colors.blueAccent),
//                       onPressed: () {
//                         // TODO: Edit logic
//                       },
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
//                       onPressed: () {
//                         // TODO: Delete logic
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 4),
//             Text(
//               "${_getPriceModel(meta.priceModel)} • ₹${meta.price.toStringAsFixed(0)}",
//               style: const TextStyle(fontSize: 14, color: Colors.black54),
//             ),
//             const SizedBox(height: 4),
//             Row(
//               children: [
//                 const Icon(Icons.star, size: 16, color: Colors.amber),
//                 const SizedBox(width: 4),
//                 Text("${widget.item.averageRating} (${widget.item.totalReviews})",
//                     style: const TextStyle(fontSize: 14, color: Colors.black54)),
//               ],
//             ),
//             const SizedBox(height: 4),
//             Text(
//               "Renovation & Remodeling",
//               style: TextStyle(
//                 color: Colors.blue.shade700,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//
//             /// Expand/Collapse Button
//             InkWell(
//               onTap: () => setState(() => expanded = !expanded),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
//                         color: Colors.grey),
//                   ],
//                 ),
//               ),
//             ),
//
//             /// Expanded Section
//             if (expanded) ...[
//               _buildTag(meta.workAvailability.capitalizeFirst ?? "Immediate",
//                   Colors.green.shade100, Colors.green),
//               const SizedBox(height: 8),
//
//               /// Range + Advance
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _infoTile("Starting Range", meta.startingPriceRange),
//                   _infoTile("Advance", "${meta.advanceRequiredPercentage}%"),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _infoTile("Billing", meta.billingType.toUpperCase()),
//                   _infoTile("Brands", meta.brandsUsed),
//                 ],
//               ),
//               const SizedBox(height: 12),
//
//               const Text("Service Includes",
//                   style: TextStyle(fontWeight: FontWeight.w600)),
//               const SizedBox(height: 6),
//               Wrap(
//                 spacing: 8,
//                 children: [
//                   if (meta.provideMaterials) _chip("Materials", Colors.green),
//                   if (meta.equipmentProvided) _chip("Equipment", Colors.green),
//                   if (meta.insuranceAvailable) _chip("Insurance", Colors.green),
//                 ],
//               ),
//
//               const SizedBox(height: 12),
//               const Text("Payment Methods",
//                   style: TextStyle(fontWeight: FontWeight.w600)),
//               const SizedBox(height: 6),
//               Wrap(
//                 spacing: 8,
//                 children: acceptedPayments
//                     .map((e) => _chip(e.toUpperCase(), Colors.blueAccent))
//                     .toList(),
//               ),
//
//               const SizedBox(height: 12),
//               const Text("Description",
//                   style: TextStyle(fontWeight: FontWeight.w600)),
//               const SizedBox(height: 4),
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   widget.item.description.isEmpty
//                       ? "No description provided"
//                       : widget.item.description,
//                   style: const TextStyle(color: Colors.black87),
//                 ),
//               ),
//             ]
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildStatusBadge(String text) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       margin: const EdgeInsets.only(right: 4),
//       decoration: BoxDecoration(
//         color: text == "Active" ? Colors.blue.shade100 : Colors.grey.shade300,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 12,
//           color: text == "Active" ? Colors.blue : Colors.grey.shade700,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }
//
//   Widget _infoTile(String title, String value) {
//     return Expanded(
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(title,
//                 style: const TextStyle(
//                     color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500)),
//             const SizedBox(height: 4),
//             Text(value.isEmpty ? "-" : value,
//                 style:
//                 const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _chip(String label, Color color) {
//     return Chip(
//       label: Text(label, style: const TextStyle(color: Colors.white)),
//       backgroundColor: color,
//       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//       visualDensity: VisualDensity.compact,
//     );
//   }
//
//   Widget _buildTag(String label, Color bgColor, Color textColor) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration:
//       BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
//       child: Text(label,
//           style: TextStyle(color: textColor, fontWeight: FontWeight.w600, fontSize: 12)),
//     );
//   }
//
//   String _getPriceModel(String model) {
//     switch (model) {
//       case 'fixed':
//         return 'Fixed';
//       case 'hourly':
//         return 'Hourly';
//       case 'per_sq_ft':
//         return 'Per Sq Ft';
//       default:
//         return model.capitalizeFirst ?? '';
//     }
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/utils/formater/formater.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../../../data/network/contractor/model/contractot_service_model/contractor_service_model.dart';
import '../../../aadhar_auth/screens/aadhar_auth_screen.dart';
import '../../controller/contractor_my_service_controller.dart';
import '../widget/cotractor_active_switch.dart';
import '../widget/create_service_from.dart';

class ContractorService extends StatelessWidget {
  const ContractorService({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContractorMyServiceController>();

    return Scaffold(
      backgroundColor: ColorRes.background,
      appBar: AppBar(
        backgroundColor: ColorRes.surface,
        leading: IconButton(onPressed: () {
          Get.back();
        }, icon: Icon(Icons.arrow_back)),
        elevation: 0,
        title: Text(
          'My Services',
          style: TextStyle(
            // fontSize: AppFontSizes.title,
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline_rounded,
              color: ColorRes.primary,
              size: 28,
            ),
            onPressed: () {
              if (!UserHelper.isAadharVerified) {
                Get.to(() => AadharAuthScreen());
              } else {
                controller.clearForm();
                Get.to(() => AddServiceScreen());
              }
            },
          ),
        ],
      ),
      // body: Obx(() {
      //   final items = controller.items;
      //   if (controller.isLoading.value) {
      //     return Center(
      //       child: CircularProgressIndicator(
      //         color: ColorRes.primary,
      //       ),
      //     );
      //   }
      //
      //   if (items.isEmpty) {
      //     return Center(
      //       child: Text(
      //         "No services available",
      //         style: TextStyle(
      //           fontSize: AppFontSizes.body,
      //           color: ColorRes.textSecondary,
      //           fontWeight: AppFontWeights.medium,
      //         ),
      //       ),
      //     );
      //   }
      //
      //   return ListView.builder(
      //     padding: const EdgeInsets.all(12),
      //     itemCount: items.length,
      //     itemBuilder: (context, index) {
      //       final item = items[index];
      //       return ServiceCard(item: item,controller: controller,);
      //     },
      //   );
      // }),
      body: Obx(() {
        final items = controller.items;

        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: ColorRes.primary),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.refreshService,
          color: ColorRes.primary,
          child:
              items.isEmpty
                  ? SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: Text(
                          "No services available",
                          style: TextStyle(
                            fontSize: AppFontSizes.body,
                            color: ColorRes.textSecondary,
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                      ),
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ServiceCard(item: item, controller: controller);
                    },
                  ),
        );
      }),
    );
  }
}

class ServiceCard extends StatefulWidget {
  final ContractorServiceItem item;

  final ContractorMyServiceController controller;

  const ServiceCard({super.key, required this.item, required this.controller});

  @override
  State<ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  bool expanded = false;
  String categoryName = "";
  bool isCategoryLoading = true;
  @override
  void initState() {
    super.initState();
    // loadCategory();
  }

/*  void loadCategory() async {
    final id = widget.item.category ?? "";
    if (id.isEmpty) return;

    final name = await widget.controller.getTheContractorByID(id);
    setState(() {
      categoryName = name;
      isCategoryLoading = false;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    final meta = widget.item.meta;
    final acceptedPayments = meta.acceptedPaymentModes;

    return GestureDetector(
      onTap: () => setState(() => expanded = !expanded),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: ColorRes.leadGreyColor.shade300, width: 1),
        ),
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 2,
        color: ColorRes.surface,
        shadowColor: ColorRes.shadow,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.item.serviceName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppFontSizes.medium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color:
                          widget.item.isActive
                              ? ColorRes.primary.withOpacity(0.1)
                              : ColorRes.disabled.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            widget.item.isActive
                                ? ColorRes.primary.withOpacity(0.3)
                                : ColorRes.border,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.item.isActive ? "Active" : "Inactive",
                      style: TextStyle(
                        fontSize: AppFontSizes.mini,
                        color:
                            widget.item.isActive
                                ? ColorRes.primary
                                : ColorRes.textSecondary,
                        fontWeight: AppFontWeights.semiBold,
                      ),
                    ),
                  ),
                  _buildStatusBadge(widget.item.isActive, (value) {}),
                ],
              ),

              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_getPriceModel(meta.priceModel)} • ${Formatter.formatPrice(meta.minPriceRange)}- ${Formatter.formatPrice(meta.maxPriceRange)}",
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      color: ColorRes.textSecondary,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: ColorRes.homeAmber.withOpacity(
                        0.08,
                      ), // soft amber background
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorRes.homeAmber.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 14, color: ColorRes.homeAmber),
                        const SizedBox(width: 4),
                        Text(
                          "${widget.item.averageRating} ",
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            color: ColorRes.textPrimary,
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                        Text(
                          "(${widget.item.totalReviews})",
                          style: TextStyle(
                            fontSize: AppFontSizes.mini,
                            color: ColorRes.textSecondary.withOpacity(0.9),
                            fontWeight: AppFontWeights.regular,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Obx(() {
                final name = widget.controller.categoryNames[widget.item.category] ?? "Loading...";
                return Text(
                  name,
                  style: TextStyle(
                    fontSize: AppFontSizes.bodySmall,
                    color: ColorRes.primary,
                    fontWeight: AppFontWeights.medium,
                  ),
                );
              }),

              /// Expanded Section
              if (expanded) ...[
                const SizedBox(height: 8),
                Divider(color: ColorRes.leadGreyColor.withOpacity(0.3)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _buildTag(
                      meta.workAvailability.capitalizeFirst
                              ?.split("_")
                              .join(" ") ??
                          "Immediate",
                      ColorRes.success.withOpacity(0.1),
                      ColorRes.success,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: ColorRes.primary,
                            size: 22,
                          ),
                          onPressed: () {
                            widget.controller.clearForm();
                            Get.to(
                              () =>
                                  AddServiceScreen(serviceToEdit: widget.item),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: ColorRes.error,
                            size: 22,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: ColorRes.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: Text(
                                    "Delete Service",
                                    style: TextStyle(
                                      fontSize: AppFontSizes.large,
                                      fontWeight: AppFontWeights.semiBold,
                                      color: ColorRes.textColor,
                                    ),
                                  ),
                                  content: const Text(
                                    "Are you sure you want to delete this service?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context); // close dialog
                                      },
                                      child: const Text("No"),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorRes.error,
                                      ),
                                      onPressed: () {
                                        Get.back();
                                        // close dialog first
                                        widget.controller.deleteService(
                                          widget.item.id ?? '',
                                        );
                                      },
                                      child: const Text("Yes"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                /// Range + Advance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoTile(
                      "Min Price",
                      Formatter.formatPrice(meta.minPriceRange),
                    ),
                    _infoTile(
                      "Max Price",
                      Formatter.formatPrice(meta.maxPriceRange),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoTile(
                      "Billing",
                      meta.billingType.toUpperCase().split("_").join(" "),
                    ),
                    _infoTile("Advance", "${meta.advanceRequiredPercentage}%"),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Brands",
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorRes.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ColorRes.border, width: 1),
                  ),
                  child: Text(
                    meta.brandsUsed.isEmpty
                        ? "No description provided"
                        : meta.brandsUsed,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      color: ColorRes.textPrimary,
                      fontWeight: AppFontWeights.regular,
                      height: 1.5,
                    ),
                  ),
                ),

                if ((meta.provideMaterials) ||
                    (meta.equipmentProvided) ||
                    (meta.insuranceAvailable)) ...[
                  const SizedBox(height: 16),
                  Text(
                    "Service Includes",
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (meta.provideMaterials)
                        _chip("Materials", ColorRes.success),
                      if (meta.equipmentProvided)
                        _chip("Equipment", ColorRes.success),
                      if (meta.insuranceAvailable)
                        _chip("Insurance", ColorRes.success),
                    ],
                  ),
                ],

                const SizedBox(height: 16),
                Text(
                  "Payment Methods",
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      acceptedPayments
                          .map(
                            (e) => _chip(
                              e.toUpperCase().split("_").join(" "),
                              ColorRes.primary,
                            ),
                          )
                          .toList(),
                ),

                const SizedBox(height: 16),
                Text(
                  "Description",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: ColorRes.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: ColorRes.border, width: 1),
                  ),
                  child: Text(
                    widget.item.description.isEmpty
                        ? "No description provided"
                        : widget.item.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      color: ColorRes.textPrimary,
                      fontWeight: AppFontWeights.regular,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive, ValueChanged<bool> onChanged) {
    final controller = Get.find<ContractorMyServiceController>();

    return CustomSwitch(
      value: isActive,
      activeColor: ColorRes.primary,
      inactiveColor: ColorRes.leadGreyColor.shade400,
      onChanged: (val) {
        // Call controller toggle
        controller.toggle(widget.item, val);
      },
    );
  }

  Widget _infoTile(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorRes.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorRes.border, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: ColorRes.textSecondary,
                fontSize: AppFontSizes.extraSmall,
                fontWeight: AppFontWeights.medium,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value.isEmpty ? "-" : value,
              maxLines: 1,
              style: TextStyle(
                color: ColorRes.textPrimary,
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.semiBold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: ColorRes.white,
          fontSize: AppFontSizes.caption,
          fontWeight: AppFontWeights.medium,
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: textColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontWeight: AppFontWeights.semiBold,
          fontSize: AppFontSizes.caption,
        ),
      ),
    );
  }

  String _getPriceModel(String model) {
    switch (model) {
      case 'fixed':
        return 'Fixed';
      case 'hourly':
        return 'Hourly';
      case 'per_sq_ft':
        return 'Per Sq Ft';
      default:
        return model.capitalizeFirst ?? '';
    }
  }
}
