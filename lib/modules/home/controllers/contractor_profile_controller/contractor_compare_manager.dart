import 'package:get/get.dart';
// adjust path to your Contractor model
import 'package:housing_flutter_app/app/manager/project_compare_manager.dart';

import '../../../../app/manager/compare_manager.dart';
import '../../../../data/network/contractor/model/contractor_profile_model/contractor_profile_model.dart';
import '../../../../widgets/messages/snack_bar.dart';

class ContractorCompareManager extends GetxController {
  static ContractorCompareManager get to =>
      Get.find<ContractorCompareManager>();

  final RxMap<String, Contractor> _selected = <String, Contractor>{}.obs;

  RxMap<String, Contractor> get selected => _selected;
  List<Contractor> get selectedList => _selected.values.toList(growable: false);
  int get count => _selected.length;

  bool isSelected(String? id) => id != null && _selected.containsKey(id);

  void toggle(Contractor contractor, {int max = 2}) {
    final id = contractor.userId;
    if (id.isEmpty) return;

    if (_selected.containsKey(id)) {
      _selected.remove(id);
      _selected.refresh();
      return;
    }

    if (_selected.length >= max) {
      // You can show a snackbar or toast here

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Limit Reached',
        message: 'You can compare up to $max contractors only',
        contentType: ContentType.failure,
      );
      return;
    }

    // Clear project comparison if this is the first contractor comparison
    if (_selected.isEmpty && Get.isRegistered<ProjectCompareManager>()) {
      try {
        ProjectCompareManager.to.clear();
      } catch (e) {
        print('Error clearing project comparison: $e');
      }
    }

    if (_selected.isEmpty && Get.isRegistered<CompareManager>()) {
      try {
        CompareManager.to.clear();
      } catch (e) {
        print('Error clearing Contractor comparison: $e');
      }
    }

    _selected[id] = contractor;
    _selected.refresh();
  }

  void remove(String id) {
    _selected.remove(id);
    _selected.refresh();
  }

  void clear() {
    _selected.clear();
    _selected.refresh();
  }
}
