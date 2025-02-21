import 'package:flutter/material.dart';

class GlobalStateProvider extends ChangeNotifier {
  bool _isScrollingAllowed = true;
  bool get isScrollingAllowed => _isScrollingAllowed;

  void toggleIsScrollingAllowed() {
    _isScrollingAllowed = !_isScrollingAllowed;
    notifyListeners();
  }
}
