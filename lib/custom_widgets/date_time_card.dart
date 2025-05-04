import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package

class DateTimeCard extends StatelessWidget {
  final String label;
  final DateTime? value;
  final IconData iconDate;
  final IconData iconTime;
  final bool isStart;
  final Color textColor;
  final bool isDarkMode;
  final Function(bool) pickDateTime;

  DateTimeCard({
    required this.label,
    required this.value,
    required this.iconDate,
    required this.iconTime,
    required this.isStart,
    required this.textColor,
    required this.isDarkMode,
    required this.pickDateTime,
  });

  // Format the date as "5 May 2025"
  String formatDate(DateTime dateTime) {
    return DateFormat(
      'd MMMM yyyy',
    ).format(dateTime); // "d" is for day, "MMMM" for full month name
  }

  // Format the time as "HH:mm a" (AM/PM)
  String formatTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime); // 12-hour format with AM/PM
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => pickDateTime(isStart),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(iconDate, color: isStart ? Colors.green : Colors.red),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value != null ? formatDate(value!) : label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        iconTime,
                        size: 18,
                        color: isStart ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        value != null ? formatTime(value!) : "--:--",
                        style: TextStyle(fontSize: 16, color: textColor),
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
}
