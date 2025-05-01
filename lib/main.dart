import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_calculator/calculator.dart';
import 'package:smart_calculator/provider/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider(),
      child: MaterialApp(
        title: 'Smart Calculator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
        home: CalculatorApp(),
      ),
    );
  }
}
