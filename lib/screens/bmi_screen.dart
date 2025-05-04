import 'package:flutter/material.dart';

class BMIScreen extends StatefulWidget {
  final bool isDarkMode;
  const BMIScreen({super.key, required this.isDarkMode});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  bool isMetric = true;

  // Metric inputs
  final TextEditingController heightCmController = TextEditingController(
    text: '180',
  );
  final TextEditingController weightKgController = TextEditingController(
    text: '80',
  );

  // Imperial inputs
  final TextEditingController heightFtController = TextEditingController(
    text: '5',
  );
  final TextEditingController heightInController = TextEditingController(
    text: '11',
  );
  final TextEditingController weightLbsController = TextEditingController(
    text: '176',
  );

  double get bmi {
    if (isMetric) {
      final heightCm = double.tryParse(heightCmController.text) ?? 0;
      final weightKg = double.tryParse(weightKgController.text) ?? 0;
      final heightM = heightCm / 100;
      return (heightM > 0) ? weightKg / (heightM * heightM) : 0.0;
    } else {
      final feet = double.tryParse(heightFtController.text) ?? 0;
      final inches = double.tryParse(heightInController.text) ?? 0;
      final weightLbs = double.tryParse(weightLbsController.text) ?? 0;
      final heightIn = (feet * 12) + inches;
      return (heightIn > 0) ? (weightLbs / (heightIn * heightIn)) * 703 : 0.0;
    }
  }

  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal weight';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  String get bmiRangeText {
    if (bmi < 18.5) return "BMI < 18.5";
    if (bmi < 25) return "BMI = 18.5 – 24.9";
    if (bmi < 30) return "BMI = 25 – 29.9";
    return "BMI ≥ 30";
  }

  Color get bmiColor {
    if (bmi < 18.5) return Colors.yellow;
    if (bmi < 25) return Colors.green;
    if (bmi < 30) return Colors.orange;
    return Colors.red;
  }

  int get activeBarIndex {
    if (bmi < 18.5) return 0;
    if (bmi < 25) return 1;
    if (bmi < 30) return 2;
    return 3;
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
        centerTitle: false,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Body Mass Index',
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            isMetric
                ? buildInputRow(
                  "Height",
                  "🧍🏻📏",
                  heightCmController,
                  "cm",
                  textColor,
                )
                : Row(
                  children: [
                    Expanded(
                      child: buildInputRow(
                        "Height (ft)",
                        "🧍",
                        heightFtController,
                        "ft",
                        textColor,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: buildInputRow(
                        "Inches",
                        "📏",
                        heightInController,
                        "in",
                        textColor,
                      ),
                    ),
                  ],
                ),
            SizedBox(height: 16),
            isMetric
                ? buildInputRow(
                  "Weight",
                  "⚖️",
                  weightKgController,
                  "kg",
                  textColor,
                )
                : buildInputRow(
                  "Weight",
                  "⚖️",
                  weightLbsController,
                  "lbs",
                  textColor,
                ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.subdirectory_arrow_right,
                  size: 20,
                  color: subTextColor,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Calculate the BMI of an adult aged 18 and over",
                    style: TextStyle(fontSize: 16, color: subTextColor),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      isMetric = !isMetric;
                    });
                  },
                  icon: Icon(Icons.swap_horiz, size: 16, color: Colors.orange),
                  label: Text(isMetric ? "Metric" : "Imperial"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: textColor,
                    backgroundColor: bgColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 28),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Result",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: textColor,
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    widget.isDarkMode ? Colors.grey[900] : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.monitor_weight, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        "BMI",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      Spacer(),
                      Text(
                        bmi.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Stack(
                    children: [
                      Row(
                        children: List.generate(4, (index) {
                          final colors = [
                            Colors.yellow,
                            Colors.green,
                            Colors.orange,
                            Colors.red,
                          ];
                          final color = colors[index];
                          return Expanded(
                            child: Container(
                              height: 6,
                              color:
                                  index == activeBarIndex
                                      ? color
                                      : color.withOpacity(0.3),
                            ),
                          );
                        }),
                      ),
                      Positioned(
                        left:
                            (bmi.clamp(10, 40) - 10) /
                                30 *
                                MediaQuery.of(context).size.width *
                                0.92 -
                            8,
                        top: 3,
                        child: Icon(
                          Icons.arrow_drop_up,
                          color: bmiColor,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    bmiCategory,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                  Text(bmiRangeText, style: TextStyle(color: subTextColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInputRow(
    String label,
    String emoji,
    TextEditingController controller,
    String unit,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: textColor,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: widget.isDarkMode ? Colors.grey[900] : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Text(emoji, style: TextStyle(fontSize: 22)),
              Spacer(),
              SizedBox(
                width: 60,
                child: TextField(
                  controller: controller,
                  onChanged: (_) => setState(() {}),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
              SizedBox(width: 8),
              Text(unit, style: TextStyle(fontSize: 14, color: textColor)),
            ],
          ),
        ),
      ],
    );
  }
}
