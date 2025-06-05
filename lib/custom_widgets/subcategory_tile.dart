import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_calculator/screens/acceleration_calculator_screen.dart';
import 'package:smart_calculator/screens/age_calculator_screen.dart';
import 'package:smart_calculator/screens/average_calculator_screen.dart';
import 'package:smart_calculator/screens/percentage_calculator_screen.dart';
// import 'package:smart_calculator/screens/temparature_conversion_screen.dart';
import 'package:smart_calculator/screens/time_intervel_screen.dart';
import 'package:smart_calculator/screens/volume_conversion_screen.dart';

import '../../provider/theme_provider.dart';
import '../data.dart';
import '../screens/add_and_subtract_screen.dart';
import '../screens/bmi_screen.dart';
import '../screens/length_convertor_screen.dart';
import '../screens/proportion_calculator_screen.dart';
import '../screens/ratios_calculator_screen.dart';
import '../screens/weight_conversion_screen.dart'; // Make sure subcategoryIcons and subcategoryColors are defined

class SubcategoryTile extends StatelessWidget {
  final String subcategory;
  final String searchText;

  const SubcategoryTile({
    super.key,
    required this.subcategory,
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    if (!subcategory.toLowerCase().contains(searchText.toLowerCase()) &&
        searchText.isNotEmpty)
      return Container();

    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    final String emojiIcon = subcategoryIcons[subcategory] ?? '📌';
    final Color circleColor =
        subcategoryColors[subcategory] ??
        (isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFCBD5E1));

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: circleColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Text(emojiIcon, style: const TextStyle(fontSize: 20)),
        ),
        title: Text(
          subcategory,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: isDarkMode ? Colors.white54 : Colors.grey,
        ),
        onTap: () {
          Widget? targetScreen;

          switch (subcategory) {
            case 'Percentage':
              targetScreen = PercentageScreen(isDarkMode: isDarkMode);
              break;
            case 'Average':
              targetScreen = AverageScreen(isDarkMode: isDarkMode);
              break;
            case 'Proportion':
              targetScreen = ProportionScreen(isDarkMode: isDarkMode);
              break;
            case 'Ratio':
              targetScreen = RatioScreen(isDarkMode: isDarkMode);
              break;
            case 'BMI':
              targetScreen = BMIScreen(isDarkMode: isDarkMode);
              break;
            case 'Time Interval':
              targetScreen = TimeIntervalScreen(isDarkMode: isDarkMode);
              break;
            case 'add & subtract':
              targetScreen = DateTimeManipulator(isDarkMode: isDarkMode);
              break;
            case 'Age Calculator':
              targetScreen = AgeCalculatorScreen(isDarkMode: isDarkMode);
              break;
            case 'Length':
              targetScreen = LengthConversionScreen(isDarkMode: isDarkMode);
              break;
            case 'Weight':
              targetScreen = WeightConversionScreen(isDarkMode: isDarkMode);
              break;
            // case 'Temperature':
            //   targetScreen = TemperatureConversionScreen(
            //     isDarkMode: isDarkMode,
            //   );
            case 'Volume':
              targetScreen = VolumeConversionScreen(isDarkMode: isDarkMode);
              break;
            case 'Acceleration':
              targetScreen = AccelerationScreen(isDarkMode: isDarkMode);
              break;
            default:
              targetScreen = null;
          }

          if (targetScreen != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => targetScreen!),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("No screen defined for '$subcategory'")),
            );
          }
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }
}
