import 'package:flutter/material.dart';

class VolumeConversionScreen extends StatefulWidget {
  final bool isDarkMode;
  const VolumeConversionScreen({super.key, required this.isDarkMode});

  @override
  State<VolumeConversionScreen> createState() => _VolumeConversionScreenState();
}

class _VolumeConversionScreenState extends State<VolumeConversionScreen> {
  final Map<String, double> conversionRatesToLiters = {
    'Liters': 1,
    'Milliliters': 0.001,
    'Gallons': 3.78541,
    'Quarts': 0.946353,
    'Pints': 0.473176,
    'Cups': 0.24,
    'Fluid Ounces': 0.0295735,
    'Cubic Meters': 1000,
  };

  final Map<String, IconData> unitIcons = {
    'Liters': Icons.local_drink,
    'Milliliters': Icons.water_drop,
    'Gallons': Icons.oil_barrel,
    'Quarts': Icons.kitchen,
    'Pints': Icons.emoji_food_beverage,
    'Cups': Icons.coffee,
    'Fluid Ounces': Icons.wine_bar,
    'Cubic Meters': Icons.square_foot,
  };

  String fromUnit = 'Liters';
  double inputValue = 0.0;

  Map<String, double> convertVolume(double value, String from) {
    double valueInLiters = value * conversionRatesToLiters[from]!;
    Map<String, double> result = {};

    conversionRatesToLiters.forEach((unit, factor) {
      result[unit] = valueInLiters / factor;
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final cardColor =
        widget.isDarkMode ? Colors.grey[900] : Colors.grey.shade100;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;

    Map<String, double> results = convertVolume(inputValue, fromUnit);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Volume Converter", style: TextStyle(color: textColor)),
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Enter Volume",
              style: TextStyle(color: textColor, fontSize: 18),
            ),
            const SizedBox(height: 10),
            _buildInputField(textColor),
            const SizedBox(height: 20),
            _buildDropdown(textColor),
            const SizedBox(height: 30),
            Text(
              "Converted Results",
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children:
                    results.entries.map((entry) {
                      return _buildResultCard(
                        entry.key,
                        entry.value,
                        unitIcons[entry.key]!,
                        cardColor!,
                        textColor,
                      );
                    }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(Color textColor) {
    return TextField(
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      style: TextStyle(color: textColor, fontSize: 18),
      decoration: InputDecoration(
        hintText: 'Enter volume',
        filled: true,
        fillColor: widget.isDarkMode ? Colors.grey[850] : Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      onChanged: (val) {
        setState(() {
          inputValue = double.tryParse(val) ?? 0.0;
        });
      },
    );
  }

  Widget _buildDropdown(Color textColor) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Colors.grey[850] : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: fromUnit,
        onChanged: (val) {
          setState(() {
            fromUnit = val!;
          });
        },
        items:
            conversionRatesToLiters.keys.map((unit) {
              return DropdownMenuItem(
                value: unit,
                child: Text(unit, style: TextStyle(color: textColor)),
              );
            }).toList(),
        isExpanded: true,
        underline: SizedBox(),
        icon: Icon(Icons.arrow_drop_down, color: textColor),
      ),
    );
  }

  Widget _buildResultCard(
    String unit,
    double value,
    IconData icon,
    Color cardColor,
    Color textColor,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: widget.isDarkMode ? Colors.black45 : Colors.grey.shade300,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: textColor, size: 28),
          SizedBox(width: 16),
          Text(
            "$unit:",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          Spacer(),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(fontSize: 16, color: textColor),
          ),
        ],
      ),
    );
  }
}
