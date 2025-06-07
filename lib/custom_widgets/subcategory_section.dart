import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data.dart';
import '../provider/theme_provider.dart';
import 'subcategory_tile.dart'; // Your provided SubcategoryTile widget

class SubcategorySection extends StatelessWidget {
  final String category;
  final String searchText;
  final Key? firstSubcategoryKey;

  const SubcategorySection({
    Key? key,
    required this.category,
    required this.searchText,
    this.firstSubcategoryKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Assume subcategoryMap is accessible globally or injected somehow
    final List<String> subcategories = subcategoryMap[category] ?? [];
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    // Filter subcategories based on search text
    final List<String> filteredSubcategories =
        subcategories
            .where(
              (subcat) =>
                  subcat.toLowerCase().contains(searchText.toLowerCase()),
            )
            .toList();

    if (filteredSubcategories.isEmpty) {
      return const SizedBox.shrink(); // Don't display empty sections
    }

    return Column(
      key: Key('section_$category'), // Add key for category section
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Title
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            category,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),

        // Subcategory list
        ListView.builder(
          key:
              firstSubcategoryKey, // Use key for scrolling to first subcategory
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredSubcategories.length,
          itemBuilder: (context, index) {
            final subcategory = filteredSubcategories[index];

            return SubcategoryTile(
              key: Key('subcat_${category}_$subcategory'),
              subcategory: subcategory,
              searchText: searchText,
            );
          },
        ),
      ],
    );
  }
}
