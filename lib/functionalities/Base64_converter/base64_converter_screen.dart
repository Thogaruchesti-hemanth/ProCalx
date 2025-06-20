import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io' show File, Platform;
import 'dart:html' as html;

enum ConversionMode { encode, decode }

class Base64ConverterScreen extends StatefulWidget {
  final bool isDarkMode;
  const Base64ConverterScreen({super.key, required this.isDarkMode});

  @override
  State<Base64ConverterScreen> createState() => _Base64ConverterScreenState();
}

class _Base64ConverterScreenState extends State<Base64ConverterScreen> {
  ConversionMode selectedMode = ConversionMode.encode;
  String result = '';
  Uint8List? fileBytes;
  String? fileName;
  Uint8List? decodedFileBytes;
  bool isImage = false;
  String? mimeType;
  bool isLoading = false;

  final TextEditingController inputController = TextEditingController();
  final PageController _pageController = PageController();

  Future<void> pickFileAndConvert() async {
    setState(() => isLoading = true);
    try {
      final pickedFile = await FilePicker.platform.pickFiles(withData: true);
      if (pickedFile != null) {
        fileName = pickedFile.files.first.name;
        fileBytes = pickedFile.files.first.bytes;
        if (selectedMode == ConversionMode.encode) {
          result = base64Encode(fileBytes!);
          decodedFileBytes = null;
          isImage = false;
          mimeType = null;
          _pageController.jumpToPage(1);
        }
      }
    } catch (_) {}
    setState(() => isLoading = false);
  }

  void convertText() {
    setState(() => isLoading = true);
    try {
      if (selectedMode == ConversionMode.encode) {
        result = base64Encode(utf8.encode(inputController.text));
        decodedFileBytes = null;
        isImage = false;
        mimeType = null;
      } else {
        String input = inputController.text.trim();
        if (input.startsWith('data:')) {
          final parts = input.split(',');
          if (parts.length == 2) input = parts[1];
        }

        Uint8List decoded = base64Decode(input);
        bool imageDetected = isLikelyImage(decoded);
        bool isBinary = !isUtf8(utf8.decode(decoded, allowMalformed: true));
        final mime = lookupMimeType('', headerBytes: decoded);

        decodedFileBytes = decoded;
        isImage = imageDetected;
        mimeType = mime;
        result = imageDetected || isBinary ? '' : utf8.decode(decoded);
      }
      _pageController.jumpToPage(1);
    } catch (e) {
      result = '❌ Invalid input for ${selectedMode.name} mode.\n\n$e';
      decodedFileBytes = null;
      isImage = false;
      mimeType = null;
    }
    setState(() => isLoading = false);
  }

  Future<void> downloadDecodedFile() async {
    if (decodedFileBytes == null) return;
    try {
      if (kIsWeb) {
        final blob = html.Blob([decodedFileBytes!]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor =
            html.AnchorElement(href: url)
              ..setAttribute(
                'download',
                'decoded_file.${isImage ? 'png' : 'bin'}',
              )
              ..click();
        html.Url.revokeObjectUrl(url);
        return;
      }

      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Storage permission denied')));
          return;
        }
      }

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/decoded_file.${isImage ? 'png' : 'bin'}');
      await file.writeAsBytes(decodedFileBytes!);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('File saved to ${file.path}')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save file: $e')));
    }
  }

  Future<void> shareDecodedFile() async {
    if (kIsWeb || decodedFileBytes == null) return;
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/share_temp.${isImage ? 'png' : 'bin'}');
      await file.writeAsBytes(decodedFileBytes!);
      await Share.shareXFiles([XFile(file.path)], text: 'Decoded file');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sharing failed: $e')));
    }
  }

  bool isLikelyImage(Uint8List data) {
    return data.length >= 4 &&
        ((data[0] == 0x89 &&
                data[1] == 0x50 &&
                data[2] == 0x4E &&
                data[3] == 0x47) ||
            (data[0] == 0xFF && data[1] == 0xD8));
  }

  bool isUtf8(String input) {
    try {
      utf8.encode(input);
      return true;
    } catch (_) {
      return false;
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
        title: Text('Base64 Pro Converter', style: TextStyle(color: textColor)),
        actions: [
          ToggleButtons(
            isSelected: [
              selectedMode == ConversionMode.encode,
              selectedMode == ConversionMode.decode,
            ],
            onPressed: (index) {
              setState(() {
                selectedMode =
                    index == 0 ? ConversionMode.encode : ConversionMode.decode;
                result = '';
                decodedFileBytes = null;
                isImage = false;
                inputController.clear();
              });
              _pageController.animateToPage(
                0,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Encode'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Decode'),
              ),
            ],
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
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
                      label: Text('${selectedMode.name.capitalize()} Text'),
                    ),
                    SizedBox(width: 12),
                    if (selectedMode == ConversionMode.encode)
                      ElevatedButton.icon(
                        onPressed: pickFileAndConvert,
                        icon: Icon(Icons.upload_file),
                        label: Text('${selectedMode.name.capitalize()} File'),
                      ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Input',
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.clear, color: textColor),
                              onPressed: () => inputController.clear(),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TextField(
                            controller: inputController,
                            maxLines: null,
                            expands: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            style: TextStyle(color: textColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Output',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    if (result.isNotEmpty)
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: result));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Copied to clipboard')),
                          );
                        },
                        icon: Icon(Icons.copy, color: textColor),
                        tooltip: 'Copy Output',
                      ),
                  ],
                ),
                SizedBox(height: 8),
                if (fileName != null &&
                    fileBytes != null &&
                    selectedMode == ConversionMode.encode)
                  Text(
                    'File: $fileName (${fileBytes!.lengthInBytes} bytes)',
                    style: TextStyle(color: textColor),
                  ),
                if (mimeType != null)
                  Text(
                    'Detected MIME Type: $mimeType',
                    style: TextStyle(color: textColor),
                  ),
                SizedBox(height: 8),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        isImage && decodedFileBytes != null
                            ? Image.memory(
                              decodedFileBytes!,
                              fit: BoxFit.contain,
                            )
                            : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (result.isNotEmpty)
                                    SelectableText(
                                      result,
                                      style: TextStyle(color: textColor),
                                    ),
                                ],
                              ),
                            ),
                  ),
                ),
                if (decodedFileBytes != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: downloadDecodedFile,
                        icon: Icon(Icons.download),
                        label: Text('Download'),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: shareDecodedFile,
                        icon: Icon(Icons.share),
                        label: Text('Share'),
                      ),
                    ],
                  ),
                SizedBox(height: 12),
                Center(
                  child: TextButton.icon(
                    onPressed:
                        () => _pageController.animateToPage(
                          0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: textColor,
                    ),
                    label: Text('Back', style: TextStyle(color: textColor)),
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

extension StringCasingExtension on String {
  String capitalize() =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
}
