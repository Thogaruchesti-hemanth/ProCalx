import 'package:flutter/material.dart';

class ProportionScreen extends StatefulWidget {
  final bool isDarkMode;
  const ProportionScreen({super.key, required this.isDarkMode});

  @override
  State<ProportionScreen> createState() => _ProportionScreenState();
}

class _ProportionScreenState extends State<ProportionScreen> {
  final TextEditingController aController = TextEditingController();
  final TextEditingController bController = TextEditingController();
  final TextEditingController cController = TextEditingController();
  final TextEditingController dController = TextEditingController();

  int selectedType = 0;

  final List<String> proportionTypes = [
    "a : b = c : ?",
    "a : ? = c : d",
    "? : b = c : d",
    "Direct Proportion (a/b = c/d)",
    "Inverse Proportion (a × b = c × d)",
  ];

  Map<String, String>? calculateAnswer() {
    double? a = double.tryParse(aController.text);
    double? b = double.tryParse(bController.text);
    double? c = double.tryParse(cController.text);
    double? d = double.tryParse(dController.text);

    int nullCount = [a, b, c, d].where((val) => val == null).length;

    if (nullCount != 1) return null;

    if (a == null && b != null && c != null && d != null && d != 0) {
      double result = (b! * c!) / d!;
      return {
        'missing': 'a',
        'formula': 'a = (b × c) / d',
        'step': 'a = (${b} × ${c}) / ${d} = ${result.toStringAsFixed(2)}',
        'value': result.toStringAsFixed(2),
      };
    } else if (b == null && a != null && c != null && d != null && c != 0) {
      double result = (a! * d!) / c!;
      return {
        'missing': 'b',
        'formula': 'b = (a × d) / c',
        'step': 'b = (${a} × ${d}) / ${c} = ${result.toStringAsFixed(2)}',
        'value': result.toStringAsFixed(2),
      };
    } else if (c == null && a != null && b != null && d != null && b != 0) {
      double result = (a! * d!) / b!;
      return {
        'missing': 'c',
        'formula': 'c = (a × d) / b',
        'step': 'c = (${a} × ${d}) / ${b} = ${result.toStringAsFixed(2)}',
        'value': result.toStringAsFixed(2),
      };
    } else if (d == null && a != null && b != null && c != null && a != 0) {
      double result = (b! * c!) / a!;
      return {
        'missing': 'd',
        'formula': 'd = (b × c) / a',
        'step': 'd = (${b} × ${c}) / ${a} = ${result.toStringAsFixed(2)}',
        'value': result.toStringAsFixed(2),
      };
    }

    return null;
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
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: textColor,
          ),
        ),
        SizedBox(height: 6),
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

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final subTextColor = widget.isDarkMode ? Colors.grey[300] : Colors.black54;
    final result = calculateAnswer();

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(
          "Proportion Calculator",
          style: TextStyle(color: textColor),
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              value: selectedType,
              items: List.generate(proportionTypes.length, (index) {
                return DropdownMenuItem(
                  value: index,
                  child: Text(
                    proportionTypes[index],
                    style: TextStyle(color: textColor),
                  ),
                );
              }),
              dropdownColor:
                  widget.isDarkMode ? Colors.grey[900] : Colors.white,
              onChanged: (index) => setState(() => selectedType = index!),
              decoration: InputDecoration(
                labelText: "Proportion Type",
                labelStyle: TextStyle(color: subTextColor),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            buildInputField("Value a", aController, textColor),
            SizedBox(height: 16),
            buildInputField("Value b", bController, textColor),
            SizedBox(height: 16),
            buildInputField("Value c", cController, textColor),
            SizedBox(height: 16),
            buildInputField("Value d", dController, textColor),
            SizedBox(height: 24),
            if (aController.text.isNotEmpty ||
                bController.text.isNotEmpty ||
                cController.text.isNotEmpty ||
                dController.text.isNotEmpty)
              Container(
                padding: EdgeInsets.all(16),
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
                      "🧮 Result",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 12),
                    if (result != null) ...[
                      SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.all(16),
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
                              "📐 Proportion Calculation",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "🔹 Missing Value: ${result['missing']}",
                              style: TextStyle(fontSize: 16, color: textColor),
                            ),
                            Text(
                              "🔹 Formula: ${result['formula']}",
                              style: TextStyle(fontSize: 16, color: textColor),
                            ),
                            Text(
                              "🔹 Step-by-step: ${result['step']}",
                              style: TextStyle(fontSize: 16, color: textColor),
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
                                  result['value']!,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
