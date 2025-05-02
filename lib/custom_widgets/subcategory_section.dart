import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/theme_provider.dart';
import '../data.dart';
import 'subcategory_tile.dart';

class SubcategorySection extends StatelessWidget {
  final String category;
  final String searchText;

  const SubcategorySection({required this.category, required this.searchText});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    final subcategories = subcategoryMap[category] ?? [];

    if (!subcategories.any(
          (e) => e.toLowerCase().contains(searchText.toLowerCase()),
        ) &&
        searchText.isNotEmpty) {
      return Container();
    }

    return Container(
      // key: subcategoryKeys[category]?[subcategories],
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children:
                subcategories
                    .map(
                      (subcat) => SubcategoryTile(
                        subcategory: subcat,
                        searchText: searchText,
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}
