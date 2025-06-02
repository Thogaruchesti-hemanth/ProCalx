import 'dart:math';

import 'package:flutter/material.dart';

class InterestCalculatorScreen extends StatefulWidget {
  final bool isDarkMode;
  const InterestCalculatorScreen({super.key, required this.isDarkMode});

  @override
  State<InterestCalculatorScreen> createState() =>
      _InterestCalculatorScreenState();
}

class _InterestCalculatorScreenState extends State<InterestCalculatorScreen> {
  final TextEditingController depositController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController periodController = TextEditingController();

  int selectedType = 0;
  String compoundingFrequency = 'Yearly';

  final List<String> calcTypes = ['Simple Interest', 'Compound Interest'];
  final List<String> frequencies = ['Daily', 'Monthly', 'Quarterly', 'Yearly'];

  double calculateInterest() {
    final double p = double.tryParse(depositController.text) ?? 0;
    final double r = double.tryParse(rateController.text) ?? 0;
    final double t = double.tryParse(periodController.text) ?? 0;
    final double rateDecimal = r / 100;

    if (selectedType == 0) {
      return p * rateDecimal * t;
    } else {
      int n = getCompoundingFrequency();
      return p * (pow((1 + rateDecimal / n), n * t)) - p;
    }
  }

  double calculateFinalAmount() {
    final double p = double.tryParse(depositController.text) ?? 0;
    return p + calculateInterest();
  }

  int getCompoundingFrequency() {
    switch (compoundingFrequency) {
      case 'Daily':
        return 365;
      case 'Monthly':
        return 12;
      case 'Quarterly':
        return 4;
      case 'Yearly':
        return 1;
      default:
        return 1;
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
              'Interest Calculator',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<int>(
              value: selectedType,
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
              onChanged: (index) => setState(() => selectedType = index!),
              decoration: InputDecoration(
                labelText: "Calculation Type",
                labelStyle: TextStyle(color: subTextColor),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            buildInputRow("Deposit (₹)", depositController, textColor),
            SizedBox(height: 16),
            buildInputRow("Interest Rate (%)", rateController, textColor),
            SizedBox(height: 16),
            buildInputRow("Period (Years)", periodController, textColor),
            if (selectedType == 1) ...[
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: compoundingFrequency,
                items:
                    frequencies.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: textColor)),
                      );
                    }).toList(),
                dropdownColor:
                    widget.isDarkMode ? Colors.grey[900] : Colors.white,
                onChanged: (val) => setState(() => compoundingFrequency = val!),
                decoration: InputDecoration(
                  labelText: "Compounding Frequency",
                  labelStyle: TextStyle(color: subTextColor),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            SizedBox(height: 28),
            if (depositController.text.isNotEmpty &&
                rateController.text.isNotEmpty &&
                periodController.text.isNotEmpty)
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
                      "📊 Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "🔹 Interest Type: ${calcTypes[selectedType]}",
                      style: TextStyle(color: textColor),
                    ),
                    if (selectedType == 1)
                      Text(
                        "🔹 Compounded: $compoundingFrequency",
                        style: TextStyle(color: subTextColor),
                      ),
                    SizedBox(height: 6),
                    Divider(height: 24, color: Colors.grey),
                    Text(
                      "✅ Interest Earned: ₹${calculateInterest().toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "💰 Final Value: ₹${calculateFinalAmount().toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
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
