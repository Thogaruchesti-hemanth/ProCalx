import 'package:flutter/material.dart';

class AverageScreen extends StatefulWidget {
  final bool isDarkMode;
  const AverageScreen({super.key, required this.isDarkMode});

  @override
  State<AverageScreen> createState() => _AverageScreenState();
}

class _AverageScreenState extends State<AverageScreen> {
  int selectedMode = 0;

  final TextEditingController numbersController = TextEditingController();
  final TextEditingController valuesController =
      TextEditingController(); // For weighted
  final TextEditingController weightsController =
      TextEditingController(); // For weighted

  final TextEditingController totalDistanceController =
      TextEditingController(); // For speed
  final TextEditingController totalTimeController =
      TextEditingController(); // For speed

  String get resultText {
    switch (selectedMode) {
      case 0: // Basic average
        final nums = parseNumbers(numbersController.text);
        if (nums.isEmpty) return '⚠️ Please enter valid numbers.';
        final sum = nums.reduce((a, b) => a + b);
        final avg = sum / nums.length;
        return '''
📘 *Basic Average*
Inputs: ${nums.join(", ")}
Formula: (Sum / Count) = (${sum.toStringAsFixed(2)} / ${nums.length})
✅ Average = ${avg.toStringAsFixed(2)}
''';
      case 1: // Weighted average
        final vals = parseNumbers(valuesController.text);
        final weights = parseNumbers(weightsController.text);
        if (vals.isEmpty || weights.isEmpty || vals.length != weights.length) {
          return '';
        }
        double weightedSum = 0;
        double totalWeight = 0;
        for (int i = 0; i < vals.length; i++) {
          weightedSum += vals[i] * weights[i];
          totalWeight += weights[i];
        }
        final avg = weightedSum / totalWeight;
        return '''
📘 *Weighted Average*
Values: ${vals.join(", ")}
Weights: ${weights.join(", ")}
Formula: Σ(Value × Weight) / Σ(Weights) = (${weightedSum.toStringAsFixed(2)} / ${totalWeight.toStringAsFixed(2)})
✅ Weighted Average = ${avg.toStringAsFixed(2)}
''';
      case 2: // Average speed
        final d = double.tryParse(totalDistanceController.text) ?? 0;
        final t = double.tryParse(totalTimeController.text) ?? 0;
        if (d == 0 || t == 0) return '⚠️ Please enter valid distance and time.';
        final speed = d / t;
        return '''
📘 *Average Speed*
Total Distance = ${d.toStringAsFixed(2)}  
Total Time = ${t.toStringAsFixed(2)}  
Formula: Speed = Distance / Time  
✅ Average Speed = ${speed.toStringAsFixed(2)}
''';
      default:
        return 'Coming soon...';
    }
  }

  List<double> parseNumbers(String input) {
    return input
        .split(',')
        .map((e) => double.tryParse(e.trim()))
        .where((e) => e != null)
        .map((e) => e!)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final subTextColor = widget.isDarkMode ? Colors.grey[300] : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text("Average Calculator", style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: List.generate(3, (i) => i == selectedMode),
              onPressed: (i) => setState(() => selectedMode = i),
              borderRadius: BorderRadius.circular(12),
              selectedColor: Colors.orange,
              color: subTextColor,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text("Basic"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text("Weighted"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text("Speed"),
                ),
              ],
            ),
            SizedBox(height: 24),
            if (selectedMode == 0)
              buildInput(
                "Enter numbers (comma-separated)",
                numbersController,
                textColor,
              ),
            if (selectedMode == 1) ...[
              buildInput(
                "Values (comma-separated)",
                valuesController,
                textColor,
              ),
              buildInput(
                "Weights (comma-separated)",
                weightsController,
                textColor,
              ),
            ],
            if (selectedMode == 2) ...[
              buildInput("Total Distance", totalDistanceController, textColor),
              buildInput("Total Time", totalTimeController, textColor),
            ],
            SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Result",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: widget.isDarkMode ? Colors.grey[900] : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              width: double.infinity,
              child: Text(
                resultText,
                style: TextStyle(fontSize: 16, color: textColor),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInput(
    String label,
    TextEditingController controller,
    Color textColor,
  ) {
    String dynamicHint = "e.g. ";
    if (selectedMode == 0) {
      dynamicHint += "10, 20, 30";
    } else if (selectedMode == 1) {
      if (controller == valuesController)
        dynamicHint += "85, 90, 95 (e.g. marks)";
      if (controller == weightsController)
        dynamicHint += "3, 4, 5 (e.g. credits)";
    } else if (selectedMode == 2) {
      if (controller == totalDistanceController)
        dynamicHint += "120 (km or miles)";
      if (controller == totalTimeController) dynamicHint += "2 (hours)";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.isDarkMode ? Colors.grey[900] : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: dynamicHint,
              hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
