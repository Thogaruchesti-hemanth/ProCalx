import 'package:flutter/material.dart';

class CalculatorDrawer extends StatelessWidget {
  final bool isDarkMode;
  final List<String> history;
  final VoidCallback onClearHistory;

  const CalculatorDrawer({
    super.key,
    required this.isDarkMode,
    required this.history,
    required this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: isDarkMode ? const Color(0xFF1F1F1F) : const Color(0xFFF8FAFC),
        child: Column(
          children: [_buildHeader(), _buildHistorySection(context)],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(left: 16, top: 80, bottom: 24),
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
            'ProCalx',
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
                        Navigator.of(context).pop(); // Close drawer
                        onClearHistory(); // Clear callback
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
