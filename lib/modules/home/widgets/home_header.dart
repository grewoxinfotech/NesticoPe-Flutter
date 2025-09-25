import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';
import 'package:housing_flutter_app/modules/profile/views/profile_screen.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';

import '../../../data/network/auth/model/user_model.dart';

class HomeHeader extends StatefulWidget {
  final String cityName;
  final List<String> propertyTypes;
  final String backgroundImage;

  const HomeHeader({
    super.key,
    this.cityName = "Surat, Gujarat",
    this.backgroundImage =
        "https://sitasurat.in/assets/images/about/surat-city.jpg",
    this.propertyTypes = const [
      "Buy",
      "Sell",
      "Rent",
      // "Commercial",
      "PG",
      // "Shop",
      // "Office",
      // "Studio",
      // "Warehouse",
    ],
  });

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Row: City + Post Property
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: ColorRes.white,
                            border: Border.all(
                              color: ColorRes.grey.withOpacity(0.2),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.notes_outlined,
                            color: ColorRes.black,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Location",
                              style: TextStyle(
                                fontSize: AppFontSizes.extraSmall,
                                color: ColorRes.primary,

                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              widget.cityName,
                              style: const TextStyle(
                                fontSize: AppFontSizes.body,
                                color: ColorRes.textColor,
                                fontWeight: AppFontWeights.semiBold,
                                // fontFamily: 'Roboto',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // SizedBox(width: 8),
              GestureDetector(
                onTap: (){
                  Get.to(()=>ProfileScreen(imageUrl: "https://img.freepik.com/premium-vector/man-avatar-profile-picture-isolated-background-avatar-profile-picture-man_1293239-4866.jpg",));
                },
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorRes.grey.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      "https://img.freepik.com/premium-vector/man-avatar-profile-picture-isolated-background-avatar-profile-picture-man_1293239-4866.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        ///MARK: Change here
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: buildPositionedTextField(context, () {
                  Get.to(() => const CommonSearchField());
                }),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  print("Mic tapped");
                  // Get.to(() => const CommonSearchField());
                  Get.to(
                    () => CreatePropertyScreen(
                      sellerType: mapUserRoleToSellerType(UserRole.seller),
                    ),
                  );
                },
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 15,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: ColorRes.grey.withOpacity(0.2)),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: ColorRes.primary,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        // const SizedBox(height: 8),
      ],
    );
  }
}

Widget buildPositionedTextField(BuildContext context, VoidCallback? onTap) {
  return GestureDetector(
    onTap: onTap,
    child: TextField(
      enabled: false, // same as your CustomTextField
      controller: TextEditingController(),
      decoration: InputDecoration(
        hintText: 'Change your Location ...',
        hintStyle: const TextStyle(fontSize: 14),
        filled: true,
        fillColor: ColorRes.white,
        prefixIcon: const Icon(Icons.search, color: ColorRes.primary, size: 22),

        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 12,
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorRes.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(16),
          // borderSide: BorderSide(
          //   color: ColorRes.grey,
          //   width: 1,
          // ), // remove border like your custom field
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorRes.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(16),
          // borderSide: BorderSide(
          //   color: ColorRes.grey,
          //   width: 1,
          // ), // remove border like your custom field
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ColorRes.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
  );
}

SellerType mapUserRoleToSellerType(UserRole role) {
  switch (role) {
    case UserRole.seller:
      return SellerType.owner;
    case UserRole.reseller:
      return SellerType.builder; // or any mapping
    default:
      return SellerType.owner;
  }
}
