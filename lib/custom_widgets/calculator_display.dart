import 'package:flutter/material.dart';

class CalculatorDisplay extends StatelessWidget {
  final String expression;
  final String result;
  final bool isDarkMode;

  CalculatorDisplay({
    required this.expression,
    required this.result,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              expression,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            result,
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
