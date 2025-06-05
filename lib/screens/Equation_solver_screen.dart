import 'dart:math';

import 'package:flutter/material.dart';

class EquationSolverScreen extends StatefulWidget {
  final bool isDarkMode;
  const EquationSolverScreen({super.key, required this.isDarkMode});

  @override
  State<EquationSolverScreen> createState() => _EquationSolverScreenState();
}

class _EquationSolverScreenState extends State<EquationSolverScreen> {
  final TextEditingController aController = TextEditingController();
  final TextEditingController bController = TextEditingController();
  final TextEditingController cController = TextEditingController();

  final TextEditingController sysA1Controller = TextEditingController();
  final TextEditingController sysB1Controller = TextEditingController();
  final TextEditingController sysC1Controller = TextEditingController();

  final TextEditingController sysA2Controller = TextEditingController();
  final TextEditingController sysB2Controller = TextEditingController();
  final TextEditingController sysC2Controller = TextEditingController();

  final TextEditingController expressionController = TextEditingController();

  int selectedCalcIndex = 0;

  final List<String> calcTypes = [
    "Solve Linear Equation (ax + b = 0)",
    "Solve Quadratic Equation (ax² + bx + c = 0)",
    "Solve System of 2 Linear Equations",
    "Evaluate Arithmetic Expression",
  ];

  String calculateLinear(double a, double b) {
    if (a == 0) {
      if (b == 0) return "Infinite solutions (identity)";
      return "No solution";
    }
    double x = -b / a;
    return "x = ${x.toStringAsFixed(4)}";
  }

  String calculateQuadratic(double a, double b, double c) {
    if (a == 0) return calculateLinear(b, c);
    double discriminant = b * b - 4 * a * c;

    if (discriminant > 0) {
      double root1 = (-b + sqrt(discriminant)) / (2 * a);
      double root2 = (-b - sqrt(discriminant)) / (2 * a);
      return "Roots:\nx₁ = ${root1.toStringAsFixed(4)}\nx₂ = ${root2.toStringAsFixed(4)}";
    } else if (discriminant == 0) {
      double root = -b / (2 * a);
      return "One root:\nx = ${root.toStringAsFixed(4)}";
    } else {
      double realPart = -b / (2 * a);
      double imagPart = sqrt(-discriminant) / (2 * a);
      return "Complex roots:\nx₁ = ${realPart.toStringAsFixed(4)} + ${imagPart.toStringAsFixed(4)}i\nx₂ = ${realPart.toStringAsFixed(4)} - ${imagPart.toStringAsFixed(4)}i";
    }
  }

  String solveSystemLinear(
    double a1,
    double b1,
    double c1,
    double a2,
    double b2,
    double c2,
  ) {
    double det = a1 * b2 - a2 * b1;
    if (det == 0) {
      if (a1 * c2 == a2 * c1 && b1 * c2 == b2 * c1) {
        return "Infinite solutions";
      } else {
        return "No solution";
      }
    }
    double x = (c1 * b2 - c2 * b1) / det;
    double y = (a1 * c2 - a2 * c1) / det;
    return "x = ${x.toStringAsFixed(4)}\ny = ${y.toStringAsFixed(4)}";
  }

  // Simple arithmetic expression evaluator (only +,-,*,/ and parentheses)
  // Using Dart's expression evaluation package would be better,
  // but here is a simple implementation using 'expression_language' or basic try-catch with Dart eval is not possible natively.
  // So here we'll just try double.parse and return error for complex expressions.
  String evaluateExpression(String expr) {
    try {
      // For a robust solution, integrate a math expression parser like 'math_expressions' package.
      // Here, just try to parse as double for demo.
      double val = double.parse(expr);
      return val.toString();
    } catch (_) {
      return "Complex expression evaluation requires external package";
    }
  }

  String calculateResult() {
    switch (selectedCalcIndex) {
      case 0:
        double a = double.tryParse(aController.text) ?? 0;
        double b = double.tryParse(bController.text) ?? 0;
        return calculateLinear(a, b);

      case 1:
        double a = double.tryParse(aController.text) ?? 0;
        double b = double.tryParse(bController.text) ?? 0;
        double c = double.tryParse(cController.text) ?? 0;
        return calculateQuadratic(a, b, c);

      case 2:
        double a1 = double.tryParse(sysA1Controller.text) ?? 0;
        double b1 = double.tryParse(sysB1Controller.text) ?? 0;
        double c1 = double.tryParse(sysC1Controller.text) ?? 0;
        double a2 = double.tryParse(sysA2Controller.text) ?? 0;
        double b2 = double.tryParse(sysB2Controller.text) ?? 0;
        double c2 = double.tryParse(sysC2Controller.text) ?? 0;
        return solveSystemLinear(a1, b1, c1, a2, b2, c2);

      case 3:
        String expr = expressionController.text.trim();
        return evaluateExpression(expr);

      default:
        return "Select a calculation type";
    }
  }

  Widget buildInputField({
    required String label,
    required TextEditingController controller,
    required Color textColor,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: textColor),
          border: OutlineInputBorder(),
          hintText: hint,
        ),
        style: TextStyle(color: textColor),
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final subTextColor = widget.isDarkMode ? Colors.grey[300] : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text("Equation Solver", style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                labelText: "Select Equation Type",
                labelStyle: TextStyle(color: subTextColor),
                border: OutlineInputBorder(),
              ),
              dropdownColor:
                  widget.isDarkMode ? Colors.grey[900] : Colors.white,
              value: selectedCalcIndex,
              items: List.generate(
                calcTypes.length,
                (index) => DropdownMenuItem(
                  value: index,
                  child: Text(
                    calcTypes[index],
                    style: TextStyle(color: textColor),
                  ),
                ),
              ),
              onChanged: (val) => setState(() => selectedCalcIndex = val!),
            ),
            SizedBox(height: 20),

            // Inputs based on selectedCalcIndex
            if (selectedCalcIndex == 0) ...[
              buildInputField(
                label: "a",
                controller: aController,
                textColor: textColor,
              ),
              buildInputField(
                label: "b",
                controller: bController,
                textColor: textColor,
              ),
            ] else if (selectedCalcIndex == 1) ...[
              buildInputField(
                label: "a",
                controller: aController,
                textColor: textColor,
              ),
              buildInputField(
                label: "b",
                controller: bController,
                textColor: textColor,
              ),
              buildInputField(
                label: "c",
                controller: cController,
                textColor: textColor,
              ),
            ] else if (selectedCalcIndex == 2) ...[
              Text(
                "Equation 1: a₁x + b₁y = c₁",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: textColor,
                ),
              ),
              buildInputField(
                label: "a₁",
                controller: sysA1Controller,
                textColor: textColor,
              ),
              buildInputField(
                label: "b₁",
                controller: sysB1Controller,
                textColor: textColor,
              ),
              buildInputField(
                label: "c₁",
                controller: sysC1Controller,
                textColor: textColor,
              ),
              SizedBox(height: 12),
              Text(
                "Equation 2: a₂x + b₂y = c₂",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: textColor,
                ),
              ),
              buildInputField(
                label: "a₂",
                controller: sysA2Controller,
                textColor: textColor,
              ),
              buildInputField(
                label: "b₂",
                controller: sysB2Controller,
                textColor: textColor,
              ),
              buildInputField(
                label: "c₂",
                controller: sysC2Controller,
                textColor: textColor,
              ),
            ] else if (selectedCalcIndex == 3) ...[
              buildInputField(
                label: "Expression (e.g. 3+4*2/(1-5)^2)",
                controller: expressionController,
                textColor: textColor,
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 8),
              Text(
                "Note: Advanced expression evaluation requires external packages.",
                style: TextStyle(fontSize: 12, color: subTextColor),
              ),
            ],

            SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    widget.isDarkMode ? Colors.grey[900] : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                calculateResult(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.orangeAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
