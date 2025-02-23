import 'package:flutter/material.dart';

class GlobalStateProvider extends ChangeNotifier {
  bool _isScrollingAllowed = true;
  bool get isScrollingAllowed => _isScrollingAllowed;

  void toggleIsScrollingAllowed() {
    print(_isScrollingAllowed);
    _isScrollingAllowed = !_isScrollingAllowed;
    print(_isScrollingAllowed);
    notifyListeners();
  }

  int? _activeTileIndex;
  int? get activeTileIndex => _activeTileIndex;

  void updateActiveTileIndex(int? newIndex) {
    _activeTileIndex = newIndex;
    notifyListeners();
  }
}
