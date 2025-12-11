import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../project/contractor_project.dart';
import '../widget/contractor_inquiry_screen.dart';
import '../widget/my_service_screen.dart';
import 'contractor_lead_screen.dart';

class ContractorLead extends StatelessWidget {
  const ContractorLead({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:  Text('Contractor Lead', style: TextStyle(
          // fontSize: AppFontSizes.title,
          fontWeight: AppFontWeights.semiBold,
          color: ColorRes.textPrimary,
        )),
        // centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigator.pushNamed(context, '/screen1');
                  Get.to(()=>MyServiceScreen());
                },
                child: const Text('My Service'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Get.to(()=>ContractorInquiryScreen());

                  // Navigator.pushNamed(context, '/screen2');
                },

                child: const Text('Inquiry'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  Get.to(()=>ContractorLeadScreen());
                  // Navigator.pushNamed(context, '/screen3');
                },
                child: const Text('Contractor Lead'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(

                onPressed: () {
                  Get.to(()=>ContractorProjectScreen());
                },
                child: const Text('Contractor Project'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  // Navigator.pushNamed(context, '/screen5');
                },
                child: const Text('Go to Screen 5'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
