import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JsonFormatterScreen extends StatefulWidget {
  final bool isDarkMode;
  const JsonFormatterScreen({super.key, required this.isDarkMode});

  @override
  State<JsonFormatterScreen> createState() => _JsonFormatterScreenState();
}

class _JsonFormatterScreenState extends State<JsonFormatterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _jsonController = TextEditingController();
  final TextEditingController _classNameController = TextEditingController();

  String? _formattedJson;
  String? _error;
  String? _generatedModel;
  String _selectedLanguage = 'Dart';

  final List<String> languages = [
    'Dart',
    'Java',
    'Kotlin',
    'Python',
    'TypeScript',
    'Swift',
  ];

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  void _formatJson() {
    try {
      final jsonObject = jsonDecode(_jsonController.text);
      final prettyJson = const JsonEncoder.withIndent('  ').convert(jsonObject);
      setState(() {
        _formattedJson = prettyJson;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _formattedJson = null;
        _error = '❌ Invalid JSON format';
      });
    }
  }

  void _generateModel() {
    try {
      final decoded = jsonDecode(_jsonController.text);
      final className =
          _classNameController.text.trim().isEmpty
              ? 'MyModel'
              : _classNameController.text.trim();
      String model = '';

      switch (_selectedLanguage) {
        case 'Dart':
          model = _generateDartModel(className, decoded);
          break;
        case 'Java':
          model = _generateJavaModel(className, decoded);
          break;
        case 'Python':
          model = _generatePythonModel(className, decoded);
          break;
        case 'TypeScript':
          model = _generateTsModel(className, decoded);
          break;
        case 'Kotlin':
          model = _generateKotlinModel(className, decoded);
          break;
        case 'Swift':
          model = _generateSwiftModel(className, decoded);
          break;
      }

      setState(() {
        _generatedModel = model;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _generatedModel = null;
        _error = '❌ Unable to generate model. Check your JSON.';
      });
    }
  }

  String _generateDartModel(String className, dynamic json) {
    final buffer = StringBuffer('class $className {');
    json.forEach((key, value) {
      buffer.writeln('  final ${_getDartType(value)} $key;');
    });
    buffer.write('\n  $className({');
    json.keys.forEach((k) => buffer.write('required this.$k, '));
    buffer.write('});\n}');
    return buffer.toString();
  }

  String _generateJavaModel(String className, dynamic json) {
    final buffer = StringBuffer('public class $className {\n');
    json.forEach((key, value) {
      buffer.writeln('    private ${_getJavaType(value)} $key;');
    });
    buffer.writeln('}');
    return buffer.toString();
  }

  String _generatePythonModel(String className, dynamic json) {
    final buffer = StringBuffer('class $className:\n');
    buffer.writeln('    def __init__(self, ');
    json.forEach((key, value) {
      buffer.write('$key: ${_getPythonType(value)}, ');
    });
    buffer.writeln('):');
    json.forEach((key, value) {
      buffer.writeln('        self.$key = $key');
    });
    return buffer.toString();
  }

  String _generateTsModel(String className, dynamic json) {
    final buffer = StringBuffer('interface $className {\n');
    json.forEach((key, value) {
      buffer.writeln('  $key: ${_getTsType(value)};');
    });
    buffer.writeln('}');
    return buffer.toString();
  }

  String _generateKotlinModel(String className, dynamic json) {
    final buffer = StringBuffer('data class $className(\n');
    json.forEach((key, value) {
      buffer.writeln('    val $key: ${_getKotlinType(value)},');
    });
    buffer.writeln(')');
    return buffer.toString();
  }

  String _generateSwiftModel(String className, dynamic json) {
    final buffer = StringBuffer('struct $className: Codable {\n');
    json.forEach((key, value) {
      buffer.writeln('    let $key: ${_getSwiftType(value)}');
    });
    buffer.writeln('}');
    return buffer.toString();
  }

  String _getDartType(dynamic value) =>
      value is int
          ? 'int'
          : value is double
          ? 'double'
          : value is bool
          ? 'bool'
          : 'String';

  String _getJavaType(dynamic value) =>
      value is int
          ? 'int'
          : value is double
          ? 'double'
          : value is bool
          ? 'boolean'
          : 'String';

  String _getPythonType(dynamic value) =>
      value is int
          ? 'int'
          : value is double
          ? 'float'
          : value is bool
          ? 'bool'
          : 'str';

  String _getTsType(dynamic value) =>
      value is int
          ? 'number'
          : value is double
          ? 'number'
          : value is bool
          ? 'boolean'
          : 'string';

  String _getKotlinType(dynamic value) =>
      value is int
          ? 'Int'
          : value is double
          ? 'Double'
          : value is bool
          ? 'Boolean'
          : 'String';

  String _getSwiftType(dynamic value) =>
      value is int
          ? 'Int'
          : value is double
          ? 'Double'
          : value is bool
          ? 'Bool'
          : 'String';

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
          'JSON Formatter & Model Generator',
          style: TextStyle(color: textColor),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: textColor,
          tabs: const [Tab(text: 'Formatter'), Tab(text: 'Model Generator')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Formatter Page
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _jsonController,
                    maxLines: null,
                    expands: true,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Enter JSON here',
                      labelStyle: TextStyle(color: textColor),
                      filled: true,
                      fillColor: cardColor,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _formatJson,
                  child: const Text('Format & Validate'),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
                if (_formattedJson != null) ...[
                  const SizedBox(height: 10),
                  SelectableText(
                    _formattedJson!,
                    style: TextStyle(color: textColor),
                  ),
                ],
              ],
            ),
          ),

          // Model Generator Page
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _classNameController,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Model Class Name',
                          labelStyle: TextStyle(color: textColor),
                          filled: true,
                          fillColor: cardColor,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: _selectedLanguage,
                      dropdownColor: cardColor,
                      onChanged:
                          (value) => setState(() => _selectedLanguage = value!),
                      items:
                          languages
                              .map(
                                (lang) => DropdownMenuItem(
                                  value: lang,
                                  child: Text(
                                    lang,
                                    style: TextStyle(color: textColor),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _generateModel,
                  child: const Text('Generate Model'),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
                if (_generatedModel != null) ...[
                  const SizedBox(height: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SelectableText(
                        _generatedModel!,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _generatedModel!));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Copied to Clipboard')),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Model'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
