import 'package:flutter/material.dart';

class ColorConversionScreen extends StatefulWidget {
  final bool isDarkMode;
  const ColorConversionScreen({super.key, required this.isDarkMode});

  @override
  State<ColorConversionScreen> createState() => _ColorConversionScreenState();
}

class _ColorConversionScreenState extends State<ColorConversionScreen> {
  final TextEditingController inputController = TextEditingController();
  String selectedFormat = 'HEX';
  Color? parsedColor;

  final List<String> formats = ['HEX', 'RGB', 'HSL', 'HSV', 'CMYK'];

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  void convertColor(String input) {
    final color = parseColor(input.trim(), selectedFormat);
    setState(() {
      parsedColor = color;
    });
  }

  // ------------- CUSTOM COLOR PARSERS -------------

  Color? parseColor(String input, String format) {
    try {
      switch (format) {
        case 'HEX':
          return _parseHex(input);
        case 'RGB':
          return _parseRgb(input);
        case 'HSL':
          return _parseHsl(input);
        case 'HSV':
          return _parseHsv(input);
        case 'CMYK':
          return _parseCmyk(input);
      }
    } catch (_) {}
    return null;
  }

  Color? _parseHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  Color? _parseRgb(String rgb) {
    final match = RegExp(r'rgb\((\d+),\s*(\d+),\s*(\d+)\)').firstMatch(rgb);
    if (match != null) {
      return Color.fromARGB(
        255,
        int.parse(match[1]!),
        int.parse(match[2]!),
        int.parse(match[3]!),
      );
    }
    return null;
  }

  Color? _parseHsl(String hsl) {
    final match = RegExp(r'hsl\((\d+),\s*(\d+)%?,\s*(\d+)%?\)').firstMatch(hsl);
    if (match != null) {
      return HSLColor.fromAHSL(
        1,
        double.parse(match[1]!),
        double.parse(match[2]!) / 100,
        double.parse(match[3]!) / 100,
      ).toColor();
    }
    return null;
  }

  Color? _parseHsv(String hsv) {
    final match = RegExp(r'hsv\((\d+),\s*(\d+)%?,\s*(\d+)%?\)').firstMatch(hsv);
    if (match != null) {
      return HSVColor.fromAHSV(
        1,
        double.parse(match[1]!),
        double.parse(match[2]!) / 100,
        double.parse(match[3]!) / 100,
      ).toColor();
    }
    return null;
  }

  Color? _parseCmyk(String cmyk) {
    final match = RegExp(
      r'(\d+)%?,\s*(\d+)%?,\s*(\d+)%?,\s*(\d+)%?',
    ).firstMatch(cmyk);
    if (match != null) {
      final c = int.parse(match[1]!) / 100;
      final m = int.parse(match[2]!) / 100;
      final y = int.parse(match[3]!) / 100;
      final k = int.parse(match[4]!) / 100;
      final r = ((1 - c) * (1 - k) * 255).round();
      final g = ((1 - m) * (1 - k) * 255).round();
      final b = ((1 - y) * (1 - k) * 255).round();
      return Color.fromARGB(255, r, g, b);
    }
    return null;
  }

  // ------------- CONVERTERS (Color -> Formats) -------------

  String toHex(Color color) =>
      '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

  String toRgb(Color color) =>
      'rgb(${color.red}, ${color.green}, ${color.blue})';

  String toHsl(Color color) {
    final hsl = HSLColor.fromColor(color);
    return 'hsl(${hsl.hue.round()}, ${(hsl.saturation * 100).round()}%, ${(hsl.lightness * 100).round()}%)';
  }

  String toHsv(Color color) {
    final hsv = HSVColor.fromColor(color);
    return 'hsv(${hsv.hue.round()}, ${(hsv.saturation * 100).round()}%, ${(hsv.value * 100).round()}%)';
  }

  String toCmyk(Color color) {
    final r = color.red / 255;
    final g = color.green / 255;
    final b = color.blue / 255;
    final k = 1 - [r, g, b].reduce((a, b) => a > b ? a : b);
    if (k == 1) return '0%, 0%, 0%, 100%';
    final c = (1 - r - k) / (1 - k);
    final m = (1 - g - k) / (1 - k);
    final y = (1 - b - k) / (1 - k);
    return '${(c * 100).round()}%, ${(m * 100).round()}%, ${(y * 100).round()}%, ${(k * 100).round()}%';
  }

  String colorToHex(Color color, {bool leadingHashSign = true}) {
    return '${leadingHashSign ? '#' : ''}'
            '${color.red.toRadixString(16).padLeft(2, '0')}'
            '${color.green.toRadixString(16).padLeft(2, '0')}'
            '${color.blue.toRadixString(16).padLeft(2, '0')}'
        .toUpperCase();
  }

  // ------------- UI -------------

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Color Code Converter", style: TextStyle(color: textColor)),
        backgroundColor: bgColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildFormatPicker(textColor),
            SizedBox(height: 12),
            buildInputField(textColor),
            SizedBox(height: 20),
            if (parsedColor != null) ...[
              colorPreview(parsedColor!, textColor),
              SizedBox(height: 20),
              conversionTile('HEX', toHex(parsedColor!), textColor),
              conversionTile('RGB', toRgb(parsedColor!), textColor),
              conversionTile('HSL', toHsl(parsedColor!), textColor),
              conversionTile('HSV', toHsv(parsedColor!), textColor),
              conversionTile('CMYK', toCmyk(parsedColor!), textColor),
            ] else
              Text(
                "Invalid input or format",
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildFormatPicker(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Input Format',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.isDarkMode ? Colors.grey[900] : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<String>(
            value: selectedFormat,
            onChanged: (value) {
              if (value != null) {
                setState(() => selectedFormat = value);
                convertColor(inputController.text.trim());
              }
            },
            icon: Icon(Icons.arrow_drop_down, color: textColor),
            isExpanded: true,
            underline: SizedBox(),
            dropdownColor: widget.isDarkMode ? Colors.grey[850] : Colors.white,
            items:
                formats.map((format) {
                  return DropdownMenuItem<String>(
                    value: format,
                    child: Text(format, style: TextStyle(color: textColor)),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget buildInputField(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter Color Value',
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: widget.isDarkMode ? Colors.grey[900] : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: inputController,
            onChanged: (val) => convertColor(val.trim()),
            style: TextStyle(color: textColor, fontSize: 18),
            decoration: InputDecoration(
              hintText:
                  selectedFormat == 'HEX'
                      ? '#FF5733'
                      : selectedFormat == 'RGB'
                      ? 'rgb(255, 87, 51)'
                      : selectedFormat == 'HSL'
                      ? 'hsl(11, 100%, 60%)'
                      : selectedFormat == 'HSV'
                      ? 'hsv(11, 80%, 100%)'
                      : '0%, 66%, 80%, 0%',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget colorPreview(Color color, Color textColor) {
    String hexLabel = colorToHex(color); // Generate HEX string

    return Container(
      height: 100,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Center(
        child: Text(
          hexLabel,
          style: TextStyle(
            color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget conversionTile(String label, String value, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),
          Expanded(child: Text(value, style: TextStyle(color: textColor))),
        ],
      ),
    );
  }
}
