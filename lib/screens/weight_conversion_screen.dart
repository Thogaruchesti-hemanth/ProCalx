import 'package:flutter/material.dart';

class WeightConversionScreen extends StatefulWidget {
  final bool isDarkMode;
  const WeightConversionScreen({super.key, required this.isDarkMode});

  @override
  _WeightConversionScreenState createState() => _WeightConversionScreenState();
}

class _WeightConversionScreenState extends State<WeightConversionScreen> {
  double inputValue = 0.0;
  String fromUnit = 'kg';
  String toUnit = 'g';

  final Map<String, String> unitNames = {
    'kg': 'Kilograms',
    'g': 'Grams',
    'mg': 'Milligrams',
    'lb': 'Pounds',
    'oz': 'Ounces',
    'ton': 'Metric Tons',
  };

  final List<String> units = ['kg', 'g', 'mg', 'lb', 'oz', 'ton'];

  // Changed from IconData to emoji strings for icons
  final Map<String, String> unitIcons = {
    'kg': '⚖️',
    'g': '🧂',
    'mg': '🔬',
    'lb': '🏋️',
    'oz': '🥄',
    'ton': '🚛',
  };

  double convertWeight(double value, String from, String to) {
    Map<String, double> toKilograms = {
      'kg': 1,
      'g': 0.001,
      'mg': 0.000001,
      'lb': 0.453592,
      'oz': 0.0283495,
      'ton': 1000,
    };

    double inKg = value * toKilograms[from]!;
    Map<String, double> fromKg = {
      'kg': 1,
      'g': 1000,
      'mg': 1e6,
      'lb': 2.20462,
      'oz': 35.274,
      'ton': 0.001,
    };

    return inKg * fromKg[to]!;
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text('Weight Conversion', style: TextStyle(color: textColor)),
        // Removed actions as per your earlier request
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInputField('Enter value', inputValue, (value) {
              setState(() {
                inputValue = double.tryParse(value) ?? 0;
              });
            }, textColor),
            SizedBox(height: 20),
            buildUnitPicker(textColor, 'From', fromUnit, (newValue) {
              setState(() {
                fromUnit = newValue!;
              });
            }),
            SizedBox(height: 20),
            buildUnitPicker(textColor, 'To', toUnit, (newValue) {
              setState(() {
                toUnit = newValue!;
              });
            }),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color:
                    widget.isDarkMode ? Colors.grey[900] : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildResultRow(
                    'Converted Value',
                    '${convertWeight(inputValue, fromUnit, toUnit).toStringAsFixed(4)} ${unitNames[toUnit]}',
                    textColor,
                  ),
                  SizedBox(height: 10),
                  buildResultRow(
                    'From:',
                    '$inputValue ${unitNames[fromUnit]}',
                    textColor,
                  ),
                  SizedBox(height: 10),
                  buildResultRow('To:', unitNames[toUnit]!, textColor),
                  SizedBox(height: 10),
                  buildResultRow(
                    'Conversion Formula',
                    '1 ${unitNames[fromUnit]} = ${convertWeight(1, fromUnit, toUnit).toStringAsFixed(4)} ${unitNames[toUnit]}',
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
    double value,
    Function(String) onChanged,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: widget.isDarkMode ? Colors.grey[900] : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: onChanged,
            style: TextStyle(color: textColor, fontSize: 18),
            decoration: InputDecoration(
              hintText: 'Enter value',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildUnitPicker(
    Color textColor,
    String label,
    String currentValue,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label Unit',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.isDarkMode ? Colors.grey[900] : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: currentValue,
            onChanged: onChanged,
            icon: Icon(Icons.arrow_drop_down, color: textColor),
            isExpanded: true,
            underline: SizedBox(),
            dropdownColor: widget.isDarkMode ? Colors.grey[850] : Colors.white,
            items:
                units.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Text(
                          unitIcons[value] ?? '',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 8),
                        Text(
                          unitNames[value]!,
                          style: TextStyle(color: textColor),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildResultRow(String label, String result, Color textColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Text(
            result,
            style: TextStyle(color: textColor),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
