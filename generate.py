import os

files = {
    'lib/main.dart': '''import \\'package:flutter/material.dart\\';
import \\'screens/role_selection_screen.dart\\';

void main() {
  runApp(const BeeLinkApp());
}

class BeeLinkApp extends StatelessWidget {
  const BeeLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: \\'BeeLink\\',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const RoleSelectionScreen(),
    );
  }
}
''',
    'lib/screens/role_selection_screen.dart': '''import \\'package:flutter/material.dart\\';
import \\'beekeeper/beekeeper_main.dart\\';
import \\'consumer/consumer_main.dart\\';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(\\'Welcome to BeeLink\\')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BeekeeperMain())),
              child: const Text(\\'I am a Beekeeper\\'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConsumerMain())),
              child: const Text(\\'I am a Consumer\\'),
            ),
          ],
        ),
      ),
    );
  }
}
''',
    'lib/screens/beekeeper/beekeeper_main.dart': '''import \\'package:flutter/material.dart\\';
import \\'hive_dashboard_screen.dart\\';
import \\'harvest_logger_screen.dart\\';
import \\'ai_insights_screen.dart\\';
import \\'store_screen.dart\\';

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
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: \\'Hives\\'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: \\'Harvest\\'),
          BottomNavigationBarItem(icon: Icon(Icons.lightbulb), label: \\'Insights\\'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: \\'Store\\'),
        ],
      ),
    );
  }
}
''',
    'lib/screens/beekeeper/hive_dashboard_screen.dart': '''import \\'package:flutter/material.dart\\';

class HiveDashboardScreen extends StatelessWidget {
  const HiveDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(\\'Hive Dashboard\\')),
      body: const Center(child: Text(\\'Hive Dashboard - TODO\\')),
    );
  }
}
''',
    'lib/screens/beekeeper/harvest_logger_screen.dart': '''import \\'package:flutter/material.dart\\';

class HarvestLoggerScreen extends StatelessWidget {
  const HarvestLoggerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(\\'Harvest Logger\\')),
      body: const Center(child: Text(\\'Harvest Logger - TODO\\')),
    );
  }
}
''',
    'lib/screens/beekeeper/ai_insights_screen.dart': '''import \\'package:flutter/material.dart\\';

class AiInsightsScreen extends StatelessWidget {
  const AiInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(\\'AI Insights\\')),
      body: const Center(child: Text(\\'AI Insights - TODO\\')),
    );
  }
}
''',
    'lib/screens/beekeeper/store_screen.dart': '''import \\'package:flutter/material.dart\\';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(\\'My Store\\')),
      body: const Center(child: Text(\\'Store - TODO\\')),
    );
  }
}
''',
    'lib/screens/consumer/consumer_main.dart': '''import \\'package:flutter/material.dart\\';
import \\'qr_scanner_screen.dart\\';
import \\'marketplace_screen.dart\\';
import \\'order_tracking_screen.dart\\';

class ConsumerMain extends StatefulWidget {
  const ConsumerMain({super.key});

  @override
  State<ConsumerMain> createState() => _ConsumerMainState();
}

class _ConsumerMainState extends State<ConsumerMain> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const QrScannerScreen(),
    const MarketplaceScreen(),
    const OrderTrackingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: \\'Scanner\\'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: \\'Marketplace\\'),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping), label: \\'Orders\\'),
        ],
      ),
    );
  }
}
''',
    'lib/screens/consumer/qr_scanner_screen.dart': '''import \\'package:flutter/material.dart\\';

class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(\\'Scan QR Code\\')),
      body: const Center(child: Text(\\'QR Scanner - TODO\\')),
    );
  }
}
''',
    'lib/screens/consumer/marketplace_screen.dart': '''import \\'package:flutter/material.dart\\';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(\\'Marketplace\\')),
      body: const Center(child: Text(\\'Marketplace - TODO\\')),
    );
  }
}
''',
    'lib/screens/consumer/order_tracking_screen.dart': '''import \\'package:flutter/material.dart\\';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(\\'My Orders\\')),
      body: const Center(child: Text(\\'Orders - TODO\\')),
    );
  }
}
'''
}

for path, content in files.items():
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, 'w') as f:
        f.write(content)
