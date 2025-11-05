import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';

class CompareManager extends GetxController {
  static CompareManager get to => Get.find<CompareManager>();

  // Store selected properties by ID for quick lookup and full item for UI
  final RxMap<String, Items> _selected = <String, Items>{}.obs;

  RxMap<String, Items> get selected => _selected;
  List<Items> get selectedList => _selected.values.toList(growable: false);
  int get count => _selected.length;

  bool isSelected(String? id) => id != null && _selected.containsKey(id);


  void toggle(Items item, {int max = 2}) {
    final id = item.id;
    if (id == null) return;
    if (_selected.containsKey(id)) {
      _selected.remove(id);
      _selected.refresh();
      return;
    }
    if (_selected.length >= max) {
      // Ignore if max reached; UI can show a message
      return;
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