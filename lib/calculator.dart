import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_calculator/provider/theme_provider.dart';
import 'package:smart_calculator/unit_converter.dart';
import 'package:smart_calculator/utils/calculator_engine.dart';
import 'package:smart_calculator/utils/preferences_service.dart';

import 'custom_widgets/calculator_appbar.dart';
import 'custom_widgets/calculator_drawer.dart';
import 'screens/calculator_screen.dart';

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _expression = '';
  String _result = '0';
  List<String> _history = [];
  String _selectedMenu = 'calculator';
  bool _isDarkMode = false;

  final PreferencesService _preferencesService = PreferencesService();
  late final CalculatorEngine _engine;

  @override
  void initState() {
    super.initState();
    _engine = CalculatorEngine();
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

  void _buttonPressed(String text) {
    setState(() {
      if (text == 'C') {
        _expression = '';
        _result = '0';
      } else if (text == '=') {
        _evaluate();
      } else {
        _expression += text;
      }
    });
  }

  void _evaluate() {
    final result = _engine.evaluateExpression(_expression);
    setState(() {
      _result = result ?? 'Error';
      if (result != null) {
        _history.insert(0, '$_expression = $result');
        _expression = '';
        _savePreferences();
      }
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
      _savePreferences();
    });
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
        selectedMenu: _selectedMenu,
        history: _history,
        onSelectMenu: (value) => setState(() => _selectedMenu = value),
      ),
      body:
          _selectedMenu == 'calculator'
              ? CalculatorScreen(
                result: _result,
                expression: _expression,
                onButtonPressed: _buttonPressed,
                history: _history,
                isDarkMode: _isDarkMode,
                onEvaluate: _evaluate,
              )
              : const UnitConverter(),
    );
  }
}
