import 'package:flutter/material.dart';

class AreaConversionScreen extends StatefulWidget {
  final bool isDarkMode;
  const AreaConversionScreen({super.key, required this.isDarkMode});

  @override
  _AreaConversionScreenState createState() => _AreaConversionScreenState();
}

class _AreaConversionScreenState extends State<AreaConversionScreen> {
  double inputValue = 0.0;
  String fromUnit = 'm²';
  String toUnit = 'km²';
  final TextEditingController inputController = TextEditingController();

  final Map<String, String> unitNames = {
    'nm²': 'Square Nanometer',
    'μm²': 'Square Micrometer',
    'mm²': 'Square Millimeter',
    'cm²': 'Square Centimeter',
    'dm²': 'Square Decimeter',
    'm²': 'Square Meter',
    'dam²': 'Square Dekameter',
    'hm²': 'Square Hectometer',
    'km²': 'Square Kilometer',
    'in²': 'Square Inch',
    'yd²': 'Square Yard',
    'mi²': 'Square Mile',
    'a': 'Are',
    'ac': 'Acre',
  };

  final List<String> units = [
    'nm²',
    'μm²',
    'mm²',
    'cm²',
    'dm²',
    'm²',
    'dam²',
    'hm²',
    'km²',
    'in²',
    'yd²',
    'mi²',
    'a',
    'ac',
  ];

  final Map<String, double> toSquareMeters = {
    'nm²': 1e-18,
    'μm²': 1e-12,
    'mm²': 1e-6,
    'cm²': 1e-4,
    'dm²': 0.01,
    'm²': 1.0,
    'dam²': 100.0,
    'hm²': 10000.0,
    'km²': 1e6,
    'in²': 0.00064516,
    'yd²': 0.836127,
    'mi²': 2.59e6,
    'a': 100.0,
    'ac': 4046.86,
  };

  double convertArea(double value, String from, String to) {
    double valueInSquareMeters = value * toSquareMeters[from]!;
    return valueInSquareMeters / toSquareMeters[to]!;
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
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
        title: Text("Area Conversion", style: TextStyle(color: textColor)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInputField('Enter value', inputValue, (value) {
              setState(() {
                inputValue = double.tryParse(value) ?? 0.0;
              });
            }, textColor),
            const SizedBox(height: 20),
            buildUnitPicker(textColor, 'From', fromUnit, (newValue) {
              setState(() {
                fromUnit = newValue!;
              });
            }),
            const SizedBox(height: 20),
            buildUnitPicker(textColor, 'To', toUnit, (newValue) {
              setState(() {
                toUnit = newValue!;
              });
            }),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: widget.isDarkMode ? Colors.grey[900] : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildResultRow(
                    'Converted Value',
                    '${convertArea(inputValue, fromUnit, toUnit).toStringAsFixed(6)} ${unitNames[toUnit]}',
                    textColor,
                  ),
                  const SizedBox(height: 10),
                  buildResultRow(
                    'From:',
                    '$inputValue ${unitNames[fromUnit]}',
                    textColor,
                  ),
                  const SizedBox(height: 10),
                  buildResultRow('To:', unitNames[toUnit]!, textColor),
                  const SizedBox(height: 10),
                  buildResultRow(
                    'Conversion Formula',
                    '1 ${unitNames[fromUnit]} = ${convertArea(1, fromUnit, toUnit).toStringAsFixed(6)} ${unitNames[toUnit]}',
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
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: widget.isDarkMode ? Colors.grey[900] : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: inputController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: onChanged,
            style: TextStyle(color: textColor, fontSize: 18),
            decoration: InputDecoration(
              hintText: 'e.g. 1000',
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
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
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.isDarkMode ? Colors.grey[900] : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: currentValue,
            onChanged: onChanged,
            icon: Icon(Icons.arrow_drop_down, color: textColor),
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: widget.isDarkMode ? Colors.grey[850] : Colors.white,
            items:
                units.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      '${unitNames[value]}',
                      style: TextStyle(color: textColor),
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
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Text(result, style: TextStyle(color: textColor)),
        ),
      ],
    );
  }
}
