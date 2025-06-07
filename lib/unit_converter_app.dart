import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_calculator/provider/theme_provider.dart';
import 'package:smart_calculator/unit_converter.dart';
import 'package:smart_calculator/utils/preferences_service.dart';

import 'calculator_screen_model.dart';
import 'custom_widgets/calculator_appbar.dart';
import 'custom_widgets/calculator_drawer.dart';

class UnitConverterApp extends StatefulWidget {
  const UnitConverterApp({super.key});

  @override
  State<UnitConverterApp> createState() => _UnitConverterAppState();
}

class _UnitConverterAppState extends State<UnitConverterApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PreferencesService _preferencesService = PreferencesService();

  List<String> _history = [];
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() async {
    final darkMode = await _preferencesService.getDarkMode();
    final history = await _preferencesService.getHistory();
    setState(() {
      _isDarkMode = darkMode;
      _history = history;
    });
  }

  void _savePreferences() {
    _preferencesService.setDarkMode(_isDarkMode);
    _preferencesService.setHistory(_history);
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      _savePreferences();
    });
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
                _savePreferences();
              });
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    return Scaffold(
      key: _scaffoldKey,
      appBar: CalculatorAppBar(
        scaffoldKey: _scaffoldKey,
        isDarkMode: _isDarkMode,
        onToggleTheme: () => context.read<ThemeProvider>().updateTheme(),
      ),
      drawer: CalculatorDrawer(
        isDarkMode: _isDarkMode,
        history: _history,
        onClearHistory: () {
          setState(() {
            _history.clear();
            _savePreferences();
          });
        },
      ),
      body: const UnitConverter(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCalculator,
        label: Text(
          'Calculator',
          style: TextStyle(
            color: _isDarkMode ? Colors.black : Colors.white, // Text color
          ),
        ),
        icon: Icon(
          Icons.calculate,
          color: _isDarkMode ? Colors.black : Colors.white, // Icon color
        ),
        backgroundColor:
            _isDarkMode ? Colors.grey : Colors.black87, // Button background
      ),
    );
  }
}
