import 'package:get/get.dart';
import '../../controller/builder_form_controller.dart';
// import '../controller/builder_form_controller.dart';

class ProjectWizardBinding extends Bindings {
  @override
  void dependencies() {
    // The controller is created only once here
    Get.lazyPut(() => ProjectWizardController(isBuilderView: false));
  }
}
