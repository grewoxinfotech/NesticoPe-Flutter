import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/data/network/builder/model/builder_model.dart';
import 'package:nesticope_app/modules/builder/view/media/upload_media_screen.dart';
import 'package:nesticope_app/modules/builder/view/property_detail/property_detail.dart';
import 'package:nesticope_app/modules/builder/view/review/builder_property_review.dart';
import 'package:nesticope_app/modules/builder/view/widget/progress_line.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';
import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../controller/builder_form_controller.dart';
import 'additional_deatil/additional_detail.dart';
import 'basic/basic_info.dart';
import 'location/location.dart';

// import '../controllers/project_wizard_controller.dart';
// import '../widgets/step_progress.dart';
// import 'steps/step_basic_info.dart';
// import 'steps/step_configurations.dart';
// import 'steps/step_location.dart';
// import 'steps/step_additional.dart';
// import 'steps/step_review.dart';

// class CreateProjectScreen extends GetView<ProjectWizardController> {
//   // final ProjectModel? project;
//   final bool isFromEdit;
//   String? projectId;
//   CreateProjectScreen({
//     super.key,
//     this.isFromEdit = false,
//     // this.project
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // final ProjectWizardController controller = Get.put(ProjectWizardController(isBuilderView: false));
//
//     if (isFromEdit) {
//       projectId = Get.arguments;
//     }
//
//     return Scaffold(
//       backgroundColor: ColorRes.addPropertyBackgroundColor,
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder:
//               (context, constraints) => SingleChildScrollView(
//                 child: ConstrainedBox(
//                   constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                   child: IntrinsicHeight(
//                     child: Column(
//                       children: [
//                         Container(
//                           height: 50,
//                           width: double.infinity,
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 8,
//                             horizontal: 16,
//                           ),
//                           alignment: Alignment.topLeft,
//                           decoration: const BoxDecoration(
//                             color: ColorRes.addPropertyBackgroundColor,
//                           ),
//                           child: Row(
//                             children: [
//                               (controller.currentStep.value == 0)
//                                   ? Container(
//                                     height: 40,
//                                     width: 40,
//                                     decoration: BoxDecoration(
//                                       shape: BoxShape.circle,
//                                       color: ColorRes.leadGreyColor.shade300,
//                                     ),
//                                     alignment: Alignment.center,
//                                     child: IconButton(
//                                       onPressed: () {
//                                         Get.back();
//                                       },
//                                       icon: const Icon(
//                                         Icons.arrow_back,
//                                         color: ColorRes.black,
//                                         size: 20,
//                                       ),
//                                     ),
//                                   )
//                                   : SizedBox.shrink(),
//                               const SizedBox(width: 10),
//                               Text(
//                                 isFromEdit ? "Edit Listing" : "Create Listing",
//                                 style: TextStyle(
//                                   color: ColorRes.white,
//                                   fontSize: AppFontSizes.large,
//                                   fontWeight: AppFontWeights.bold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.symmetric(horizontal: 16),
//                           decoration: const BoxDecoration(
//                             color: ColorRes.addPropertyBackgroundColor,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const SizedBox(height: 5),
//                               Text(
//                                 "Sell or rent your property faster",
//                                 style: TextStyle(
//                                   color: ColorRes.white,
//                                   fontSize: AppFontSizes.body,
//                                   fontWeight: AppFontWeights.semiBold,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         Expanded(
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 16,
//                               vertical: 20,
//                             ),
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               color: ColorRes.white,
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(28),
//                                 topRight: Radius.circular(28),
//                               ),
//                             ),
//                             child: Obx(() {
//                               final step = controller.currentStep.value;
//                               print('Current styep $step');
//                               return SingleChildScrollView(
//                                 child: Column(
//                                   children: [
//                                     StepProgress(
//                                       totalSteps: 6,
//                                       currentStep: step,
//                                       labels: const [
//                                         'Basic Info',
//                                         'Property Config',
//                                         'Location',
//                                         'Additional Details',
//                                         'Upload Media',
//                                         'Review',
//                                       ],
//                                     ),
//                                     AnimatedSwitcher(
//                                       duration: const Duration(
//                                         milliseconds: 250,
//                                       ),
//                                       switchInCurve: Curves.easeOut,
//                                       switchOutCurve: Curves.easeIn,
//                                       child: _buildStep(step),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//         ),
//       ),
//       bottomNavigationBar: Obx(() {
//         final step = controller.currentStep.value;
//         return Container(
//           color: ColorRes.white,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           child: SafeArea(
//             child: Row(
//               children: [
//                 // Back Button
//                 if (step > 0)
//                   Expanded(
//                     child: SizedBox(
//                       height: 45,
//                       child: OutlinedButton(
//                         onPressed: controller.back,
//                         style: OutlinedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           side: const BorderSide(color: ColorRes.textColor),
//                           padding: const EdgeInsets.symmetric(vertical: 12),
//                         ),
//                         child: Text(
//                           'Back',
//                           style: TextStyle(
//                             fontSize: AppFontSizes.medium,
//                             color: ColorRes.textColor,
//                             fontWeight: AppFontWeights.medium,
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 else
//                   const Spacer(),
//
//                 const SizedBox(width: 12),
//
//                 // Next / Submit Button
//                 Expanded(
//                   child: SizedBox(
//                     height: 45,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (step == 5) {
//                           if (controller.isLoading.value)
//                             return; // do nothing while loading
//
//                           if (isFromEdit) {
//                             controller.updateProject(
//                               projectId ?? '',
//                             ); // update existing project
//                           } else {
//                             controller.submit(); // create new project
//                           }
//                         } else {
//                           controller.next(); // move to next step
//                         }
//                       },
//
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         elevation: 0,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         backgroundColor:
//                             controller.isLoading.value
//                                 ? ColorRes.primary.withOpacity(0.3)
//                                 : ColorRes.primary, // your theme color
//                       ),
//                       child:
//                           controller.isLoading.value
//                               ? Text(
//                                 isFromEdit ? "Updating..." : "Submitting...",
//                                 style: TextStyle(
//                                   fontSize: AppFontSizes.medium,
//                                   color: ColorRes.white,
//                                   fontWeight: AppFontWeights.medium,
//                                 ),
//                               )
//                               : Text(
//                                 step == 5
//                                     ? isFromEdit
//                                         ? 'Update'
//                                         : 'Submit'
//                                     : 'Next',
//                                 style: TextStyle(
//                                   fontSize: AppFontSizes.medium,
//                                   color: Colors.white,
//                                   fontWeight: AppFontWeights.medium,
//                                 ),
//                               ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildStep(int step) {
//     // Ensure step is within valid range (0-5)
//     if (step < 0 || step >= controller.formKeys.length) {
//       return const Center(child: Text('Invalid step'));
//     }
//
//     switch (step) {
//       case 0:
//         return StepBasicInfo(formKey: controller.formKeys[0]);
//       case 1:
//         return StepConfigurations(
//           formKey: controller.formKeys[1],
//           isFromEdit: isFromEdit,
//         );
//       case 2:
//         return StepLocation(formKey: controller.formKeys[2]);
//       case 3:
//         return StepAdditional(formKey: controller.formKeys[3]);
//       case 4:
//         return UploadMediaScreen(formKey: controller.formKeys[4]);
//       case 5:
//         return StepReview(
//           formKey: controller.formKeys[5],
//         ); // Use index 5 since formKeys now has 6 elements (0-5)
//       default:
//         return const Center(child: Text('Step not found'));
//     }
//   }
//
//   Widget _buildNavBar(int step) {
//     return const SizedBox.shrink();
//   }
// }

class CreateProjectScreen extends GetView<ProjectWizardController> {
  // final ProjectModel? project;
  final bool isFromEdit;
  String? projectId;
  CreateProjectScreen({
    super.key,
    this.isFromEdit = false,
    // this.project
  });

  @override
  Widget build(BuildContext context) {
    // final ProjectWizardController controller = Get.put(ProjectWizardController(isBuilderView: false));

    if (isFromEdit) {
      projectId = Get.arguments;
    }

    return Scaffold(
      backgroundColor: ColorRes.addPropertyBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder:
              (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          alignment: Alignment.topLeft,
                          decoration: const BoxDecoration(
                            color: ColorRes.addPropertyBackgroundColor,
                          ),
                          child: Row(
                            children: [
                              (controller.currentStep.value == 0)
                                  ? Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorRes.leadGreyColor.shade300,
                                    ),
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        color: ColorRes.black,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                  : SizedBox.shrink(),
                              const SizedBox(width: 10),
                              Text(
                                isFromEdit ? "Edit Listing" : "Create Listing",
                                style: TextStyle(
                                  color: ColorRes.white,
                                  fontSize: AppFontSizes.large,
                                  fontWeight: AppFontWeights.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: const BoxDecoration(
                            color: ColorRes.addPropertyBackgroundColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                "Sell or rent your property faster",
                                style: TextStyle(
                                  color: ColorRes.white,
                                  fontSize: AppFontSizes.body,
                                  fontWeight: AppFontWeights.semiBold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 20,
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: ColorRes.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(28),
                                topRight: Radius.circular(28),
                              ),
                            ),
                            child: Obx(() {
                              final step = controller.currentStep.value;
                              print('Current styep $step');
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    StepProgress(
                                      totalSteps: 6,
                                      currentStep: step,
                                      labels: const [
                                        'Basic Info',
                                        'Property Config',
                                        'Location',
                                        'Additional Details',
                                        'Upload Media',
                                        'Review',
                                      ],
                                    ),
                                    AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      switchInCurve: Curves.easeOut,
                                      switchOutCurve: Curves.easeIn,
                                      child: KeyedSubtree(  key: ValueKey<int>(step),child: _buildStep(step)),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        final step = controller.currentStep.value;
        return Container(
          color: ColorRes.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SafeArea(
            child: Row(
              children: [
                // Back Button
                if (step > 0)
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: OutlinedButton(
                        onPressed: controller.back,
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: const BorderSide(color: ColorRes.textColor),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Back',
                          style: TextStyle(
                            fontSize: AppFontSizes.medium,
                            color: ColorRes.textColor,
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  const Spacer(),

                const SizedBox(width: 12),

                // Next / Submit Button
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        // Check for remaining units when on step 1 (Configuration step)
                        if (step == 1) {
                          final p = controller.project.value;
                          final totalUnits = p.projectSize.totalUnits ?? 0;
                          final usedUnits = p.configurations
                              .expand((cfg) => cfg.variants)
                              .fold<int>(
                                0,
                                (sum, v) => sum + (v.totalUnits ?? 0),
                              );
                          final remainingUnits = totalUnits - usedUnits;

                          if (remainingUnits > 0) {
                            NesticoPeSnackBar.showAwesomeSnackbar(
                              title: 'Incomplete Config.',
                              message:
                                  'Please distribute all $remainingUnits remaining units before proceeding',
                              contentType: ContentType.failure,
                            );
                            return; // Don't proceed
                          }
                        }

                        if (step == 5) {
                          if (controller.isLoading.value)
                            return; // do nothing while loading

                          if (isFromEdit) {
                            controller.updateProject(
                              projectId ?? '',
                            ); // update existing project
                          } else {
                            controller.submit(); // create new project
                          }
                        } else {
                          controller.next(); // move to next step
                        }
                      },

                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor:
                            controller.isLoading.value
                                ? ColorRes.primary.withOpacity(0.3)
                                : ColorRes.primary, // your theme color
                      ),
                      child:
                          controller.isLoading.value
                              ? Text(
                                isFromEdit ? "Updating..." : "Submitting...",
                                style: TextStyle(
                                  fontSize: AppFontSizes.medium,
                                  color: ColorRes.white,
                                  fontWeight: AppFontWeights.medium,
                                ),
                              )
                              : Text(
                                step == 5
                                    ? isFromEdit
                                        ? 'Update'
                                        : 'Submit'
                                    : 'Next',
                                style: TextStyle(
                                  fontSize: AppFontSizes.medium,
                                  color: Colors.white,
                                  fontWeight: AppFontWeights.medium,
                                ),
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStep(int step) {
    // Ensure step is within valid range (0-5)
    if (step < 0 || step >= controller.formKeys.length) {
      return const Center(child: Text('Invalid step'));
    }

    switch (step) {
      case 0:
        return StepBasicInfo(formKey: controller.formKeys[0]);
      case 1:
        return StepConfigurations(
          formKey: controller.formKeys[1],
          isFromEdit: isFromEdit,
        );
      case 2:
        return StepLocation(formKey: controller.formKeys[2]);
      case 3:
        return StepAdditional(formKey: controller.formKeys[3]);
      case 4:
        return UploadMediaScreen();
      case 5:
        return StepReview(

        ); // Use index 5 since formKeys now has 6 elements (0-5)
      default:
        return const Center(child: Text('Step not found'));
    }
  }

  Widget _buildNavBar(int step) {
    return const SizedBox.shrink();
  }
}
