import 'package:flutter/material.dart';

class DataStorageConversionScreen extends StatefulWidget {
  final bool isDarkMode;
  const DataStorageConversionScreen({super.key, required this.isDarkMode});

  @override
  State<DataStorageConversionScreen> createState() =>
      _DataConversionScreenState();
}

class _DataConversionScreenState extends State<DataStorageConversionScreen> {
  double inputValue = 0.0;
  String fromUnit = 'bit';
  String toUnit = 'byte';

  final TextEditingController inputController = TextEditingController();

  final Map<String, String> unitNames = {
    'bit': 'Bit',
    'kbit': 'Kilobit',
    'kibit': 'Kibibit',
    'mbit': 'Megabit',
    'mebit': 'Mebibit',
    'gbit': 'Gigabit',
    'gibit': 'Gibibit',
    'tbit': 'Terabit',
    'tebit': 'Tebibit',
    'pbit': 'Petabit',
    'pebit': 'Pebibit',
    'byte': 'Byte',
    'kB': 'Kilobyte',
    'kiB': 'Kibibyte',
    'MB': 'Megabyte',
    'MiB': 'Mebibyte',
    'GB': 'Gigabyte',
    'GiB': 'Gibibyte',
    'TB': 'Terabyte',
    'TiB': 'Tebibyte',
    'PB': 'Petabyte',
    'PiB': 'Pebibyte',
  };

  final List<String> units = [
    'bit',
    'kbit',
    'kibit',
    'mbit',
    'mebit',
    'gbit',
    'gibit',
    'tbit',
    'tebit',
    'pbit',
    'pebit',
    'byte',
    'kB',
    'kiB',
    'MB',
    'MiB',
    'GB',
    'GiB',
    'TB',
    'TiB',
    'PB',
    'PiB',
  ];

  final Map<String, double> unitToBits = {
    'bit': 1,
    'kbit': 1e3,
    'kibit': 1024,
    'mbit': 1e6,
    'mebit': 1048576,
    'gbit': 1e9,
    'gibit': 1073741824,
    'tbit': 1e12,
    'tebit': 1099511627776,
    'pbit': 1e15,
    'pebit': 1125899906842624,
    'byte': 8,
    'kB': 8000,
    'kiB': 8192,
    'MB': 8e6,
    'MiB': 8388608,
    'GB': 8e9,
    'GiB': 8589934592,
    'TB': 8e12,
    'TiB': 8796093022208,
    'PB': 8e15,
    'PiB': 9007199254740992,
  };

  double convertData(double value, String from, String to) {
    double bits = value * unitToBits[from]!;
    return bits / unitToBits[to]!;
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
        title: Text("Data Conversion", style: TextStyle(color: textColor)),
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
                    '${convertData(inputValue, fromUnit, toUnit).toStringAsFixed(4)} ${unitNames[toUnit]}',
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
                    '1 ${unitNames[fromUnit]} = ${convertData(1, fromUnit, toUnit).toStringAsFixed(4)} ${unitNames[toUnit]}',
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
                    child: Text(
                      unitNames[value]!,
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
