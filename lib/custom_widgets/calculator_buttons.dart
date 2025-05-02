import 'package:flutter/material.dart';

import '../data.dart';
import 'calculator_button.dart';

class CalculatorButtons extends StatelessWidget {
  final Function(String) onButtonPressed;
  final Function onEvaluate;
  final bool isDarkMode;

  const CalculatorButtons({
    required this.onButtonPressed,
    required this.onEvaluate,
    required this.isDarkMode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final flattenedLabels = buttonLabels.expand((row) => row).toList();

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: flattenedLabels.length,
      itemBuilder: (context, index) {
        final label = flattenedLabels[index];
        return CalculatorButton(
          label: label,
          isDarkMode: isDarkMode,
          onPressed:
              label == '=' ? () => onEvaluate() : () => onButtonPressed(label),
        );
      },
    );
  }
}
