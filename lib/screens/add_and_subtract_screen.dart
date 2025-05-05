import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../custom_widgets/date_time_card.dart';

class DateTimeManipulator extends StatefulWidget {
  final bool isDarkMode;

  const DateTimeManipulator({super.key, required this.isDarkMode});

  @override
  _DateTimeManipulatorState createState() => _DateTimeManipulatorState();
}

class _DateTimeManipulatorState extends State<DateTimeManipulator> {
  DateTime _selectedDateTime = DateTime.now();
  bool _isAddition = true;
  TextEditingController _inputController = TextEditingController();
  String _unit = "Days";
  String _result = "";

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_calculateNewDate);
    _calculateNewDate();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
        _calculateNewDate();
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _selectedDateTime.hour,
        minute: _selectedDateTime.minute,
      ),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        _calculateNewDate();
      });
    }
  }

  void _toggleOperation() {
    setState(() {
      _isAddition = !_isAddition;
      _calculateNewDate();
    });
  }

  void _calculateNewDate() {
    int value = int.tryParse(_inputController.text) ?? 0;
    DateTime updatedDateTime = _selectedDateTime;

    if (_unit == "Days") {
      updatedDateTime =
          _isAddition
              ? _selectedDateTime.add(Duration(days: value))
              : _selectedDateTime.subtract(Duration(days: value));
    } else if (_unit == "Hours") {
      updatedDateTime =
          _isAddition
              ? _selectedDateTime.add(Duration(hours: value))
              : _selectedDateTime.subtract(Duration(hours: value));
    } else if (_unit == "Months") {
      int newMonth =
          _isAddition
              ? _selectedDateTime.month + value
              : _selectedDateTime.month - value;
      int yearAdjustment = (newMonth - 1) ~/ 12;
      int finalMonth = ((newMonth - 1) % 12 + 12) % 12 + 1;
      int finalYear = _selectedDateTime.year + yearAdjustment;
      updatedDateTime = DateTime(
        finalYear,
        finalMonth,
        _selectedDateTime.day,
        _selectedDateTime.hour,
        _selectedDateTime.minute,
      );
    } else if (_unit == "Years") {
      updatedDateTime = DateTime(
        _isAddition
            ? _selectedDateTime.year + value
            : _selectedDateTime.year - value,
        _selectedDateTime.month,
        _selectedDateTime.day,
        _selectedDateTime.hour,
        _selectedDateTime.minute,
      );
    }

    setState(() {
      _result = DateFormat('MMMM dd, yyyy hh:mm a').format(updatedDateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.black : Colors.grey.shade100;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: false,
        title: Text("Add & Subtract", style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
      ),
      backgroundColor: bgColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DateTimeCard(
              label: "Select Date and Time",
              value: _selectedDateTime,
              iconDate: Icons.calendar_today,
              iconTime: Icons.access_time,
              isStart: true,
              isDarkMode: widget.isDarkMode,
              textColor: textColor,
              pickDateTime: (isStart) {
                isStart ? _selectDate() : _selectTime();
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  onPressed: _toggleOperation,
                  icon: Icon(
                    _isAddition ? Icons.add_circle : Icons.remove_circle,
                    color: _isAddition ? Colors.green : Colors.red,
                    size: 32,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                ),
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      hintText: "Enter value",
                      hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
                      filled: true,
                      fillColor: bgColor,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _unit,
                  underline: SizedBox(),
                  borderRadius: BorderRadius.circular(12),
                  style: TextStyle(fontSize: 16, color: textColor),
                  dropdownColor: bgColor,
                  onChanged: (String? newValue) {
                    setState(() {
                      _unit = newValue!;
                      _calculateNewDate();
                    });
                  },
                  items:
                      ["Days", "Months", "Hours", "Years"]
                          .map(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  value,
                                  style: TextStyle(color: textColor),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                "Find how much time has passed between two moments in time",
                style: TextStyle(color: textColor),
              ),
            ),
            const SizedBox(height: 20),

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
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    widget.isDarkMode ? Colors.white24 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${DateFormat('MMMM dd, yyyy').format(DateFormat('MMMM dd, yyyy hh:mm a').parse(_result))}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${DateFormat('hh:mm a').format(DateFormat('MMMM dd, yyyy hh:mm a').parse(_result))}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
