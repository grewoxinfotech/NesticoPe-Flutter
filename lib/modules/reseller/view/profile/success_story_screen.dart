import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';

import '../../../../app/constants/color_res.dart';
import '../../controller/dashborad_controller/dashboard_controller.dart';
import '../property_reseller.dart';
import '../reseller_success_stories/add_reseller_success_stories_screen.dart';

class SuccessStoryScreen extends StatefulWidget {
  const SuccessStoryScreen({super.key});

  @override
  State<SuccessStoryScreen> createState() => _SuccessStoryScreenState();
}

class _SuccessStoryScreenState extends State<SuccessStoryScreen> {
  final controller = Get.find<DashboardController>();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Success Story ',style: TextStyle(fontWeight: AppFontWeights.semiBold),),

      ),
      body: Center(
        child:    Obx(() {
          final successStories =
              controller
                  .resellerInsightsModel
                  .value
                  ?.data
                  .successStories;

          final isEmpty =
              successStories == null ||
                  successStories.isEmpty;

          return isEmpty
              ? Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: ColorRes.white,
                    border: Border.all(
                      color:
                      ColorRes.leadGreyColor.shade300,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  padding: EdgeInsets.all(40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Share Your Success',
                        style: TextStyle(
                          fontSize: AppFontSizes.body,
                          fontWeight:
                          AppFontWeights.semiBold,
                          color: ColorRes.textColor,
                        ),
                      ),
                      SizedBox(height: 12),

                      Text(
                        'Add your achievement success and inspire others in the community',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          color:
                          ColorRes
                              .leadGreyColor
                              .shade700,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 20),

                      Container(
                        decoration: BoxDecoration(
                          color: ColorRes.primary,
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Get.to(
                                  () =>
                                  AddResellerSuccessStoryScreen(
                                    isEditMode: false,
                                  ),
                            );
                          },
                          icon: Icon(
                            Icons.add_circle_outline,
                            size: 22,
                          ),
                          label: Text(
                            'Add Success Story',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor:
                            Colors.transparent,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            textStyle: TextStyle(
                              fontSize:
                              AppFontSizes.medium,
                              fontWeight:
                              AppFontWeights.semiBold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(
                                12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                            ],
                          ),
              )
              : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,),
                child: SuccessStoryCard(
                  story: successStories.first,
                  controller: controller,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
