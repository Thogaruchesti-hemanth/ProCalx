import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_calculator/provider/theme_provider.dart';

import 'custom_widgets/category_tile.dart';
import 'custom_widgets/search_bar.dart';
import 'custom_widgets/subcategory_section.dart';
import 'data.dart';

class UnitConverter extends StatefulWidget {
  const UnitConverter({super.key});

  @override
  _UnitConverterState createState() => _UnitConverterState();
}

class _UnitConverterState extends State<UnitConverter> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // ✅ Use GlobalObjectKey to ensure uniqueness and avoid duplication error
  final Map<String, GlobalKey> _categoryKeys = {};
  final Map<String, Map<String, GlobalKey>> _subcategoryKeys = {};

  String _selectedCategory = '';

  List<String> get _filteredCategories {
    if (_searchController.text.isEmpty) return subcategoryMap.keys.toList();
    return subcategoryMap.keys
        .where(
          (cat) =>
              cat.toLowerCase().contains(_searchController.text.toLowerCase()),
        )
        .toList();
  }

  List<String> get _filteredSubcategories {
    String searchQuery = _searchController.text.toLowerCase();
    List<String> filteredSubcategories = [];

    for (String category in subcategoryMap.keys) {
      List<String> subcategoriesForCategory = subcategoryMap[category]!;
      filteredSubcategories.addAll(
        subcategoriesForCategory.where(
          (sub) => sub.toLowerCase().contains(searchQuery),
        ),
      );
    }

    return filteredSubcategories;
  }

  @override
  void initState() {
    super.initState();

    for (String category in subcategoryMap.keys) {
      _categoryKeys[category] = GlobalObjectKey('category::$category');
      _subcategoryKeys[category] = {};
      for (String subcat in subcategoryMap[category]!) {
        _subcategoryKeys[category]![subcat] = GlobalObjectKey(
          'subcat::$category::$subcat',
        );
      }
    }
  }

  void _scrollToCategory(String category) {
    final firstSubcategory = subcategoryMap[category]?.first;
    if (firstSubcategory != null) {
      final keyContext =
          _subcategoryKeys[category]?[firstSubcategory]?.currentContext;
      if (keyContext != null) {
        Scrollable.ensureVisible(
          keyContext,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        return;
      }
    }
    final categoryContext = _categoryKeys[category]?.currentContext;
    if (categoryContext != null) {
      Scrollable.ensureVisible(
        categoryContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _scrollToSubcategory(String subcategory) {
    for (var entry in _subcategoryKeys.entries) {
      if (entry.value.containsKey(subcategory)) {
        final keyContext = entry.value[subcategory]!.currentContext;
        if (keyContext != null) {
          Scrollable.ensureVisible(
            keyContext,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth < 600 ? 3 : 5;
    Color backgroundColor =
        isDarkMode ? const Color(0xFF121212) : const Color(0xFFF3F4F6);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SearchBarWidget(
                controller: _searchController,
                onChanged: () {
                  setState(() {});
                  String query = _searchController.text;
                  for (String category in subcategoryMap.keys) {
                    for (String subcategory in subcategoryMap[category]!) {
                      if (subcategory.toLowerCase().contains(
                        query.toLowerCase(),
                      )) {
                        _scrollToSubcategory(subcategory);
                        return;
                      }
                    }
                  }
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 1,
                        crossAxisSpacing: screenWidth * 0.03,
                        mainAxisSpacing: screenWidth * 0.03,
                      ),
                      itemCount: _filteredCategories.length,
                      itemBuilder: (context, index) {
                        String category = _filteredCategories[index];
                        final theme = Theme.of(context);

                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                theme.colorScheme.surface,
                                theme.colorScheme.surface.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.primary.withOpacity(
                                  0.05,
                                ),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() => _selectedCategory = category);
                                _scrollToCategory(category);
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: CategoryTile(category: category),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    ...subcategoryMap.entries.map((entry) {
                      final category = entry.key;
                      final keyToPass = _categoryKeys[category];
                      return SubcategorySection(
                        key: keyToPass,
                        category: category,
                        searchText: _searchController.text,
                        firstSubcategoryKey: keyToPass,
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
