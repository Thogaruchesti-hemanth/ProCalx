import 'package:flutter/material.dart';

class AccelerationScreen extends StatefulWidget {
  final bool isDarkMode;
  const AccelerationScreen({super.key, required this.isDarkMode});

  @override
  _AccelerationScreenState createState() => _AccelerationScreenState();
}

class _AccelerationScreenState extends State<AccelerationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  double inputValue = 0.0;
  String fromUnit = 'm/s²';
  String toUnit = 'km/h²';

  final List<String> units = ['m/s²', 'km/h²', 'ft/s²', 'mi/h²'];

  final Map<String, double> conversionFactors = {
    'm/s²': 1.0,
    'km/h²': 12960.0,
    'ft/s²': 3.28084,
    'mi/h²': 0.621371,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double convertAcceleration(double value, String from, String to) {
    double valueInBaseUnit = value * conversionFactors[from]!;
    return valueInBaseUnit / conversionFactors[to]!;
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
        actions: [
          Icon(Icons.close, color: textColor),
          SizedBox(width: 8),
          Icon(Icons.more_vert, color: textColor),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: textColor,
          tabs: [Tab(text: 'Calculator'), Tab(text: 'Converter')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [buildCalculatorTab(textColor), buildConverterTab(textColor)],
      ),
    );
  }

  Widget buildCalculatorTab(Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Enter Acceleration to Calculate',
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              setState(() {
                inputValue = double.tryParse(value) ?? 0.0;
              });
            },
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              labelText: 'Enter value',
              labelStyle: TextStyle(color: textColor),
              filled: true,
              fillColor:
                  widget.isDarkMode ? Colors.grey[800] : Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              double result = convertAcceleration(inputValue, 'm/s²', 'km/h²');
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text('Result'),
                      content: Text('Converted Acceleration: $result km/h²'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
              );
            },
            child: Text('Calculate'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  widget.isDarkMode ? Colors.blue[700] : Colors.blue[500],
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildConverterTab(Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Select Units to Convert',
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
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
          SizedBox(height: 20),
          buildInputField(textColor, 'Enter value', inputValue, (value) {
            setState(() {
              inputValue = double.tryParse(value) ?? 0.0;
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
                  'Converted Value:',
                  '${convertAcceleration(inputValue, fromUnit, toUnit).toStringAsFixed(4)} $toUnit',
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
            hintText: 'Enter value',
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
                units.map<DropdownMenuItem<String>>((String value) {
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
