import 'package:flutter/material.dart';
import 'hive_dashboard_screen.dart';
import 'harvest_logger_screen.dart';
import 'ai_insights_screen.dart';
import 'store_screen.dart';

class BeekeeperMain extends StatefulWidget {
  const BeekeeperMain({super.key});

  @override
  State<BeekeeperMain> createState() => _BeekeeperMainState();
}

class _BeekeeperMainState extends State<BeekeeperMain> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HiveDashboardScreen(),
    const HarvestLoggerScreen(),
    const AiInsightsScreen(),
    const StoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber.shade900,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Hives'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Harvest'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: 'Insights'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Store'),
        ],
      ),
    );
  }
}
