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
    'Cylinder': ['Radius', 'Height'],
    'Sphere': ['Radius'],
    'Cone': ['Radius', 'Height'],
    'Pyramid': ['Base Area', 'Height'],
  };

  final Map<String, List<TextEditingController>> controllers = {};

  String selectedShape = 'Cube';

  @override
  void initState() {
    super.initState();
    shapeInputs.forEach((shape, inputs) {
      controllers[shape] = inputs.map((_) => TextEditingController()).toList();
    });
  }

  @override
  void dispose() {
    controllers.values.forEach((list) => list.forEach((c) => c.dispose()));
    super.dispose();
  }

  double? parse(String text) => double.tryParse(text);

  Map<String, dynamic> calculateVolumeAndSurface(String shape) {
    final values = controllers[shape]!.map((c) => parse(c.text)).toList();

    switch (shape) {
      case 'Cube':
        final s = values[0];
        if (s == null) return {};
        return {
          'volume': pow(s, 3),
          'surface': 6 * pow(s, 2),
          'formula': 'Volume = s³, Surface = 6 × s²',
        };
      case 'Cuboid':
        final l = values[0], w = values[1], h = values[2];
        if (l == null || w == null || h == null) return {};
        return {
          'volume': l * w * h,
          'surface': 2 * (l * w + l * h + w * h),
          'formula': 'Volume = l × w × h, Surface = 2(lw + lh + wh)',
        };
      case 'Cylinder':
        final r = values[0], h = values[1];
        if (r == null || h == null) return {};
        return {
          'volume': pi * pow(r, 2) * h,
          'surface': 2 * pi * r * (r + h),
          'formula': 'Volume = πr²h, Surface = 2πr(r + h)',
        };
      case 'Sphere':
        final r = values[0];
        if (r == null) return {};
        return {
          'volume': (4 / 3) * pi * pow(r, 3),
          'surface': 4 * pi * pow(r, 2),
          'formula': 'Volume = ⁴⁄₃πr³, Surface = 4πr²',
        };
      case 'Cone':
        final r = values[0], h = values[1];
        if (r == null || h == null) return {};
        final l = sqrt(pow(r, 2) + pow(h, 2));
        return {
          'volume': (1 / 3) * pi * pow(r, 2) * h,
          'surface': pi * r * (r + l),
          'formula': 'Volume = ⅓πr²h, Surface = πr(r + l)',
        };
      case 'Pyramid':
        final b = values[0], h = values[1];
        if (b == null || h == null) return {};
        return {
          'volume': (1 / 3) * b * h,
          'surface': null,
          'formula': 'Volume = ⅓ × base × height',
        };
      default:
        return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final subTextColor = widget.isDarkMode ? Colors.grey[300] : Colors.black54;

    final currentInputs = shapeInputs[selectedShape]!;
    final currentControllers = controllers[selectedShape]!;

    final result =
        currentControllers.every((c) => c.text.isNotEmpty)
            ? calculateVolumeAndSurface(selectedShape)
            : {};

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Volume Calculator',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedShape,
              items:
                  shapeInputs.keys.map((shape) {
                    return DropdownMenuItem(
                      value: shape,
                      child: Text(shape, style: TextStyle(color: textColor)),
                    );
                  }).toList(),
              dropdownColor:
                  widget.isDarkMode ? Colors.grey[900] : Colors.white,
              onChanged: (shape) => setState(() => selectedShape = shape!),
              decoration: InputDecoration(
                labelText: "Shape",
                labelStyle: TextStyle(color: subTextColor),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ...List.generate(currentInputs.length, (i) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currentInputs[i],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color:
                          widget.isDarkMode
                              ? Colors.grey[900]
                              : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextField(
                      controller: currentControllers[i],
                      onChanged: (_) => setState(() {}),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter value',
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
              );
            }),
            if (result.isNotEmpty) ...[
              SizedBox(height: 12),
              Text(
                "Result",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      widget.isDarkMode
                          ? Colors.grey[900]
                          : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "📦 Shape: $selectedShape",
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "🔢 Inputs: ${currentControllers.map((c) => c.text).join(", ")}",
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "📘 Formula: ${result['formula']}",
                      style: TextStyle(fontSize: 16, color: subTextColor),
                    ),
                    Divider(height: 24, color: Colors.grey),
                    if (result['volume'] != null)
                      Text(
                        "✅ Volume: ${result['volume'].toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    if (result['surface'] != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "📐 Surface Area: ${result['surface'].toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
