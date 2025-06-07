import 'package:flutter/material.dart';
import 'package:smart_calculator/screens/calculator_screen.dart';
import 'package:smart_calculator/utils/calculator_engine.dart';

class CalculatorScreenModal extends StatefulWidget {
  final bool isDarkMode;
  final Function(List<String>) onSaveHistory;

  const CalculatorScreenModal({
    super.key,
    required this.isDarkMode,
    required this.onSaveHistory,
  });

  @override
  State<CalculatorScreenModal> createState() => _CalculatorScreenModalState();
}

class _CalculatorScreenModalState extends State<CalculatorScreenModal> {
  final CalculatorEngine _engine = CalculatorEngine();
  String _expression = '';
  String _result = '0';
  List<String> _history = [];

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
        widget.onSaveHistory(_history);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        gradient:
            widget.isDarkMode
                ? const LinearGradient(
                  colors: [Color(0xFF121212), Color(0xFF1F1F1F)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
                : const LinearGradient(
                  colors: [Color(0xFFF3F4F6), Color(0xFFE2E8F0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: CalculatorScreen(
          result: _result,
          expression: _expression,
          onButtonPressed: _buttonPressed,
          history: _history,
          isDarkMode: widget.isDarkMode,
          onEvaluate: _evaluate,
        ),
      ),
    );
  }
}
