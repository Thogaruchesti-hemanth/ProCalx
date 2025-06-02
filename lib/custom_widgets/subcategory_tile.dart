import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_calculator/screens/area_conversion_screen.dart';
import 'package:smart_calculator/screens/color_code_conversion_screen.dart';
import 'package:smart_calculator/screens/data_conversion_screen.dart';
import 'package:smart_calculator/screens/interest_calculation_screen.dart';
import 'package:smart_calculator/screens/json_formatter_screen.dart';
import 'package:smart_calculator/screens/loan_calculation_screen.dart';

import '../../provider/theme_provider.dart';
import '../data.dart';
import '../screens/Equation_solver_screen.dart';
import '../screens/acceleration_calculator_screen.dart';
import '../screens/add_and_subtract_screen.dart';
import '../screens/age_calculator_screen.dart';
import '../screens/area_calculator_screen.dart';
import '../screens/average_calculator_screen.dart';
import '../screens/base64_screen.dart';
import '../screens/bmi_screen.dart';
import '../screens/data_storage_conversion_screen.dart';
import '../screens/fraction_calculator_screen.dart';
import '../screens/length_convertor_screen.dart';
import '../screens/percentage_calculator_screen.dart';
import '../screens/proportion_calculator_screen.dart';
import '../screens/ratios_calculator_screen.dart';
import '../screens/temperature_conversion_screen.dart';
import '../screens/time_conversion_screen.dart';
import '../screens/time_intervel_screen.dart';
import '../screens/volume_calculation_Screen.dart';
import '../screens/volume_conversion_screen.dart';
import '../screens/weight_conversion_screen.dart';

class SubcategoryTile extends StatelessWidget {
  final String subcategory;
  final String searchText;

  const SubcategoryTile({
    Key? key,
    required this.subcategory,
    required this.searchText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!subcategory.toLowerCase().contains(searchText.toLowerCase()) &&
        searchText.isNotEmpty) {
      return const SizedBox.shrink();
    }

    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    final String emojiIcon = subcategoryIcons[subcategory] ?? '📌';
    final Color circleColor =
        subcategoryColors[subcategory] ??
        (isDarkMode ? const Color(0xFF4B5563) : const Color(0xFFCBD5E1));

    Widget? targetScreen;

    // Normalize subcategory to lowercase for matching
    final normalizedSubcategory = subcategory.toLowerCase();

    switch (normalizedSubcategory) {
      case 'data conversion':
        targetScreen = DataConversionScreen(isDarkMode: isDarkMode);
        break;
      case 'base64 converter':
        targetScreen = Base64ConverterScreen(isDarkMode: isDarkMode);
        break;
      case 'jsonmate':
        targetScreen = JsonFormatterScreen(isDarkMode: isDarkMode);
        break;
      case 'color code converter':
        targetScreen = ColorConversionScreen(isDarkMode: isDarkMode);
        break;
      case 'percentage':
        targetScreen = PercentageScreen(isDarkMode: isDarkMode);
        break;
      case 'average':
        targetScreen = AverageScreen(isDarkMode: isDarkMode);
        break;
      case 'proportion':
        targetScreen = ProportionScreen(isDarkMode: isDarkMode);
        break;
      case 'ratio':
        targetScreen = RatioScreen(isDarkMode: isDarkMode);
        break;
      case 'equations':
        targetScreen = EquationSolverScreen(isDarkMode: isDarkMode);
        break;
      case 'fractions':
        targetScreen = FractionScreen(isDarkMode: isDarkMode);
        break;
      case 'shape':
        targetScreen = AreaCalculatorScreen(isDarkMode: isDarkMode);
        break;
      case 'body':
        targetScreen = VolumeCalculatorScreen(isDarkMode: isDarkMode);
        break;
      case 'length':
        targetScreen = LengthConversionScreen(isDarkMode: isDarkMode);
        break;
      case 'weight':
        targetScreen = WeightConversionScreen(isDarkMode: isDarkMode);
        break;
      case 'data storage':
        targetScreen = DataStorageConversionScreen(isDarkMode: isDarkMode);
        break;
      case 'bmi':
        targetScreen = BMIScreen(isDarkMode: isDarkMode);
        break;
      case 'time interval':
        targetScreen = TimeIntervalScreen(isDarkMode: isDarkMode);
        break;
      case 'add & subtract':
        targetScreen = DateTimeManipulator(
          isDarkMode: isDarkMode,
        ); // Make sure class name matches here
        break;
      case 'age calculator':
        targetScreen = AgeCalculatorScreen(isDarkMode: isDarkMode);
        break;
      case 'temperature':
        targetScreen = TemperatureConversionScreen(isDarkMode: isDarkMode);
        break;
      case 'volume conversion':
        targetScreen = VolumeConversionScreen(isDarkMode: isDarkMode);
        break;
      case 'acceleration':
        targetScreen = AccelerationScreen(isDarkMode: isDarkMode);
        break;
      case 'area':
        targetScreen = AreaConversionScreen(isDarkMode: isDarkMode);
        break;
      case 'time conversion':
        targetScreen = TimeConversionScreen(isDarkMode: isDarkMode);
        break;
      case 'interest':
        targetScreen = InterestCalculatorScreen(isDarkMode: isDarkMode);
        break;
      case 'loan':
        targetScreen = LoanCalculatorScreen(isDarkMode: isDarkMode);
        break;
      default:
        targetScreen = null;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      key: key, // Important for scrolling to work!
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
