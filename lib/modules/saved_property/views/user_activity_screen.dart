import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/saved_property/views/saved_property_screen.dart';

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

        // BLUR OVERLAY (only for guest)
        if (UserHelper.isGuest)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                color: Colors.black.withOpacity(0.3), // dim effect
              ),
            ),
          ),

        // CENTER LOGIN BUTTON
        if (UserHelper.isGuest)
          Center(
            child: ElevatedButton(
              onPressed: () {
                Get.to(() => LoginScreen()); // or your login route
              },
              child: const Text(
                'Login to Continue',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
      ],
    );
  }
}
