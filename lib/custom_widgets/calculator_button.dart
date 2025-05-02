import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isDarkMode;

  const CalculatorButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color background;
    Color textColor;

    if (isDarkMode) {
      // Dark Mode Colors
      if (label == 'C' || label == '=') {
        background = const Color(0xFF6B46C1); // Soft violet
        textColor = Colors.white;
      } else if (['/', '*', '-', '+'].contains(label)) {
        background = const Color(0xFF3A3A3A); // Medium dark
        textColor = Colors.white;
      } else if (['sin(', 'cos(', 'tan(', '√'].contains(label)) {
        background = const Color(0xFF2E2E2E); // Dark grey
        textColor = const Color(0xFFEEEEEE);
      } else if (label == 'Unit') {
        background = const Color(0xFF9575CD); // Lavender grey
        textColor = Colors.white;
      } else {
        background = const Color(0xFF1E1E1E); // Almost black
        textColor = Colors.white70;
      }
    } else {
      // Light Mode Colors
      if (label == 'C' || label == '=') {
        background = const Color(0xFF4A5568); // Dark slate
        textColor = Colors.white;
      } else if (['/', '*', '-', '+'].contains(label)) {
        background = const Color(0xFFF7F7F7);
        textColor = const Color(0xFF0A0A0A);
      } else if (['sin(', 'cos(', 'tan(', '√'].contains(label)) {
        background = const Color(0xFFEDF1F7); // Pale blue
        textColor = const Color(0xFF1C1C1E);
      } else {
        background = const Color(0xFFF7F7F7); // Off white
        textColor = const Color(0xFF1C1C1E);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(40),
        splashColor: Colors.black12,
        child: Container(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(1, 3),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
