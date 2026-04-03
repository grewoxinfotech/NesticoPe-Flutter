import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PinnedSearchNotifier extends ChangeNotifier {
  bool _show = false;

  bool get show => _show;

  void update(bool value) {
    if (_show == value) return; // 🚫 prevents rebuild spam

    _show = value;
    notifyListeners();
  }
}