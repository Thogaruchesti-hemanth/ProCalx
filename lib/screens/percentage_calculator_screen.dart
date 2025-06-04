import 'package:flutter/material.dart';

class PercentageScreen extends StatefulWidget {
  final bool isDarkMode;
  const PercentageScreen({super.key, required this.isDarkMode});

  @override
  State<PercentageScreen> createState() => _PercentageScreenState();
}

class _PercentageScreenState extends State<PercentageScreen> {
  final TextEditingController value1Controller = TextEditingController();
  final TextEditingController value2Controller = TextEditingController();

  int selectedCalcIndex = 0;

  final List<String> calcTypes = [
    "X% of Y",
    "X is what % of Y",
    "Y increased by X%",
    "Y decreased by X%",
    "Difference % between X & Y",
  ];

  String getLabel1() {
    switch (selectedCalcIndex) {
      case 0:
        return "Percentage (X)";
      case 1:
        return "Part (X)";
      case 2:
        return "Increase % (X)";
      case 3:
        return "Decrease % (X)";
      case 4:
        return "First Value (X)";
      default:
        return "Value 1";
    }
  }

  String getLabel2() {
    switch (selectedCalcIndex) {
      case 0:
        return "Base Value (Y)";
      case 1:
        return "Whole (Y)";
      case 2:
        return "Original Value (Y)";
      case 3:
        return "Original Value (Y)";
      case 4:
        return "Second Value (Y)";
      default:
        return "Value 2";
    }
  }

  String calculationType(int index) {
    switch (index) {
      case 0:
        return "X% of Y";
      case 1:
        return "X is what % of Y";
      case 2:
        return "Y increased by X%";
      case 3:
        return "Y decreased by X%";
      case 4:
        return "Percentage Difference";
      default:
        return "Unknown";
    }
  }

  String calculationFormula(int index) {
    switch (index) {
      case 0:
        return "(X / 100) × Y";
      case 1:
        return "(X / Y) × 100";
      case 2:
        return "Y + (X% of Y)";
      case 3:
        return "Y - (X% of Y)";
      case 4:
        return "|X - Y| / ((X + Y) / 2) × 100";
      default:
        return "";
    }
  }

  String formatAnswer() {
    final answer = calculateResult();
    if (answer == 0.0) return "Invalid Input";
    return answer.toStringAsFixed(2);
  }

  double calculateResult() {
    final double x = double.tryParse(value1Controller.text) ?? 0;
    final double y = double.tryParse(value2Controller.text) ?? 0;

    switch (selectedCalcIndex) {
      case 0:
        return (x / 100) * y;
      case 1:
        return y == 0 ? 0 : (x / y) * 100;
      case 2:
        return y + ((x / 100) * y);
      case 3:
        return y - ((x / 100) * y);
      case 4:
        return y == 0 ? 0 : ((x - y).abs() / ((x + y) / 2)) * 100;
      default:
        return 0;
    }
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
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Percentage Calculator',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<int>(
              value: selectedCalcIndex,
              items: List.generate(calcTypes.length, (index) {
                return DropdownMenuItem(
                  value: index,
                  child: Text(
                    calcTypes[index],
                    style: TextStyle(color: textColor),
                  ),
                );
              }),
              dropdownColor:
                  widget.isDarkMode ? Colors.grey[900] : Colors.white,
              onChanged: (index) {
                setState(() => selectedCalcIndex = index!);
              },
              decoration: InputDecoration(
                labelText: "Calculation Type",
                labelStyle: TextStyle(color: subTextColor),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            buildInputRow(getLabel1(), value1Controller, textColor),
            SizedBox(height: 16),
            buildInputRow(getLabel2(), value2Controller, textColor),
            SizedBox(height: 28),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Result",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: textColor,
                ),
              ),
            ),
            SizedBox(height: 8),
            if (value1Controller.text.isNotEmpty &&
                value2Controller.text.isNotEmpty)
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(top: 24),
                decoration: BoxDecoration(
                  color:
                      widget.isDarkMode
                          ? Colors.grey[900]
                          : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "📊 Calculation Summary",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "🔹 Type: ${calculationType(selectedCalcIndex)}",
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "🔹 Inputs: ${value1Controller.text} & ${value2Controller.text}",
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "🔹 Formula: ${calculationFormula(selectedCalcIndex)}",
                      style: TextStyle(fontSize: 16, color: subTextColor),
                    ),
                    Divider(height: 24, color: Colors.grey),
                    Row(
                      children: [
                        Text(
                          "✅ Result: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          formatAnswer(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildInputRow(
    String label,
    TextEditingController controller,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: widget.isDarkMode ? Colors.grey[900] : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: controller,
            onChanged: (_) => setState(() {}),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Enter value',
              hintStyle: TextStyle(color: Colors.grey),
            ),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}
