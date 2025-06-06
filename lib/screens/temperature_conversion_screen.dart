import 'package:flutter/material.dart';

class TemperatureConversionScreen extends StatefulWidget {
  final bool isDarkMode;
  const TemperatureConversionScreen({super.key, required this.isDarkMode});

  @override
  _TemperatureConversionScreenState createState() =>
      _TemperatureConversionScreenState();
}

class _TemperatureConversionScreenState
    extends State<TemperatureConversionScreen> {
  double inputValue = 0.0;
  String fromUnit = 'Celsius';
  String toUnit = 'Fahrenheit';

  final List<String> units = ['Celsius', 'Fahrenheit', 'Kelvin'];

  final Map<String, String> unitIcons = {
    'Celsius': '🌡️',
    'Fahrenheit': '🔥',
    'Kelvin': '❄️',
  };

  double convertTemperature(double value, String from, String to) {
    if (from == to) return value;

    // Convert from any to Celsius
    double celsius;
    switch (from) {
      case 'Fahrenheit':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'Kelvin':
        celsius = value - 273.15;
        break;
      default:
        celsius = value;
    }

    // Convert from Celsius to target unit
    switch (to) {
      case 'Fahrenheit':
        return (celsius * 9 / 5) + 32;
      case 'Kelvin':
        return celsius + 273.15;
      default:
        return celsius;
    }
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
          'Temperature Conversion',
          style: TextStyle(color: textColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInputField('Enter value', inputValue, (value) {
              setState(() {
                inputValue = double.tryParse(value) ?? 0.0;
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
                    '${convertTemperature(inputValue, fromUnit, toUnit).toStringAsFixed(2)} $toUnit',
                    textColor,
                  ),
                  SizedBox(height: 10),
                  buildResultRow('From:', '$inputValue $fromUnit', textColor),
                  SizedBox(height: 10),
                  buildResultRow('To:', toUnit, textColor),
                  SizedBox(height: 10),
                  buildResultRow(
                    'Conversion Formula',
                    formulaText(fromUnit, toUnit),
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

  String formulaText(String from, String to) {
    if (from == to) return 'No conversion needed.';
    if (from == 'Celsius' && to == 'Fahrenheit') {
      return '°F = (°C × 9/5) + 32';
    } else if (from == 'Fahrenheit' && to == 'Celsius') {
      return '°C = (°F - 32) × 5/9';
    } else if (from == 'Celsius' && to == 'Kelvin') {
      return 'K = °C + 273.15';
    } else if (from == 'Kelvin' && to == 'Celsius') {
      return '°C = K - 273.15';
    } else if (from == 'Fahrenheit' && to == 'Kelvin') {
      return 'K = ((°F - 32) × 5/9) + 273.15';
    } else if (from == 'Kelvin' && to == 'Fahrenheit') {
      return '°F = ((K - 273.15) × 9/5) + 32';
    }
    return '';
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
                units.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Text(
                          unitIcons[value] ?? '',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 8),
                        Text(value, style: TextStyle(color: textColor)),
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
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          flex: 3,
          child: Text(result, style: TextStyle(color: textColor)),
        ),
      ],
    );
  }
}
