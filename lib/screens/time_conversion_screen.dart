import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeConversionScreen extends StatefulWidget {
  final bool isDarkMode;
  const TimeConversionScreen({super.key, required this.isDarkMode});

  @override
  State<TimeConversionScreen> createState() => _TimeConversionScreenState();
}

class _TimeConversionScreenState extends State<TimeConversionScreen> {
  double inputValue = 0.0;
  String fromUnit = 'day';
  String toUnit = 'millisecond';

  final TextEditingController inputController = TextEditingController();

  final List<String> timeUnits = [
    'nanosecond',
    'microsecond',
    'millisecond',
    'second',
    'minute',
    'hour',
    'day',
    'week',
    'month',
    'year',
    'decade',
    'century',
    'millennium',
  ];

  final Map<String, String> unitNames = {
    'nanosecond': 'Nanosecond',
    'microsecond': 'Microsecond',
    'millisecond': 'Millisecond',
    'second': 'Second',
    'minute': 'Minute',
    'hour': 'Hour',
    'day': 'Day',
    'week': 'Week',
    'month': 'Month',
    'year': 'Year',
    'decade': 'Decade',
    'century': 'Century',
    'millennium': 'Millennium',
  };

  final formatter = NumberFormat('#,###.##');

  double convertTime(double value, String from, String to) {
    // All units converted to seconds first
    final toSeconds = {
      'nanosecond': 1e-9,
      'microsecond': 1e-6,
      'millisecond': 0.001,
      'second': 1,
      'minute': 60,
      'hour': 3600,
      'day': 86400,
      'week': 604800,
      'month': 2.628e+6, // average month (30.44 days)
      'year': 3.154e+7, // average year (365.25 days)
      'decade': 3.154e+8,
      'century': 3.154e+9,
      'millennium': 3.154e+10,
    };

    double inSeconds = value * toSeconds[from]!;
    return inSeconds / toSeconds[to]!;
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

    double convertedValue = convertTime(inputValue, fromUnit, toUnit);
    String resultString =
        '${inputValue.toStringAsFixed(2)} ${unitNames[fromUnit]} = ${formatter.format(convertedValue)} ${unitNames[toUnit]}';

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text("Time Conversion", style: TextStyle(color: textColor)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildInputField(textColor),
            SizedBox(height: 20),
            buildUnitPicker('From', fromUnit, (value) {
              setState(() => fromUnit = value!);
            }, textColor),
            SizedBox(height: 20),
            buildUnitPicker('To', toUnit, (value) {
              setState(() => toUnit = value!);
            }, textColor),
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
                  buildResultRow('Result', resultString, textColor),
                  SizedBox(height: 10),
                  buildResultRow(
                    'From:',
                    '${inputValue.toStringAsFixed(2)} ${unitNames[fromUnit]}',
                    textColor,
                  ),
                  buildResultRow(
                    'Conversion Rate:',
                    '1 ${unitNames[fromUnit]} = ${formatter.format(convertTime(1, fromUnit, toUnit))} ${unitNames[toUnit]}',
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

  Widget buildInputField(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Enter Time Value",
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
            onChanged: (value) {
              setState(() {
                inputValue = double.tryParse(value) ?? 0.0;
              });
            },
            style: TextStyle(color: textColor, fontSize: 18),
            decoration: InputDecoration(
              hintText: 'e.g. 1.5',
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
    String label,
    String selectedValue,
    ValueChanged<String?> onChanged,
    Color textColor,
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
            value: selectedValue,
            onChanged: onChanged,
            icon: Icon(Icons.arrow_drop_down, color: textColor),
            isExpanded: true,
            underline: SizedBox(),
            dropdownColor: widget.isDarkMode ? Colors.grey[850] : Colors.white,
            items:
                timeUnits.map((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(
                      unitNames[unit]!,
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label ",
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
          Expanded(child: Text(result, style: TextStyle(color: textColor))),
        ],
      ),
    );
  }
}
