import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // Add to pubspec.yaml
import 'package:permission_handler/permission_handler.dart'; // Add to pubspec.yaml

class Base64ConverterScreen extends StatefulWidget {
  final bool isDarkMode;
  const Base64ConverterScreen({super.key, required this.isDarkMode});

  @override
  State<Base64ConverterScreen> createState() => _Base64ConverterScreenState();
}

class _Base64ConverterScreenState extends State<Base64ConverterScreen> {
  String selectedMode = 'Encode';
  String result = '';
  Uint8List? fileBytes;
  String? fileName;

  final TextEditingController inputController = TextEditingController();

  // Page controller for input/output views
  final PageController _pageController = PageController();

  // For tracking if result is decoded file bytes (to allow download)
  Uint8List? decodedFileBytes;

  Future<void> pickFileAndConvert() async {
    final result = await FilePicker.platform.pickFiles(withData: true);
    if (result != null) {
      fileName = result.files.first.name;
      fileBytes = result.files.first.bytes;
      if (selectedMode == 'Encode') {
        setState(() {
          this.result = base64Encode(fileBytes!);
          decodedFileBytes = null; // clear any previous decoded file
        });
      } else {
        try {
          // Decode base64 from bytes interpreted as UTF8 string
          final decoded = base64Decode(utf8.decode(fileBytes!));
          setState(() {
            this.result = 'Decoded Data (binary): ${decoded.length} bytes';
            decodedFileBytes = decoded;
          });
        } catch (e) {
          setState(() {
            this.result = '❌ Invalid Base64 data.';
            decodedFileBytes = null;
          });
        }
      }
      // Switch to output page automatically
      _pageController.animateToPage(
        1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void convertText() {
    try {
      if (selectedMode == 'Encode') {
        setState(() {
          result = base64Encode(utf8.encode(inputController.text));
          decodedFileBytes = null;
        });
      } else {
        final decoded = utf8.decode(base64Decode(inputController.text));
        setState(() {
          result = decoded;
          decodedFileBytes = null;
        });
      }
      _pageController.animateToPage(
        1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } catch (_) {
      setState(() {
        result = '❌ Invalid input for $selectedMode.';
        decodedFileBytes = null;
      });
      _pageController.animateToPage(
        1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> downloadDecodedFile() async {
    if (decodedFileBytes == null) return;

    // Request storage permission (Android only)
    if (Platform.isAndroid) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Storage permission denied')));
        return;
      }
    }

    try {
      final dir = await getTemporaryDirectory();
      final savePath =
          '${dir.path}/decoded_${fileName ?? DateTime.now().millisecondsSinceEpoch}';
      final file = File(savePath);
      await file.writeAsBytes(decodedFileBytes!);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('File saved to $savePath')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save file: $e')));
    }
  }

  @override
  void dispose() {
    inputController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Colors.black : Colors.white;
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final cardColor = widget.isDarkMode ? Colors.grey[900] : Colors.grey[100];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(
          'Base64 Encoder & Decoder',
          style: TextStyle(color: textColor),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<String>(
              value: selectedMode,
              dropdownColor: cardColor,
              style: TextStyle(color: textColor),
              underline: SizedBox(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedMode = value;
                    result = '';
                    decodedFileBytes = null;
                    inputController.clear();
                  });
                  _pageController.animateToPage(
                    0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              items:
                  ['Encode', 'Decode']
                      .map(
                        (mode) =>
                            DropdownMenuItem(value: mode, child: Text(mode)),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          // INPUT PAGE
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: convertText,
                      icon: Icon(Icons.text_fields),
                      label: Text('$selectedMode Text'),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: pickFileAndConvert,
                      icon: Icon(Icons.upload_file),
                      label: Text('$selectedMode File'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Input (Text)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: inputController,
                      maxLines: null,
                      expands: true,
                      decoration: InputDecoration(border: InputBorder.none),
                      style: TextStyle(color: textColor),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // OUTPUT PAGE
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Output ($selectedMode Result)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        result,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ),
                ),
                if (selectedMode == 'Decode' && decodedFileBytes != null)
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: downloadDecodedFile,
                      icon: Icon(Icons.download),
                      label: Text('Download Decoded File'),
                    ),
                  ),
                SizedBox(height: 12),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _pageController.animateToPage(
                        0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    icon: Icon(Icons.arrow_back),
                    label: Text('Back to Input'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
