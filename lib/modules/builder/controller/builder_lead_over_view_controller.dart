import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/widgets/snackbar/snackbar.dart';

class BuilderLeadOverviewController extends GetxController {
  // Track expanded configurations by index
  RxList<bool> isConfigExpanded = <bool>[].obs;

  void initConfigs(int length) {
    // Initialize all to false
    isConfigExpanded.value = List.generate(length, (_) => false);
  }

  void toggleConfig(int index) {
    isConfigExpanded[index] = !isConfigExpanded[index];
  }
  Future<void> downloadDocument(String? path) async {
    if (path != null) {
      await launchUrl(Uri.parse(path), mode: LaunchMode.platformDefault);
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Document',
        message: 'Loading...',
        contentType: ContentType.success,
      );
    }
  }
}
