import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/builder/model/builder_model.dart';

import 'package:housing_flutter_app/app/manager/compare_manager.dart';

import '../../modules/home/controllers/contractor_profile_controller/contractor_compare_manager.dart';

class ProjectCompareManager extends GetxController {
  static ProjectCompareManager get to => Get.find<ProjectCompareManager>();

  // Store selected projects by ID for quick lookup and full item for UI
  final RxMap<String, ProjectItem> _selected = <String, ProjectItem>{}.obs;

  RxMap<String, ProjectItem> get selected => _selected;
  List<ProjectItem> get selectedList => _selected.values.toList(growable: false);
  int get count => _selected.length;

  bool isSelected(String? id) => id != null && _selected.containsKey(id);


  void toggle(ProjectItem item, {int max = 2}) {
    final id = item.id;
    if (id.isEmpty) return;
    
    if (_selected.containsKey(id)) {
      _selected.remove(id);
      _selected.refresh();
      return;
    }
    
    if (_selected.length >= max) {
      // Ignore if max reached; UI can show a message
      return;
    }
    

    if (_selected.isEmpty && Get.isRegistered<CompareManager>()) {
      try {
        CompareManager.to.clear();
      } catch (e) {
        print('Error clearing property comparison: $e');
      }
    }    if (_selected.isEmpty && Get.isRegistered<ContractorCompareManager>()) {
      try {
        ContractorCompareManager.to.clear();
      } catch (e) {
        print('Error clearing property comparison: $e');
      }
    }

    
    _selected[id] = item;
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
