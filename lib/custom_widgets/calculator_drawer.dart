import 'package:flutter/material.dart';

class CalculatorDrawer extends StatelessWidget {
  final bool isDarkMode;
  final String selectedMenu;
  final List<String> history;
  final Function(String) onSelectMenu;

  const CalculatorDrawer({
    required this.isDarkMode,
    required this.selectedMenu,
    required this.history,
    required this.onSelectMenu,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: isDarkMode ? const Color(0xFF1F1F1F) : const Color(0xFFF8FAFC),
        child: Column(
          children: [
            _buildHeader(),
            _buildDrawerTile(Icons.calculate, 'Calculator', context),
            _buildDrawerTile(
              Icons.swap_horiz_rounded,
              'Unit Converter',
              context,
            ),
            const Divider(),
            _buildHistorySection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 24),
      decoration: BoxDecoration(
        gradient:
            isDarkMode
                ? const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                : const LinearGradient(
                  colors: [Color(0xFFEEF2FF), Color(0xFFE0E7FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor:
                isDarkMode ? Colors.white12 : Colors.indigo.shade100,
            child: Icon(
              Icons.calculate,
              color: isDarkMode ? Colors.white : Colors.indigo,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'SmartCalc',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isDarkMode ? Colors.white70 : Colors.black87),
      title: Text(
        title,
        style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
      ),
      selected: selectedMenu.toLowerCase().contains(title.toLowerCase()),
      onTap: () {
        Navigator.of(context).pop();
        onSelectMenu(title.toLowerCase());
      },
    );
  }

  Widget _buildHistorySection(BuildContext context) {
    return Expanded(
      child:
          history.isEmpty
              ? Center(
                child: Text(
                  'No history yet.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: isDarkMode ? Colors.white54 : Colors.black54,
                  ),
                ),
              )
              : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(
                            history[index],
                            style: TextStyle(
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isDarkMode
                                ? Colors.red.shade700
                                : Colors.red.shade300,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the drawer
                        onSelectMenu('clear_history'); // Trigger callback
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text('Clear History'),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
    );
  }
}
