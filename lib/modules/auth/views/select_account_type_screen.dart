import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/auth/views/register_screen.dart';
import 'package:housing_flutter_app/widgets/bar/app_bar/common_bar.dart';

import '../../../data/network/auth/model/user_model.dart';

// No UserRole enum here — use the one from register_screen.dart

class SelectAccountTypeScreen extends StatelessWidget {
  const SelectAccountTypeScreen({Key? key}) : super(key: key);

  // Converts UserRole enum to display text
  String _roleToDisplayText(UserRole role) {
    switch (role) {
      case UserRole.buyer:
        return 'Buyer';
      case UserRole.seller:
        return 'Seller';
      case UserRole.reseller:
        return 'Reseller';
      case UserRole.contractor:
        return 'Contractor';
    }
  }

  // Returns an icon for each role
  IconData _roleIcon(UserRole role) {
    switch (role) {
      case UserRole.buyer:
        return Icons.shopping_cart;
      case UserRole.seller:
        return Icons.store;
      case UserRole.reseller:
        return Icons.repeat;
      case UserRole.contractor:
        return Icons.engineering;
    }
  }

  @override
  Widget build(BuildContext context) {
    const roles = UserRole.values;

    return Scaffold(
      appBar: const CommonNesticoPeAppBar(
        title: 'Select Account Type',
        showBackArrow: true,
        leadingIcon: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: roles.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final role = roles[index];
                  return GestureDetector(
                    onTap: () {
                      print('Selected role: ${_roleToDisplayText(role)}');
                      // Navigate to RegisterScreen with selected role
                      Get.to(() => RegisterScreen(role: role));
                    },
                    child: Card(
                      color: ColorRes.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _roleIcon(role),
                            size: 48,
                            color: ColorRes.white,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _roleToDisplayText(role),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: ColorRes.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
