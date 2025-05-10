import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/theme_provider.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search subCategories...',
        filled: true,
        fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: isDarkMode ? Colors.white70 : Colors.grey,
        ),
      ),
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      onChanged: (_) => onChanged(),
    );
  }
}
