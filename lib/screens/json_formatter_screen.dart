// ignore_for_file: prefer_final_fields, use_key_in_widget_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

class JsonFormatterScreen extends StatefulWidget {
  final bool isDarkMode;
  const JsonFormatterScreen({required this.isDarkMode});

  @override
  State<JsonFormatterScreen> createState() => _JsonFormatterScreenState();
}

class _JsonFormatterScreenState extends State<JsonFormatterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _jsonController = TextEditingController();
  final TextEditingController _classNameController = TextEditingController();

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
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _jsonController.text =
        '{\n  "user": {\n    "id": 1,\n    "name": "Alice",\n    "contact": {\n      "email": "alice@example.com",\n      "phone": "123-456-7890"\n    },\n    "roles": [\n      "admin",\n      "editor"\n    ]\n  }\n}';
  }

  void _formatJson() {
    try {
      final jsonObject = jsonDecode(_jsonController.text);
      final prettyJson = const JsonEncoder.withIndent('  ').convert(jsonObject);
      setState(() {
        _jsonController.text = prettyJson;
        _error = null;
      });
    } catch (e) {
      setState(() {
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

      String model = switch (_selectedLanguage) {
        'Dart' => _generateDartModel(className, decoded),
        'Java' => _generateJavaModel(className, decoded),
        'Kotlin' => _generateKotlinModel(className, decoded),
        'Python' => _generatePythonModel(className, decoded),
        'TypeScript' => _generateTsModel(className, decoded),
        'Swift' => _generateSwiftModel(className, decoded),
        _ => '',
      };

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
    final classes = <String>[];

    void generate(String name, Map<String, dynamic> obj) {
      final buf = StringBuffer();
      buf.writeln('class $name {');

      obj.forEach((key, val) {
        final type = _getDartType(val, key);
        buf.writeln('  final $type $key;');
      });

      buf.write('\n  $name({');
      obj.keys.forEach((k) => buf.write('required this.$k, '));
      buf.writeln('});\n');

      // fromJson factory
      buf.writeln(
        '  factory $name.fromJson(Map<String, dynamic> json) => $name(',
      );
      obj.forEach((key, val) {
        if (val is Map<String, dynamic>) {
          final sub = _capitalize(key);
          generate(sub, val);
          buf.writeln('    $key: $sub.fromJson(json["$key"]),');
        } else if (val is List &&
            val.isNotEmpty &&
            val.first is Map<String, dynamic>) {
          final sub = _capitalize(key);
          generate(sub, val.first);
          buf.writeln(
            '    $key: List<$sub>.from(json["$key"].map((x) => $sub.fromJson(x))),',
          );
        } else {
          buf.writeln('    $key: json["$key"],');
        }
      });
      buf.writeln('  );\n');

      // toJson method
      buf.writeln('  Map<String, dynamic> toJson() => {');
      obj.forEach((key, val) {
        if (val is Map<String, dynamic>) {
          buf.writeln('    "$key": $key.toJson(),');
        } else if (val is List &&
            val.isNotEmpty &&
            val.first is Map<String, dynamic>) {
          buf.writeln(
            '    "$key": List<dynamic>.from($key.map((x) => x.toJson())),',
          );
        } else {
          buf.writeln('    "$key": $key,');
        }
      });
      buf.writeln('  };\n');

      buf.writeln('}\n');
      classes.insert(0, buf.toString());
    }

    // Start generating from the root
    if (json is List && json.isNotEmpty && json.first is Map<String, dynamic>) {
      json = json.first as Map<String, dynamic>;
    }
    if (json is Map<String, dynamic>) {
      generate(className, json);
      return classes.join('\n');
    } else {
      return '// Invalid JSON structure';
    }
  }

  /// Helper to capitalize class names
  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  /// Modified type-mapper to use key names for nested types
  String _getDartType(dynamic val, String key) {
    if (val is int) return 'int';
    if (val is double) return 'double';
    if (val is bool) return 'bool';
    if (val is List) {
      if (val.isNotEmpty && val.first is Map<String, dynamic>) {
        return 'List<${_capitalize(key)}>';
      }
      return 'List<dynamic>';
    }
    if (val is Map<String, dynamic>) {
      return _capitalize(key);
    }
    return 'String';
  }

  String _generateJavaModel(String className, dynamic json) {
    if (json is List && json.isNotEmpty && json.first is Map<String, dynamic>) {
      json = json.first;
    }
    if (json is! Map<String, dynamic>) return '// Invalid JSON structure';

    final buffer = StringBuffer('public class $className {\n');
    json.forEach((key, value) {
      buffer.writeln('    private ${_getJavaType(value)} $key;');
    });
    buffer.writeln('}');
    return buffer.toString();
  }

  String _generatePythonModel(String className, dynamic json) {
    if (json is List && json.isNotEmpty && json.first is Map<String, dynamic>) {
      json = json.first;
    }
    if (json is! Map<String, dynamic>) return '# Invalid JSON structure';

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
    if (json is List && json.isNotEmpty && json.first is Map<String, dynamic>) {
      json = json.first;
    }
    if (json is! Map<String, dynamic>) return '// Invalid JSON structure';

    final buffer = StringBuffer('interface $className {\n');
    json.forEach((key, value) {
      buffer.writeln('  $key: ${_getTsType(value)};');
    });
    buffer.writeln('}');
    return buffer.toString();
  }

  String _generateKotlinModel(String className, dynamic json) {
    if (json is List && json.isNotEmpty && json.first is Map<String, dynamic>) {
      json = json.first;
    }
    if (json is! Map<String, dynamic>) return '// Invalid JSON structure';

    final buffer = StringBuffer('data class $className(\n');
    json.forEach((key, value) {
      buffer.writeln('    val $key: ${_getKotlinType(value)},');
    });
    buffer.writeln(')');
    return buffer.toString();
  }

  String _generateSwiftModel(String className, dynamic json) {
    if (json is List && json.isNotEmpty && json.first is Map<String, dynamic>) {
      json = json.first;
    }
    if (json is! Map<String, dynamic>) return '// Invalid JSON structure';

    final buffer = StringBuffer('struct $className: Codable {\n');
    json.forEach((key, value) {
      buffer.writeln('    let $key: ${_getSwiftType(value)}');
    });
    buffer.writeln('}');
    return buffer.toString();
  }

  String _getJavaType(dynamic value) {
    if (value is int) return 'int';
    if (value is double) return 'double';
    if (value is bool) return 'boolean';
    if (value is List) return 'List<Object>';
    if (value is Map) return 'Map<String, Object>';
    return 'String';
  }

  String _getPythonType(dynamic value) {
    if (value is int) return 'int';
    if (value is double) return 'float';
    if (value is bool) return 'bool';
    if (value is List) return 'list';
    if (value is Map) return 'dict';
    return 'str';
  }

  String _getTsType(dynamic value) {
    if (value is int || value is double) return 'number';
    if (value is bool) return 'boolean';
    if (value is List) return 'any[]';
    if (value is Map) return 'Record<string, any>';
    return 'string';
  }

  String _getKotlinType(dynamic value) {
    if (value is int) return 'Int';
    if (value is double) return 'Double';
    if (value is bool) return 'Boolean';
    if (value is List) return 'List<Any>';
    if (value is Map) return 'Map<String, Any>';
    return 'String';
  }

  String _getSwiftType(dynamic value) {
    if (value is int) return 'Int';
    if (value is double) return 'Double';
    if (value is bool) return 'Bool';
    if (value is List) return '[Any]';
    if (value is Map) return '[String: Any]';
    return 'String';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _jsonController.dispose();
    _classNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final bgColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final cardColor = isDark ? Colors.grey[900] : Colors.grey[100];

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
          isScrollable: true,
          tabs: const [Tab(text: 'Formatter'), Tab(text: 'Model Generator')],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      TextField(
                        controller: _jsonController,
                        maxLines: null,
                        expands: true,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          labelText: 'Enter or Paste JSON here',
                          labelStyle: TextStyle(color: textColor),
                          filled: true,
                          fillColor: cardColor,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        color: textColor,
                        tooltip: 'Copy JSON',
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: _jsonController.text),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Copied JSON to Clipboard'),
                            ),
                          );
                        },
                      ),
                    ],
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
              ],
            ),
          ),
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
                          border: const OutlineInputBorder(),
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
                    child: HighlightView(
                      _generatedModel!,
                      language: _selectedLanguage.toLowerCase(),
                      theme: monokaiSublimeTheme,
                      padding: const EdgeInsets.all(12),
                      textStyle: const TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 14,
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
