import 'dart:math';

import 'package:flutter/material.dart';

class LoanCalculatorScreen extends StatefulWidget {
  final bool isDarkMode;
  const LoanCalculatorScreen({super.key, required this.isDarkMode});

  @override
  State<LoanCalculatorScreen> createState() => _LoanCalculatorScreenState();
}

class _LoanCalculatorScreenState extends State<LoanCalculatorScreen> {
  final TextEditingController loanController = TextEditingController();
  final TextEditingController rateController = TextEditingController();
  final TextEditingController periodController = TextEditingController();

  double monthlyPayment = 0;
  double totalPayment = 0;
  double totalInterest = 0;

  void calculateLoan() {
    final double principal = double.tryParse(loanController.text) ?? 0;
    final double annualRate = double.tryParse(rateController.text) ?? 0;
    final double years = double.tryParse(periodController.text) ?? 0;

    if (principal <= 0 || annualRate <= 0 || years <= 0) {
      setState(() {
        monthlyPayment = 0;
        totalPayment = 0;
        totalInterest = 0;
      });
      return;
    }

    final double monthlyRate = annualRate / 100 / 12;
    final int months = (years * 12).round();

    // EMI formula: [P × r × (1 + r)^n] / [(1 + r)^n – 1]
    final double emi =
        (principal * monthlyRate * pow(1 + monthlyRate, months)) /
        (pow(1 + monthlyRate, months) - 1);

    setState(() {
      monthlyPayment = emi;
      totalPayment = emi * months;
      totalInterest = totalPayment - principal;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final subTextColor = widget.isDarkMode ? Colors.grey[400] : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text('Loan Calculator', style: TextStyle(color: textColor)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInputField("Loan Amount (₹)", loanController, textColor),
            SizedBox(height: 16),
            buildInputField(
              "Annual Interest Rate (%)",
              rateController,
              textColor,
            ),
            SizedBox(height: 16),
            buildInputField("Loan Period (Years)", periodController, textColor),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: calculateLoan,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Calculate",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 32),
            if (monthlyPayment > 0)
              Container(
                padding: EdgeInsets.all(20),
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
                      "Results",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 12),
                    resultRow(
                      "Monthly Payment (EMI):",
                      "₹${monthlyPayment.toStringAsFixed(2)}",
                      textColor,
                    ),
                    SizedBox(height: 8),
                    resultRow(
                      "Total Payment:",
                      "₹${totalPayment.toStringAsFixed(2)}",
                      textColor,
                    ),
                    SizedBox(height: 8),
                    resultRow(
                      "Total Interest:",
                      "₹${totalInterest.toStringAsFixed(2)}",
                      textColor,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(
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
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(
              decimal: true,
              signed: false,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter $label",
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

  Widget resultRow(String label, String value, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}
