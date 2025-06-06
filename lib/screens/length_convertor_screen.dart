import 'package:flutter/material.dart';

class LengthConversionScreen extends StatefulWidget {
  final bool isDarkMode;
  const LengthConversionScreen({super.key, required this.isDarkMode});

  @override
  _LengthConversionScreenState createState() => _LengthConversionScreenState();
}

class _LengthConversionScreenState extends State<LengthConversionScreen> {
  double inputValue = 0.0;
  String fromUnit = 'm'; // Default is Meters
  String toUnit = 'km'; // Default is Kilometers

  final TextEditingController inputController = TextEditingController();

  final Map<String, String> unitNames = {
    'km': 'Kilometers',
    'm': 'Meters',
    'cm': 'Centimeters',
    'mm': 'Millimeters',
    'mi': 'Miles',
    'yd': 'Yards',
    'ft': 'Feet',
    'in': 'Inches',
  };

  final List<String> units = ['km', 'm', 'cm', 'mm', 'mi', 'yd', 'ft', 'in'];

  final Map<String, String> unitIcons = {
    'km': '🛣️',
    'm': '📏',
    'cm': '📐',
    'mm': '✂️',
    'mi': '🛤️',
    'yd': '🏃‍♂️',
    'ft': '👣',
    'in': '📌',
  };

  double convertLength(double value, String from, String to) {
    Map<String, double> toMeters = {
      'km': 1000,
      'm': 1,
      'cm': 0.01,
      'mm': 0.001,
      'mi': 1609.34,
      'yd': 0.9144,
      'ft': 0.3048,
      'in': 0.0254,
    };

    double valueInMeters = value * toMeters[from]!;
    Map<String, double> toOtherUnits = {
      'km': 0.001,
      'm': 1,
      'cm': 100,
      'mm': 1000,
      'mi': 0.000621371,
      'yd': 1.09361,
      'ft': 3.28084,
      'in': 39.3701,
    };

    return valueInMeters * toOtherUnits[to]!;
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
        title: Text("Length Conversion", style: TextStyle(color: textColor)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                    '${convertLength(inputValue, fromUnit, toUnit).toStringAsFixed(4)} ${unitNames[toUnit]}',
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
                    '1 ${unitNames[fromUnit]} = ${convertLength(1, fromUnit, toUnit).toStringAsFixed(4)} ${unitNames[toUnit]}',
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
            controller: inputController,
            autofocus: true,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: onChanged,
            style: TextStyle(color: textColor, fontSize: 18),
            decoration: InputDecoration(
              hintText: 'Enter value',
              hintStyle: TextStyle(color: Colors.grey),
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
