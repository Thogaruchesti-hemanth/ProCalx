import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../custom_widgets/date_time_card.dart';

class TimeIntervalScreen extends StatefulWidget {
  final bool isDarkMode;

  const TimeIntervalScreen({super.key, required this.isDarkMode});

  @override
  _TimeIntervalScreenState createState() => _TimeIntervalScreenState();
}

class _TimeIntervalScreenState extends State<TimeIntervalScreen> {
  DateTime? startDateTime;
  DateTime? endDateTime;
  Duration? difference;

  int monthsBetween(DateTime start, DateTime end) {
    return ((end.year - start.year) * 12 + end.month - start.month).abs();
  }

  int yearsBetween(DateTime start, DateTime end) {
    return (end.year - start.year).abs();
  }

  Future<void> pickDateTime(bool isStart) async {
    DateTime now = DateTime.now();

    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );

    if (time == null) return;

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      if (isStart) {
        startDateTime = selected;
      } else {
        endDateTime = selected;
      }

      if (startDateTime != null && endDateTime != null) {
        difference = endDateTime!.difference(startDateTime!);
      }
    });
  }

  void clearDateTime(bool isStart) {
    setState(() {
      if (isStart) {
        startDateTime = null;
      } else {
        endDateTime = null;
      }
      difference =
          (startDateTime != null && endDateTime != null)
              ? endDateTime!.difference(startDateTime!)
              : null;
    });
  }

  String formatDate(DateTime dt) {
    return DateFormat('MMM d, yyyy').format(dt);
  }

  String formatTime(DateTime dt) {
    return TimeOfDay.fromDateTime(dt).format(context);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.black : Colors.grey.shade100;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: false,
        title: Text("Time interval", style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
        actions: [
          if (startDateTime != null || endDateTime != null)
            IconButton(
              icon: Icon(Icons.close, color: textColor),
              onPressed: showClearConfirmationDialog,
            ),
          Icon(Icons.more_vert, color: textColor),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DateTimeCard(
              label: "Start date",
              value: startDateTime,
              iconDate: Icons.calendar_today,
              iconTime: Icons.access_time,
              isStart: true,
              textColor: textColor,
              isDarkMode: widget.isDarkMode,
              pickDateTime: pickDateTime,
            ),
            DateTimeCard(
              label: "End date",
              value: endDateTime,
              iconDate: Icons.calendar_today,
              iconTime: Icons.access_time,
              isStart: false,
              textColor: textColor,
              isDarkMode: widget.isDarkMode,
              pickDateTime: pickDateTime,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                "Find how much time has passed between two moments in time",
                style: TextStyle(color: textColor),
              ),
            ),

            if (difference != null &&
                startDateTime != null &&
                endDateTime != null)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Result",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ),

            if (difference != null &&
                startDateTime != null &&
                endDateTime != null)
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: widget.isDarkMode ? Colors.grey[850] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: buildTimeDifferenceResult(textColor),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildTimeDifferenceResult(Color textColor) {
    final dt1 = startDateTime!;
    final dt2 = endDateTime!;
    final absDiff = difference!.abs();

    int totalMonths = monthsBetween(dt1, dt2);
    int totalYears = yearsBetween(dt1, dt2);
    int remainingMonths = totalMonths % 12;
    int remainingDays = absDiff.inDays % 30;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (totalYears > 0)
          Text(
            "$totalYears Years",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        if (remainingMonths > 0)
          Text(
            "$remainingMonths Months",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        if (remainingDays > 0)
          Text(
            "$remainingDays Days",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        Text(
          "${absDiff.inHours % 24} Hours",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        Text(
          "${absDiff.inMinutes % 60} Minutes",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const Divider(),
        Text(
          "${absDiff.inDays} Total Days",
          style: TextStyle(fontSize: 16, color: textColor),
        ),
        Text(
          "${absDiff.inHours} Total Hours",
          style: TextStyle(fontSize: 16, color: textColor),
        ),
        Text(
          "${absDiff.inMinutes} Total Minutes",
          style: TextStyle(fontSize: 16, color: textColor),
        ),
      ],
    );
  }

  Future<void> showClearConfirmationDialog() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Clear Data"),
            content: const Text(
              "Are you sure you want to clear the selected dates and times?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Clear"),
              ),
            ],
          ),
    );

    if (shouldClear == true) {
      setState(() {
        startDateTime = null;
        endDateTime = null;
        difference = null;
      });
    }
  }
}
