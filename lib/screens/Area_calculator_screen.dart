import 'dart:math';

import 'package:flutter/material.dart';

class AreaCalculatorScreen extends StatefulWidget {
  final bool isDarkMode;
  const AreaCalculatorScreen({super.key, required this.isDarkMode});

  @override
  State<AreaCalculatorScreen> createState() => _AreaCalculatorScreenState();
}

class _AreaCalculatorScreenState extends State<AreaCalculatorScreen> {
  int selectedShapeIndex = 0;

  final List<String> shapes = [
    "Square",
    "Rectangle",
    "Circle",
    "Triangle",
    "Parallelogram",
    "Trapezium",
  ];

  final Map<String, List<String>> shapeInputs = {
    "Square": ["Side"],
    "Rectangle": ["Length", "Width"],
    "Circle": ["Radius"],
    "Triangle": ["Side A", "Side B", "Side C"],
    "Parallelogram": ["Base", "Side", "Height"],
    "Trapezium": ["Base 1", "Base 2", "Side 1", "Side 2", "Height"],
  };

  final Map<String, List<TextEditingController>> controllersMap = {};

  @override
  void initState() {
    super.initState();
    for (var shape in shapes) {
      controllersMap[shape] = List.generate(
        shapeInputs[shape]!.length,
        (_) => TextEditingController(),
      );
    }
  }

  String getFormula(String shape) {
    switch (shape) {
      case "Square":
        return "Area = side × side";
      case "Rectangle":
        return "Area = length × width";
      case "Circle":
        return "Area = π × radius²";
      case "Triangle":
        return "Area using Heron’s Formula";
      case "Parallelogram":
        return "Area = base × height";
      case "Trapezium":
        return "Area = ½ × (base1 + base2) × height";
      default:
        return "";
    }
  }

  String getPerimeterFormula(String shape) {
    switch (shape) {
      case "Square":
        return "Perimeter = 4 × side";
      case "Rectangle":
        return "Perimeter = 2 × (length + width)";
      case "Circle":
        return "Perimeter = 2 × π × radius";
      case "Triangle":
        return "Perimeter = a + b + c";
      case "Parallelogram":
        return "Perimeter = 2 × (base + side)";
      case "Trapezium":
        return "Perimeter = base1 + base2 + side1 + side2";
      default:
        return "";
    }
  }

  double calculateArea(String shape) {
    final inputs = controllersMap[shape]!;
    try {
      switch (shape) {
        case "Square":
          double side = double.parse(inputs[0].text);
          return side * side;
        case "Rectangle":
          double l = double.parse(inputs[0].text);
          double w = double.parse(inputs[1].text);
          return l * w;
        case "Circle":
          double r = double.parse(inputs[0].text);
          return pi * r * r;
        case "Triangle":
          double a = double.parse(inputs[0].text);
          double b = double.parse(inputs[1].text);
          double c = double.parse(inputs[2].text);
          double s = (a + b + c) / 2;
          return sqrt(s * (s - a) * (s - b) * (s - c));
        case "Parallelogram":
          double b = double.parse(inputs[0].text);
          double h = double.parse(inputs[2].text);
          return b * h;
        case "Trapezium":
          double b1 = double.parse(inputs[0].text);
          double b2 = double.parse(inputs[1].text);
          double h = double.parse(inputs[4].text);
          return 0.5 * (b1 + b2) * h;
        default:
          return 0;
      }
    } catch (_) {
      return 0;
    }
  }

  double calculatePerimeter(String shape) {
    final inputs = controllersMap[shape]!;
    try {
      switch (shape) {
        case "Square":
          double s = double.parse(inputs[0].text);
          return 4 * s;
        case "Rectangle":
          double l = double.parse(inputs[0].text);
          double w = double.parse(inputs[1].text);
          return 2 * (l + w);
        case "Circle":
          double r = double.parse(inputs[0].text);
          return 2 * pi * r;
        case "Triangle":
          double a = double.parse(inputs[0].text);
          double b = double.parse(inputs[1].text);
          double c = double.parse(inputs[2].text);
          return a + b + c;
        case "Parallelogram":
          double b = double.parse(inputs[0].text);
          double s = double.parse(inputs[1].text);
          return 2 * (b + s);
        case "Trapezium":
          double b1 = double.parse(inputs[0].text);
          double b2 = double.parse(inputs[1].text);
          double s1 = double.parse(inputs[2].text);
          double s2 = double.parse(inputs[3].text);
          return b1 + b2 + s1 + s2;
        default:
          return 0;
      }
    } catch (_) {
      return 0;
    }
  }

  bool hasValidInput(String shape) {
    return controllersMap[shape]!.every(
      (c) => c.text.trim().isNotEmpty && double.tryParse(c.text.trim()) != null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final shape = shapes[selectedShapeIndex];
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final subTextColor = widget.isDarkMode ? Colors.grey[300] : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text("Area Calculator", style: TextStyle(color: textColor)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              value: selectedShapeIndex,
              dropdownColor:
                  widget.isDarkMode ? Colors.grey[900] : Colors.white,
              decoration: InputDecoration(
                labelText: "Select Shape",
                labelStyle: TextStyle(color: subTextColor),
                border: OutlineInputBorder(),
              ),
              items: List.generate(shapes.length, (index) {
                return DropdownMenuItem(
                  value: index,
                  child: Text(
                    shapes[index],
                    style: TextStyle(color: textColor),
                  ),
                );
              }),
              onChanged: (index) {
                setState(() => selectedShapeIndex = index!);
              },
            ),
            SizedBox(height: 24),

            ...List.generate(shapeInputs[shape]!.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: buildInputField(
                  shapeInputs[shape]![i],
                  controllersMap[shape]![i],
                  textColor,
                ),
              );
            }),

            if (hasValidInput(shape))
              Container(
                margin: EdgeInsets.only(top: 30),
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
                      "📐 Shape: $shape",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "🔢 Inputs:",
                      style: TextStyle(
                        fontSize: 16,
                        color: subTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...List.generate(shapeInputs[shape]!.length, (i) {
                      return Text(
                        " - ${shapeInputs[shape]![i]}: ${controllersMap[shape]![i].text}",
                        style: TextStyle(fontSize: 16, color: textColor),
                      );
                    }),
                    SizedBox(height: 8),
                    Text(
                      "📘 Area Formula: ${getFormula(shape)}",
                      style: TextStyle(fontSize: 16, color: subTextColor),
                    ),
                    Text(
                      "📗 Perimeter Formula: ${getPerimeterFormula(shape)}",
                      style: TextStyle(fontSize: 16, color: subTextColor),
                    ),
                    Divider(height: 24),
                    Row(
                      children: [
                        Text(
                          "✅ Area: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          "${calculateArea(shape).toStringAsFixed(2)} sq. units",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "📏 Perimeter: ",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          "${calculatePerimeter(shape).toStringAsFixed(2)} units",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
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
    TextEditingController controller,
    Color textColor,
  ) {
    return Column(
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
            color: widget.isDarkMode ? Colors.grey[900] : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: controller,
            onChanged: (_) => setState(() {}),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
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
  }
}
