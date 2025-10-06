import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/builder/view/property_detail/property_detail.dart';
import 'package:housing_flutter_app/modules/builder/view/review/builder_property_review.dart';
import 'package:housing_flutter_app/modules/builder/view/widget/progress_line.dart';
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

class ProjectWizardView extends GetView<ProjectWizardController> {
  const ProjectWizardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Real Estate Project')),
      body: SafeArea(
        child: Obx(() {
          final step = controller.currentStep.value;
          return Column(
            children: [
              StepProgress(totalSteps: 5, currentStep: step),
              Expanded(child: _buildStep(step)),
              _buildNavBar(step),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStep(int step) {
    switch (step) {
      case 0:
        return StepBasicInfo(formKey: controller.formKeys[0]);
      case 1:
        return StepConfigurations(formKey: controller.formKeys[1]);
      case 2:
        return StepLocation(formKey: controller.formKeys[2]);
      case 3:
        return StepAdditional(formKey: controller.formKeys[3]);
      case 4:
      default:
        return StepReview(formKey: controller.formKeys[4]);
    }
  }

  Widget _buildNavBar(int step) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          if (step > 0)
            OutlinedButton(
              onPressed: controller.back,
              child: const Text('પાછળ'),
            ),
          const Spacer(),
          ElevatedButton(
            onPressed: step == 4 ? controller.submit : controller.next,
            child: Text(step == 4 ? 'Submit' : 'આગળ'),
          ),
        ],
      ),
    );
  }
}