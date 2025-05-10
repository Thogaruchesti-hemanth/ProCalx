import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  get isDarkMode => _isDarkMode;
  void updateTheme() {
    print("hello world");
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
