import 'package:flutter/material.dart';

class CalculatorAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const CalculatorAppBar({
    required this.scaffoldKey,
    required this.isDarkMode,
    required this.onToggleTheme,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : const Color(0xFFF3F4F6),
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: isDarkMode ? Colors.white70 : Colors.black87,
        ),
        onPressed: () => scaffoldKey.currentState?.openDrawer(),
      ),
      actions: [
        IconButton(
          icon: Icon(
            isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: isDarkMode ? Colors.white70 : Colors.black87,
          ),
          onPressed: onToggleTheme,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
