import 'package:flutter/material.dart';

class RatioScreen extends StatefulWidget {
  final bool isDarkMode;
  const RatioScreen({super.key, required this.isDarkMode});

  @override
  State<RatioScreen> createState() => _RatioScreenState();
}

class _RatioScreenState extends State<RatioScreen> {
  final TextEditingController part1Controller = TextEditingController();
  final TextEditingController part2Controller = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController knownPartController = TextEditingController();

  int selectedCalcIndex = 0;

  final List<String> calcTypes = [
    "Simplify Ratio (a : b)",
    "Find ratio a : b",
    "Find part given total and ratio",
    "Find total given parts and ratio",
  ];

  String calculationType(int index) {
    switch (index) {
      case 0:
        return "Simplify Ratio (a : b)";
      case 1:
        return "Find ratio a : b";
      case 2:
        return "Find part given total and ratio";
      case 3:
        return "Find total given parts and ratio";
      default:
        return "Unknown";
    }
  }

  // Greatest Common Divisor helper
  int gcd(int a, int b) {
    while (b != 0) {
      int t = b;
      b = a % b;
      a = t;
    }
    return a.abs();
  }

  String simplifyRatio(int a, int b) {
    if (a == 0 || b == 0) return "Invalid inputs";
    int gcdValue = gcd(a, b);
    int first = a ~/ gcdValue;
    int second = b ~/ gcdValue;
    return "$first : $second";
  }

  String findRatio(int a, int b) {
    if (b == 0) return "Cannot divide by zero";
    double ratio = a / b;
    return ratio.toStringAsFixed(2);
  }

  String findPartGivenTotalAndRatio(int total, int partRatio, int totalRatio) {
    if (totalRatio == 0) return "Invalid ratio";
    double part = (total * partRatio) / totalRatio;
    return part.toStringAsFixed(2);
  }

  String findTotalGivenPartsAndRatio(
    int partValue,
    int partRatio,
    int totalRatio,
  ) {
    if (partRatio == 0) return "Invalid ratio";
    double total = (partValue * totalRatio) / partRatio;
    return total.toStringAsFixed(2);
  }

  String calculateResult() {
    switch (selectedCalcIndex) {
      case 0: // Simplify Ratio (a:b)
        final int a = int.tryParse(part1Controller.text) ?? 0;
        final int b = int.tryParse(part2Controller.text) ?? 0;
        return simplifyRatio(a, b);

      case 1: // Find ratio a:b (decimal)
        final int a = int.tryParse(part1Controller.text) ?? 0;
        final int b = int.tryParse(part2Controller.text) ?? 0;
        return findRatio(a, b);

      case 2: // Find part given total and ratio (partRatio : totalRatio)
        final int total = int.tryParse(totalController.text) ?? 0;
        final int partRatio = int.tryParse(part1Controller.text) ?? 0;
        final int totalRatio = int.tryParse(part2Controller.text) ?? 0;
        return findPartGivenTotalAndRatio(total, partRatio, totalRatio);

      case 3: // Find total given parts and ratio
        final int partValue = int.tryParse(knownPartController.text) ?? 0;
        final int partRatio = int.tryParse(part1Controller.text) ?? 0;
        final int totalRatio = int.tryParse(part2Controller.text) ?? 0;
        return findTotalGivenPartsAndRatio(partValue, partRatio, totalRatio);

      default:
        return "Invalid calculation";
    }
  }

  Widget buildInputField({
    required String label,
    required TextEditingController controller,
    required Color textColor,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: textColor,
          ),
        ),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType ?? TextInputType.number,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: hint ?? 'Enter value',
          ),
          style: TextStyle(color: textColor, fontSize: 16),
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
        title: Text("Ratio Calculator", style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              value: selectedCalcIndex,
              decoration: InputDecoration(
                labelText: "Select Calculation Type",
                labelStyle: TextStyle(color: subTextColor),
                border: OutlineInputBorder(),
              ),
              dropdownColor:
                  widget.isDarkMode ? Colors.grey[900] : Colors.white,
              items: List.generate(calcTypes.length, (index) {
                return DropdownMenuItem(
                  value: index,
                  child: Text(
                    calcTypes[index],
                    style: TextStyle(color: textColor),
                  ),
                );
              }),
              onChanged: (index) => setState(() => selectedCalcIndex = index!),
            ),
            SizedBox(height: 20),

            // Inputs based on selectedCalcIndex
            if (selectedCalcIndex == 0) ...[
              buildInputField(
                label: "Part 1 (a)",
                controller: part1Controller,
                textColor: textColor,
              ),
              SizedBox(height: 16),
              buildInputField(
                label: "Part 2 (b)",
                controller: part2Controller,
                textColor: textColor,
              ),
            ] else if (selectedCalcIndex == 1) ...[
              buildInputField(
                label: "Value a",
                controller: part1Controller,
                textColor: textColor,
              ),
              SizedBox(height: 16),
              buildInputField(
                label: "Value b",
                controller: part2Controller,
                textColor: textColor,
              ),
            ] else if (selectedCalcIndex == 2) ...[
              buildInputField(
                label: "Total",
                controller: totalController,
                textColor: textColor,
              ),
              SizedBox(height: 16),
              buildInputField(
                label: "Part Ratio (a)",
                controller: part1Controller,
                textColor: textColor,
              ),
              SizedBox(height: 16),
              buildInputField(
                label: "Total Ratio (b)",
                controller: part2Controller,
                textColor: textColor,
              ),
            ] else if (selectedCalcIndex == 3) ...[
              buildInputField(
                label: "Known Part Value",
                controller: knownPartController,
                textColor: textColor,
              ),
              SizedBox(height: 16),
              buildInputField(
                label: "Part Ratio (a)",
                controller: part1Controller,
                textColor: textColor,
              ),
              SizedBox(height: 16),
              buildInputField(
                label: "Total Ratio (b)",
                controller: part2Controller,
                textColor: textColor,
              ),
            ],

            SizedBox(height: 32),
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
                    "Result",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    calculateResult(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
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
