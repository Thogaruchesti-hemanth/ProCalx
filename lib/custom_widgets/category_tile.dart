import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/theme_provider.dart';
import '../data.dart'; // Contains categoryIcons and categoryColors

class CategoryTile extends StatelessWidget {
  final String category;
  final double textScaleFactor;

  const CategoryTile({
    super.key,
    required this.category,
    this.textScaleFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    final String emojiIcon = categoryIcons[category] ?? '❓';
    final Color categoryColor =
        categoryColors[category] ??
        (isDarkMode ? const Color(0xFF2D3748) : const Color(0xFF4A5568));

    // Set tile background color based on theme
    final Color tileBackgroundColor =
        isDarkMode
            ? const Color(0xFF1A202C) // Dark tile
            : const Color(0xFFF1F5F9); // Light tile

    return Container(
      decoration: BoxDecoration(color: tileBackgroundColor),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Text(
              emojiIcon,
              style: TextStyle(fontSize: 24 * textScaleFactor),
            ),
          ),
          SizedBox(height: 8 * textScaleFactor),
          Text(
            category,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14 * textScaleFactor,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
