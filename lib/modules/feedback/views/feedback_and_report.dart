// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
// import 'package:housing_flutter_app/widgets/New%20folder/inputs/text_field.dart';
//
// class FeedBackAndReportScreen extends StatefulWidget {
//   final String propertyId;
//
//   const FeedBackAndReportScreen({super.key, required this.propertyId});
//
//   @override
//   State<FeedBackAndReportScreen> createState() =>
//       _FeedBackAndReportScreenState();
// }
//
// class _FeedBackAndReportScreenState extends State<FeedBackAndReportScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String? _selectedReason;
//   final TextEditingController _detailsController = TextEditingController();
//   String _selectedAvailability = "couldn't_talk";
//
//   List<String> reasons = [
//     'already_sold',
//     'wrong_information',
//     'fake_photos',
//     'listed_without_permission',
//     'scam_or_spam',
//   ];
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _detailsController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: ColorRes.primary,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.close, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           'Property Feedback',
//           style: TextStyle(color: ColorRes.white),
//         ),
//         bottom: TabBar(
//           controller: _tabController,
//           labelColor: Colors.white,
//           unselectedLabelColor: Colors.white70,
//           indicatorColor: Colors.white,
//           indicatorWeight: 3,
//           tabs: [
//             const Tab(text: 'Property Feedback'),
//             Tab(
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: const [
//                   Icon(Icons.error_outline, size: 18),
//                   SizedBox(width: 4),
//                   Text('Report Property'),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [_buildFeedbackTab(), _buildReportTab()],
//       ),
//     );
//   }
//
//   Widget _buildFeedbackTab() {
//     return Column(
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Is this property still available?',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 _buildRadioOption('Yes, it\'s available', 'yes'),
//                 const SizedBox(height: 12),
//                 _buildRadioOption('No, it\'s not available', 'no'),
//                 const SizedBox(height: 12),
//                 _buildRadioOption(
//                   'Couldn\'t talk to seller yet',
//                   'couldn\'t_talk',
//                 ),
//               ],
//             ),
//           ),
//         ),
//         _buildBottomButtons(
//           onSubmit: () {
//             // Handle submit feedback
//             Navigator.of(context).pop();
//           },
//           submitText: 'Submit Feedback',
//           isEnabled: true,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildRadioOption(String label, String value) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           _selectedAvailability = value;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 4),
//         child: Row(
//           children: [
//             Radio<String>(
//               value: value,
//               groupValue: _selectedAvailability,
//               onChanged: (String? newValue) {
//                 setState(() {
//                   _selectedAvailability = newValue!;
//                 });
//               },
//               activeColor: ColorRes.primary,
//             ),
//             Expanded(
//               child: Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: AppFontSizes.bodyMedium,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildReportTab() {
//     return Column(
//       children: [
//         Expanded(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: ColorRes.warning.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Icon(
//                         Icons.warning,
//                         color: ColorRes.warning,
//                         size: 24,
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Important Warning',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: AppFontSizes.bodyMedium,
//                                 color: Colors.black87,
//                               ),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               'Please report responsibly. False or fake reports may result in your account being suspended or permanently blocked. Only submit if you have genuine concerns about this property.',
//                               style: TextStyle(
//                                 fontSize: AppFontSizes.bodySmall,
//                                 color: Colors.black.withOpacity(0.8),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//
//                 NesticoPeDropdownField<String>(
//                   value: _selectedReason,
//                   title: 'Reason for Report ',
//                   isRequired: true,
//                   hintText: 'Select a reason',
//                   items:
//                       reasons.map((reason) {
//                         return DropdownMenuItem(
//                           value: reason,
//                           child: Text(
//                             reason.replaceAll("_", " ").capitalize.toString(),
//                           ),
//                         );
//                       }).toList(),
//                   onChanged: (value) {
//                     setState(() {
//                       _selectedReason = value;
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 24),
//                 NesticoPeTextField(
//                   controller: _detailsController,
//                   maxLines: 5,
//                   maxLength: 500,
//                   title: 'Additional Details (Optional)',
//                   hintText:
//                       'Provide Additional Details about why you are reporting this property',
//                   onChanged: (text) {
//                     setState(() {});
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//         _buildBottomButtons(
//           onSubmit: () {
//             // Handle submit report
//             Navigator.of(context).pop();
//           },
//           submitText: 'Submit Report',
//           isEnabled: _selectedReason != null,
//         ),
//       ],
//     );
//   }
//
//   Widget _buildBottomButtons({
//     required VoidCallback onSubmit,
//     required String submitText,
//     required bool isEnabled,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               style: TextButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 12,
//                 ),
//               ),
//               child: Text(
//                 'Cancel',
//                 style: TextStyle(
//                   color: ColorRes.primary,
//                   fontSize: AppFontSizes.bodySmall,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             ElevatedButton(
//               onPressed: isEnabled ? onSubmit : null,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF4E6FDB),
//                 foregroundColor: Colors.white,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 24,
//                   vertical: 12,
//                 ),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 disabledBackgroundColor: Colors.grey[300],
//                 elevation: 0,
//               ),
//               child: Text(submitText, style: const TextStyle(fontSize: 16)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/dropdown_field.dart';
import 'package:housing_flutter_app/widgets/New%20folder/inputs/text_field.dart';

// Import controllers
import '../../reseller/controller/report/report_controller.dart';
import '../controller/feedback_controller.dart';

class FeedBackAndReportScreen extends StatefulWidget {
  final String propertyId;

  const FeedBackAndReportScreen({super.key, required this.propertyId});

  @override
  State<FeedBackAndReportScreen> createState() =>
      _FeedBackAndReportScreenState();
}

class _FeedBackAndReportScreenState extends State<FeedBackAndReportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Instantiate controllers
  final FeedbackController feedbackController = Get.put(FeedbackController());
  final ReportPropertyController reportController = Get.put(
    ReportPropertyController(),
  );

  String? _selectedReason;
  final TextEditingController _detailsController = TextEditingController();
  String _selectedAvailability = "couldn't_talk";

  List<String> reasons = [
    'already_sold',
    'wrong_information',
    'fake_photos',
    'listed_without_permission',
    'scam_or_spam',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    reportController.getPropertyReportsById(widget.propertyId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Property Feedback'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: ColorRes.textPrimary,
          unselectedLabelColor: ColorRes.textPrimary,
          indicatorColor: ColorRes.primary,
          indicatorWeight: 3,
          dividerColor: ColorRes.leadGreyColor.withOpacity(0.3),
          tabs: [
            Tab(text: 'Property Feedback'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 18, color: ColorRes.error),
                  SizedBox(width: 4),
                  Text(
                    'Report Property',
                    style: TextStyle(color: ColorRes.error),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildFeedbackTab(), _buildReportTab()],
      ),
    );
  }

  /// ====================== FEEDBACK TAB ======================
  Widget _buildFeedbackTab() {
    return Obx(() {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Is this property still available?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildRadioOption('Yes, it\'s available', 'yes'),
                  const SizedBox(height: 12),
                  _buildRadioOption('No, it\'s not available', 'no'),
                  const SizedBox(height: 12),
                  _buildRadioOption(
                    'Couldn\'t talk to seller yet',
                    'couldn\'t_talk',
                  ),
                ],
              ),
            ),
          ),
          _buildBottomButtons(
            isEnabled: true,
            submitText:
                feedbackController.isLoading.value
                    ? 'Submitting...'
                    : 'Submit Feedback',
            onSubmit:
                feedbackController.isLoading.value
                    ? () {}
                    : () async {
                      await feedbackController.submitFeedback(
                        propertyId: widget.propertyId,
                        inquiry: _selectedAvailability,
                      );
                      if (!feedbackController.isLoading.value) {
                        Navigator.of(context).pop();
                      }
                    },
          ),
        ],
      );
    });
  }

  Widget _buildRadioOption(String label, String value) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedAvailability = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _selectedAvailability,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedAvailability = newValue!;
                });
              },
              activeColor: ColorRes.primary,
            ),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: AppFontSizes.bodyMedium,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ====================== REPORT TAB ======================
  // Widget _buildReportTab() {
  //   return Obx(() {
  //     return Column(
  //       children: [
  //         Expanded(
  //           child: SingleChildScrollView(
  //             padding: const EdgeInsets.all(20),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Container(
  //                   padding: const EdgeInsets.all(16),
  //                   decoration: BoxDecoration(
  //                     color: ColorRes.warning.withOpacity(0.2),
  //                     borderRadius: BorderRadius.circular(8),
  //                   ),
  //                   child: Row(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const Icon(
  //                         Icons.warning,
  //                         color: ColorRes.warning,
  //                         size: 24,
  //                       ),
  //                       const SizedBox(width: 12),
  //                       Expanded(
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             const Text(
  //                               'Important Warning',
  //                               style: TextStyle(
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: AppFontSizes.bodyMedium,
  //                                 color: Colors.black87,
  //                               ),
  //                             ),
  //                             const SizedBox(height: 4),
  //                             Text(
  //                               'Please report responsibly. False or fake reports may result in your account being suspended or permanently blocked. Only submit if you have genuine concerns about this property.',
  //                               style: TextStyle(
  //                                 fontSize: AppFontSizes.bodySmall,
  //                                 color: Colors.black.withOpacity(0.8),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(height: 24),
  //                 NesticoPeDropdownField<String>(
  //                   value: _selectedReason,
  //                   title: 'Reason for Report ',
  //                   isRequired: true,
  //                   hintText: 'Select a reason',
  //                   items:
  //                       reasons.map((reason) {
  //                         return DropdownMenuItem(
  //                           value: reason,
  //                           child: Text(
  //                             reason.replaceAll("_", " ").capitalize.toString(),
  //                           ),
  //                         );
  //                       }).toList(),
  //                   onChanged: (value) {
  //                     setState(() {
  //                       _selectedReason = value;
  //                       reportController.setReason(value ?? '');
  //                     });
  //                   },
  //                 ),
  //                 const SizedBox(height: 24),
  //                 NesticoPeTextField(
  //                   controller: _detailsController,
  //                   maxLines: 5,
  //                   maxLength: 500,
  //                   title: 'Additional Details (Optional)',
  //                   hintText:
  //                       'Provide additional details about why you are reporting this property',
  //                   onChanged: (text) {
  //                     reportController.setAdditionalDetails(text);
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         _buildBottomButtons(
  //           isEnabled:
  //               _selectedReason != null && !reportController.isSubmitting.value,
  //           submitText:
  //               reportController.isSubmitting.value
  //                   ? 'Submitting...'
  //                   : 'Submit Report',
  //           onSubmit:
  //               reportController.isSubmitting.value
  //                   ? () {}
  //                   : () async {
  //                     await reportController.submitReport(widget.propertyId);
  //                     if (!reportController.isSubmitting.value) {
  //                       Navigator.of(context).pop();
  //                     }
  //                   },
  //         ),
  //       ],
  //     );
  //   });
  // }

  Widget _buildReportTab() {
    return Obx(() {
      // 1️⃣ Loading state
      if (reportController.isLoading.value && reportController.items.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      // 2️⃣ Already reported state
      if (!reportController.isLoading.value &&
          reportController.items.isNotEmpty) {
        final report = reportController.items.first;
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: ColorRes.error,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'You reported this property',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Reason: ${report.description ?? 'N/A'}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Date: ${report.createdAt ?? '--'}",
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => _tabController.animateTo(0),
                      icon: const Icon(Icons.feedback_outlined, size: 18),
                      label: const Text("Go to Feedback"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorRes.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }

      // 3️⃣ Report form UI
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔶 Warning Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorRes.warning.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorRes.warning.withOpacity(0.4),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: ColorRes.warning,
                          size: 30,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Important Warning',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Please report responsibly. False or fake reports may result in account suspension. Submit only if you have genuine concerns.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black.withOpacity(0.8),
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 🟩 Report Reason Dropdown
                  NesticoPeDropdownField<String>(
                    value: _selectedReason,
                    title: 'Reason for Report',
                    isRequired: true,
                    hintText: 'Select a reason',
                    items:
                        reasons.map((reason) {
                          return DropdownMenuItem(
                            value: reason,
                            child: Text(
                              reason.replaceAll("_", " ").capitalize.toString(),
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedReason = value;
                        reportController.setReason(value ?? '');
                      });
                    },
                  ),

                  const SizedBox(height: 24),

                  // 📝 Additional Details
                  NesticoPeTextField(
                    controller: _detailsController,
                    maxLines: 5,
                    maxLength: 500,
                    title: 'Additional Details (Optional)',
                    hintText:
                        'Provide additional details about why you are reporting this property',
                    onChanged: (text) {
                      reportController.setAdditionalDetails(text);
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // 🧭 Bottom Submit Bar
          _buildBottomButtons(
            isEnabled:
                _selectedReason != null && !reportController.isSubmitting.value,
            submitText:
                reportController.isSubmitting.value
                    ? 'Submitting...'
                    : 'Submit Report',
            onSubmit:
                reportController.isSubmitting.value
                    ? () {}
                    : () async {
                      await reportController.submitReport(widget.propertyId);
                      if (!reportController.isSubmitting.value) {
                        // After successful submission, refresh list
                        await reportController.getPropertyReportsById(
                          widget.propertyId,
                        );
                        setState(() {});
                      }
                    },
          ),
        ],
      );
    });
  }

  /// ====================== BOTTOM BUTTONS ======================
  Widget _buildBottomButtons({
    required VoidCallback onSubmit,
    required String submitText,
    required bool isEnabled,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: ColorRes.primary,
                  fontSize: AppFontSizes.bodySmall,
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: isEnabled ? onSubmit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4E6FDB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBackgroundColor: Colors.grey[300],
                elevation: 0,
              ),
              child: Text(submitText, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
