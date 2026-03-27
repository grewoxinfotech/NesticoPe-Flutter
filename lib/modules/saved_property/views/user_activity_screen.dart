import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/saved_property/views/saved_property_screen.dart';
import 'package:nesticope_app/modules/auth/views/register_screen.dart';
import 'package:lottie/lottie.dart';

import '../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../auth/views/login_screen.dart';

class UserActivityScreen extends StatelessWidget {
  const UserActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // MAIN SCREEN
        const SavedPropertyScreen(),
        // CENTER LOGIN BUTTON
        if (UserHelper.isGuest)
          Center(
            child: Container(
              width: 320,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Lottie.asset(
                      'assets/lottie/sign_in.json',
                      width: double.infinity,
            
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Login Required',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Login to save your favorite properties for easy access later.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Get.to(() => LoginScreen()),
                      child: Text(
                        'Login',
                        style: TextStyle(letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
