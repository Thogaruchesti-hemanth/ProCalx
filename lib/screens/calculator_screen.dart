import 'package:flutter/material.dart';
import 'package:smart_calculator/custom_widgets/calculator_display.dart';

import '../custom_widgets/calculator_buttons.dart';

class CalculatorScreen extends StatelessWidget {
  final String expression;
  final String result;
  final List<String> history;
  final bool isDarkMode;
  final Function(String) onButtonPressed;
  final Function onEvaluate;

  CalculatorScreen({
    required this.expression,
    required this.result,
    required this.history,
    required this.isDarkMode,
    required this.onButtonPressed,
    required this.onEvaluate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient:
            isDarkMode
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
      ),
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: CalculatorDisplay(
              expression: expression,
              result: result,
              isDarkMode: isDarkMode,
            ),
          ),
          const Divider(),
          Expanded(
            flex: 4,
            child: CalculatorButtons(
              onButtonPressed: onButtonPressed,
              onEvaluate: onEvaluate,
              isDarkMode: isDarkMode,
            ),
          ),
        ],
      ),
    );
  }
}
