import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_calculator/provider/theme_provider.dart';
import 'package:smart_calculator/unit_converter.dart';
import 'package:smart_calculator/utils/preferences_service.dart';

import 'calculator_screen_model.dart';
import 'custom_widgets/calculator_appbar.dart';
import 'custom_widgets/calculator_drawer.dart';

class UnitConverterApp extends StatefulWidget {
  const UnitConverterApp({Key? key}) : super(key: key);

  @override
  State<UnitConverterApp> createState() => _UnitConverterAppState();
}

class _UnitConverterAppState extends State<UnitConverterApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PreferencesService _preferencesService = PreferencesService();

  late List<String> _history;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _initializePreferences();
  }

  Future<void> _initializePreferences() async {
    final darkMode = await _preferencesService.getDarkMode();
    final history = await _preferencesService.getHistory();

    if (!mounted) return;

    setState(() {
      _isDarkMode = darkMode;
      _history = history;
    });
  }

  void _updateThemePreference() {
    _preferencesService.setDarkMode(_isDarkMode);
  }

  void _updateHistoryPreference() {
    _preferencesService.setHistory(_history);
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    _updateThemePreference();
  }

  void _openCalculator() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => CalculatorScreenModal(
            isDarkMode: _isDarkMode,
            onSaveHistory: (newHistory) {
              setState(() {
                _history = newHistory;
              });
              _updateHistoryPreference();
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      key: _scaffoldKey,
      appBar: CalculatorAppBar(
        scaffoldKey: _scaffoldKey,
        isDarkMode: isDarkMode,
        onToggleTheme: () {
          themeProvider.updateTheme();
          _toggleTheme(); // Persist to local storage
        },
      ),
      drawer: CalculatorDrawer(
        isDarkMode: isDarkMode,
        history: _history,
        onClearHistory: () {
          setState(() {
            _history.clear();
          });
          _updateHistoryPreference();
        },
      ),
      body: const UnitConverter(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCalculator,
        label: Text(
          'Calculator',
          style: TextStyle(color: isDarkMode ? Colors.black : Colors.white),
        ),
        icon: Icon(
          Icons.calculate,
          color: isDarkMode ? Colors.black : Colors.white,
        ),
        backgroundColor: isDarkMode ? Colors.grey : Colors.black87,
      ),
    );
  }
}
