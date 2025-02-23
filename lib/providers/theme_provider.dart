import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_news/ui/theme/colors.dart';

class ThemeProvider with ChangeNotifier {
  late ThemeData _themeData;
  ThemeMode _themeMode = ThemeMode.dark;
  late MaterialTheme _materialTheme;

  MaterialTheme get materialTheme => _materialTheme;

  void setMaterialTheme(MaterialTheme materialTheme) {
    _materialTheme = materialTheme;
    _themeData = _themeMode == ThemeMode.light
      ? _materialTheme.light()
      : _materialTheme.dark();
    notifyListeners();
  }

  ThemeProvider(this._materialTheme) {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;
  ThemeData get themeData => _themeData;

  void toggleTheme() async {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
      _themeData = _materialTheme.light();
    } else {
      _themeMode = ThemeMode.dark;
      _themeData = _materialTheme.dark();
    }

    notifyListeners();
    _saveTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isLight = prefs.getBool('isLightTheme') ?? false;
    _themeMode = isLight ? ThemeMode.light : ThemeMode.dark;
    _themeData = _themeMode == ThemeMode.light ? _materialTheme.light() : _materialTheme.dark();
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLightTheme', _themeMode == ThemeMode.light);
  }
}