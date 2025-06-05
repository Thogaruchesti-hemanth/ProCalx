import 'package:flutter/material.dart';

class FractionScreen extends StatefulWidget {
  final bool isDarkMode;
  const FractionScreen({super.key, required this.isDarkMode});

  @override
  State<FractionScreen> createState() => _FractionScreenState();
}

class _FractionScreenState extends State<FractionScreen> {
  final TextEditingController aController =
      TextEditingController(); // Numerator 1
  final TextEditingController bController =
      TextEditingController(); // Denominator 1
  final TextEditingController cController =
      TextEditingController(); // Numerator 2
  final TextEditingController dController =
      TextEditingController(); // Denominator 2

  int selectedOperation = 0;

  final List<String> fractionOperations = [
    "Addition (a/b + c/d)",
    "Subtraction (a/b - c/d)",
    "Multiplication (a/b × c/d)",
    "Division (a/b ÷ c/d)",
    "Simplify a/b",
  ];

  String formatFraction(int num, int den) {
    if (den == 0) return "Undefined";
    final gcdValue = gcd(num.abs(), den.abs());
    final simplifiedNum = num ~/ gcdValue;
    final simplifiedDen = den ~/ gcdValue;

    if (simplifiedDen == 1) return "$simplifiedNum";
    return "$simplifiedNum / $simplifiedDen";
  }

  int gcd(int a, int b) {
    while (b != 0) {
      final t = b;
      b = a % b;
      a = t;
    }
    return a;
  }

  String calculateFraction() {
    final int a = int.tryParse(aController.text) ?? 0;
    final int b = int.tryParse(bController.text) ?? 1;
    final int c = int.tryParse(cController.text) ?? 0;
    final int d = int.tryParse(dController.text) ?? 1;

    int numerator = 0;
    int denominator = 1;

    switch (selectedOperation) {
      case 0: // Addition
        numerator = (a * d + b * c);
        denominator = b * d;
        break;
      case 1: // Subtraction
        numerator = (a * d - b * c);
        denominator = b * d;
        break;
      case 2: // Multiplication
        numerator = a * c;
        denominator = b * d;
        break;
      case 3: // Division
        numerator = a * d;
        denominator = b * c;
        break;
      case 4: // Simplify
        return formatFraction(a, b);
      default:
        return "Invalid";
    }

    return formatFraction(numerator, denominator);
  }

  Widget buildFractionInput(
    String label,
    TextEditingController numCtrl,
    TextEditingController denCtrl,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: numCtrl,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(hintText: "Numerator"),
                style: TextStyle(color: textColor),
              ),
            ),
            SizedBox(width: 12),
            Text("/", style: TextStyle(fontSize: 24, color: textColor)),
            SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: denCtrl,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(hintText: "Denominator"),
                style: TextStyle(color: textColor),
              ),
            ),
          ],
        ),
      ],
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
        title: Text("Fraction Calculator", style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              value: selectedOperation,
              items: List.generate(fractionOperations.length, (index) {
                return DropdownMenuItem(
                  value: index,
                  child: Text(
                    fractionOperations[index],
                    style: TextStyle(color: textColor),
                  ),
                );
              }),
              dropdownColor:
                  widget.isDarkMode ? Colors.grey[900] : Colors.white,
              onChanged: (index) => setState(() => selectedOperation = index!),
              decoration: InputDecoration(
                labelText: "Operation",
                labelStyle: TextStyle(color: subTextColor),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            buildFractionInput(
              "Fraction A (a/b)",
              aController,
              bController,
              textColor,
            ),
            if (selectedOperation != 4) ...[
              SizedBox(height: 20),
              buildFractionInput(
                "Fraction B (c/d)",
                cController,
                dController,
                textColor,
              ),
            ],
            SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    widget.isDarkMode ? Colors.grey[900] : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "🧮 Result",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    calculateFraction(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
