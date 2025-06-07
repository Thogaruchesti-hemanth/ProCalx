import 'package:flutter/material.dart';

class DataConversionScreen extends StatefulWidget {
  final bool isDarkMode;
  const DataConversionScreen({super.key, required this.isDarkMode});

  @override
  State<DataConversionScreen> createState() => _DataConversionScreenState();
}

class _DataConversionScreenState extends State<DataConversionScreen> {
  final TextEditingController inputController = TextEditingController();
  final TextEditingController baseController = TextEditingController();
  int selectedConversionIndex = 0;

  final List<String> conversionTypes = [
    "Binary to Decimal",
    "Decimal to Hexadecimal",
    "Hexadecimal to Binary",
    "Octal to Decimal",
    "Base-n Converter",
    "ASCII to Text",
    "String to BCD Format",
    "Byte to Hex String",
    "Binary String to ByteArray",
    "Hex String to Integer",
    "Timestamp to DateTime",
  ];

  String getInputHint() {
    switch (selectedConversionIndex) {
      case 0:
        return "Enter binary (e.g., 1010)";
      case 1:
        return "Enter decimal (e.g., 255)";
      case 2:
        return "Enter hex (e.g., 1F)";
      case 3:
        return "Enter octal (e.g., 17)";
      case 4:
        return "Enter number, base below";
      case 5:
        return "Enter ASCII codes (space-separated)";
      case 6:
        return "Enter string (e.g., 123)";
      case 7:
        return "Enter byte (e.g., 255)";
      case 8:
        return "Enter binary string";
      case 9:
        return "Enter hex string (e.g., FF)";
      case 10:
        return "Enter Unix timestamp (e.g., 1628073600)";
      default:
        return "Enter input";
    }
  }

  String performConversion() {
    final input = inputController.text.trim();
    try {
      switch (selectedConversionIndex) {
        case 0:
          int decimal = int.parse(input, radix: 2);
          return "Binary: $input\nDecimal: $decimal\n\n📘 Formula: \nDecimal = Σ (bit * 2^position)\n\nEg: 1010 → 1×2³ + 0×2² + 1×2¹ + 0×2⁰ = 8 + 0 + 2 + 0 = 10";
        case 1:
          int decimal = int.parse(input);
          String hex = decimal.toRadixString(16).toUpperCase();
          return "Decimal: $decimal\nHexadecimal: $hex\n\n📘 Formula: Divide by 16, use remainders.\n\nEg: 255 → 255 ÷ 16 = 15 R15 → F F → FF";
        case 2:
          int decimal = int.parse(input, radix: 16);
          String binary = decimal.toRadixString(2);
          return "Hexadecimal: $input\nBinary: $binary\n\n📘 Formula: Convert each hex digit to 4-bit binary.\nEg: 1F → 0001 1111";
        case 3:
          int decimal = int.parse(input, radix: 8);
          return "Octal: $input\nDecimal: $decimal\n\n📘 Formula: \nDecimal = Σ (digit × 8^position)\nEg: 17 → 1×8¹ + 7×8⁰ = 8 + 7 = 15";
        case 4:
          int base = int.tryParse(baseController.text.trim()) ?? 10;
          if (base < 2 || base > 36) return "❌ Base must be between 2 and 36.";
          int decimal = int.parse(input, radix: base);
          return "Input: $input (Base $base)\nDecimal: $decimal\n\n📘 Formula: \nDecimal = Σ (digit × base^position)";
        case 5:
          List<int> asciiList =
              input
                  .split(RegExp(r'\s+'))
                  .map((e) => int.parse(e.trim()))
                  .toList();
          String text = String.fromCharCodes(asciiList);
          return "ASCII Codes: ${asciiList.join(' ')}\nText: $text\n\n📘 Each ASCII code maps to a character.\nEg: 72 101 108 108 111 → 'Hello'";
        case 6:
          String bcd = input.codeUnits
              .map((e) => e.toRadixString(4).padLeft(4, '0'))
              .join(' ');
          return "Input String: $input\nBCD Format: $bcd\n\n📘 Each digit encoded in Binary-Coded Decimal (4-bit each)";
        case 7:
          int byte = int.parse(input);
          String hex = byte.toRadixString(16).padLeft(2, '0');
          return "Byte: $input\nHex String: $hex\n\n📘 Formula: Byte → Hex using toRadixString(16)";
        case 8:
          List<int> byteArray = [];
          for (int i = 0; i < input.length; i += 8) {
            byteArray.add(int.parse(input.substring(i, i + 8), radix: 2));
          }
          return "Binary String: $input\nByteArray: ${byteArray.join(', ')}\n\n📘 8-bit chunks converted to decimal.";
        case 9:
          int value = int.parse(input, radix: 16);
          return "Hex String: $input\nInteger: $value\n\n📘 Formula: Hex digit × 16^position";
        case 10:
          int timestamp = int.parse(input);
          DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
          return "Timestamp: $input\nDateTime: $date\n\n📘 Converts Unix timestamp to readable DateTime.";
        default:
          return "Unsupported conversion";
      }
    } catch (_) {
      return "❌ Invalid input. Please check the format.";
    }
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
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dev Data Converter',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<int>(
              value: selectedConversionIndex,
              items: List.generate(conversionTypes.length, (index) {
                return DropdownMenuItem(
                  value: index,
                  child: Text(
                    conversionTypes[index],
                    style: TextStyle(color: textColor),
                  ),
                );
              }),
              dropdownColor:
                  widget.isDarkMode ? Colors.grey[900] : Colors.white,
              onChanged: (index) {
                setState(() => selectedConversionIndex = index!);
              },
              decoration: InputDecoration(
                labelText: "Conversion Type",
                labelStyle: TextStyle(color: subTextColor),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            buildInputRow(getInputHint(), inputController, textColor),
            if (selectedConversionIndex == 4) ...[
              SizedBox(height: 12),
              buildInputRow("Base (e.g., 2-36)", baseController, textColor),
            ],
            SizedBox(height: 28),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Detailed Result",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: textColor,
                ),
              ),
            ),
            SizedBox(height: 8),
            if (inputController.text.isNotEmpty)
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(top: 24),
                decoration: BoxDecoration(
                  color:
                      widget.isDarkMode ? Colors.grey[900] : Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SelectableText(
                  performConversion(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildInputRow(
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
            color: widget.isDarkMode ? Colors.grey[900] : Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: controller,
            onChanged: (_) => setState(() {}),
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
