import 'package:flutter/material.dart';

class AccelerationScreen extends StatefulWidget {
  final bool isDarkMode;
  const AccelerationScreen({super.key, required this.isDarkMode});

  @override
  _AccelerationScreenState createState() => _AccelerationScreenState();
}

class _AccelerationScreenState extends State<AccelerationScreen> {
  double inputValue = 0.0;
  String fromUnit = 'm/s²';
  String toUnit = 'km/h²';

  final List<String> units = ['m/s²', 'km/h²', 'ft/s²', 'mi/h²', 'g'];

  final Map<String, double> conversionFactors = {
    'm/s²': 1.0,
    'km/h²': 1 / 12960.0,
    'ft/s²': 1 / 3.28084,
    'mi/h²': 1 / 1609.344,
    'g': 1 / 9.80665,
  };

  double convertAcceleration(double value, String from, String to) {
    double valueInMS2 = value * (1 / conversionFactors[from]!);
    return valueInMS2 * conversionFactors[to]!;
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
        title: Text(
          'Acceleration Converter',
          style: TextStyle(color: textColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildInputField(textColor, 'Enter Acceleration', inputValue, (
              value,
            ) {
              setState(() {
                inputValue = double.tryParse(value) ?? 0.0;
              });
            }),
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
            SizedBox(height: 30),
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
                    'Converted Value:',
                    '${convertAcceleration(inputValue, fromUnit, toUnit).toStringAsFixed(5)} $toUnit',
                    textColor,
                  ),
                  SizedBox(height: 10),
                  buildResultRow('From:', '$inputValue $fromUnit', textColor),
                  SizedBox(height: 10),
                  buildResultRow('To:', '$toUnit', textColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(
    Color textColor,
    String label,
    double value,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          onChanged: onChanged,
          style: TextStyle(color: textColor, fontSize: 18),
          decoration: InputDecoration(
            hintText: 'e.g. 9.8',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: widget.isDarkMode ? Colors.grey[800] : Colors.grey[200],
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
                units.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: textColor)),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildResultRow(String label, String result, Color textColor) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        Text(result, style: TextStyle(color: textColor)),
      ],
    );
  }
}
