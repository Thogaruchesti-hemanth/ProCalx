import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_calculator/custom_widgets/date_time_card.dart';

class AgeCalculatorScreen extends StatefulWidget {
  final bool isDarkMode; // Pass this from the parent class to handle theme.

  AgeCalculatorScreen({required this.isDarkMode});

  @override
  _AgeCalculatorScreenState createState() => _AgeCalculatorScreenState();
}

class _AgeCalculatorScreenState extends State<AgeCalculatorScreen> {
  DateTime _dob = DateTime.now();
  String _age = "";
  String _nextBirthday = "";

  @override
  void initState() {
    super.initState();
    _calculateAgeAndNextBirthday();
  }

  // Function to calculate age and next birthday
  void _calculateAgeAndNextBirthday() {
    final today = DateTime.now();

    int years = today.year - _dob.year;
    int months = today.month - _dob.month;
    int days = today.day - _dob.day;

    // Adjust if birthday hasn't occurred yet this year
    if (days < 0) {
      final previousMonth = DateTime(
        today.year,
        today.month,
        0,
      ); // last day of previous month
      days += previousMonth.day;
      months--;
    }

    if (months < 0) {
      months += 12;
      years--;
    }

    // Ensure no negative values
    if (years < 0) years = 0;
    if (months < 0) months = 0;
    if (days < 0) days = 0;

    setState(() {
      // multiline string for age display
      _age = "$years Years\n$months Months\n$days Days";

      // Calculate next birthday
      DateTime nextBirthday = DateTime(today.year, _dob.month, _dob.day);
      if (nextBirthday.isBefore(today) ||
          nextBirthday.isAtSameMomentAs(today)) {
        nextBirthday = DateTime(today.year + 1, _dob.month, _dob.day);
      }

      _nextBirthday = DateFormat('MMMM dd, yyyy').format(nextBirthday);
    });
  }

  Future<void> _selectDOB() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _dob) {
      setState(() {
        _dob = pickedDate;
        _calculateAgeAndNextBirthday();
      });
    }
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
        centerTitle: false,
        title: Text("Age Calculator", style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date of Birth picker
            DateTimeCard(
              label: "Select Date and Time",
              value: _dob,
              iconDate: Icons.calendar_today,
              iconTime: Icons.access_time,
              isStart: true,
              isDarkMode: widget.isDarkMode,
              textColor: textColor,
              pickDateTime: (isStart) {
                _selectDOB();
              },
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                "Find how much time has passed between two moments in time",
                style: TextStyle(color: textColor),
              ),
            ),
            const SizedBox(height: 20),
            // Age display with prefix icon
            SizedBox(width: 10),
            Text(
              "🎂 Your Age",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.all(12),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    widget.isDarkMode ? Colors.white24 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$_age",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // Next Birthday display with prefix icon
            Text(
              "🗓️ Next Birthday",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.all(12),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    widget.isDarkMode ? Colors.white24 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _nextBirthday,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
