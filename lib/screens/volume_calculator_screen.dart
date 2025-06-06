import 'dart:math';

import 'package:flutter/material.dart';

class VolumeCalculatorScreen extends StatefulWidget {
  final bool isDarkMode;
  const VolumeCalculatorScreen({super.key, required this.isDarkMode});

  @override
  State<VolumeCalculatorScreen> createState() => _VolumeCalculatorScreenState();
}

class _VolumeCalculatorScreenState extends State<VolumeCalculatorScreen> {
  final Map<String, List<String>> shapeInputs = {
    'Cube': ['Side'],
    'Cuboid': ['Length', 'Width', 'Height'],
    'Sphere': ['Radius'],
    'Cylinder': ['Radius', 'Height'],
    'Cone': ['Radius', 'Height'],
    'Square Pyramid': ['Base Length', 'Height'],
    'Hemisphere': ['Radius'],
  };

  String selectedShape = 'Cube';
  final Map<String, TextEditingController> controllers = {};

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    shapeInputs.values.expand((i) => i).toSet().forEach((field) {
      controllers[field] = TextEditingController();
    });
  }

  List<String> get currentFields => shapeInputs[selectedShape]!;

  double? parse(String label) =>
      double.tryParse(controllers[label]?.text ?? '');

  String getFormula() {
    switch (selectedShape) {
      case 'Cube':
        return "side³";
      case 'Cuboid':
        return "length × width × height";
      case 'Sphere':
        return "(4/3) × π × radius³";
      case 'Cylinder':
        return "π × radius² × height";
      case 'Cone':
        return "(1/3) × π × radius² × height";
      case 'Square Pyramid':
        return "(1/3) × base² × height";
      case 'Hemisphere':
        return "(2/3) × π × radius³";
      default:
        return "";
    }
  }

  double calculateVolume() {
    final r = parse('Radius') ?? 0;
    final h = parse('Height') ?? 0;
    final s = parse('Side') ?? 0;
    final l = parse('Length') ?? 0;
    final w = parse('Width') ?? 0;
    final b = parse('Base Length') ?? 0;

    switch (selectedShape) {
      case 'Cube':
        return pow(s, 3).toDouble();
      case 'Cuboid':
        return l * w * h;
      case 'Sphere':
        return (4 / 3) * pi * pow(r, 3);
      case 'Cylinder':
        return pi * pow(r, 2) * h;
      case 'Cone':
        return (1 / 3) * pi * pow(r, 2) * h;
      case 'Square Pyramid':
        return (1 / 3) * pow(b, 2) * h;
      case 'Hemisphere':
        return (2 / 3) * pi * pow(r, 3);
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = widget.isDarkMode ? Colors.black : Colors.white;
    final text = widget.isDarkMode ? Colors.white : Colors.black;
    final subText = widget.isDarkMode ? Colors.grey[300] : Colors.black54;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text("Volume Calculator", style: TextStyle(color: text)),
        iconTheme: IconThemeData(color: text),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: selectedShape,
              dropdownColor:
                  widget.isDarkMode ? Colors.grey[900] : Colors.white,
              items:
                  shapeInputs.keys.map((shape) {
                    return DropdownMenuItem(
                      value: shape,
                      child: Text(shape, style: TextStyle(color: text)),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedShape = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Select Shape",
                labelStyle: TextStyle(color: subText),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ...currentFields
                .map((label) => buildInputField(label, text))
                .toList(),
            SizedBox(height: 32),
            if (currentFields.every(
              (f) => controllers[f]?.text.isNotEmpty ?? false,
            ))
              resultCard(text, subText),
          ],
        ),
      ),
    );
  }

  Widget buildInputField(String label, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: widget.isDarkMode ? Colors.grey[900] : Colors.grey[100],
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: controllers[label],
              onChanged: (_) => setState(() {}),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter $label",
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
      ),
    );
  }

  Widget resultCard(Color textColor, Color? subTextColor) {
    final volume = calculateVolume();
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Colors.grey[900] : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "📦 Volume Summary",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "🔹 Shape: $selectedShape",
            style: TextStyle(fontSize: 16, color: textColor),
          ),
          Text(
            "🔹 Formula: ${getFormula()}",
            style: TextStyle(fontSize: 16, color: subTextColor),
          ),
          Text(
            "🔹 Inputs: ${currentFields.map((f) => "$f = ${controllers[f]?.text}").join(', ')}",
            style: TextStyle(fontSize: 16, color: subTextColor),
          ),
          Divider(height: 24, color: Colors.grey),
          Row(
            children: [
              Text(
                "✅ Volume: ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                volume.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
