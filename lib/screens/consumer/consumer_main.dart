import 'package:flutter/material.dart';
import 'qr_scanner_screen.dart';
import 'marketplace_screen.dart';
import 'order_tracking_screen.dart';

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
          BottomNavigationBarItem(icon: Icon(Icons.qr_code_scanner), label: 'Scanner'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Marketplace'),
          BottomNavigationBarItem(icon: Icon(Icons.local_shipping), label: 'Orders'),
        ],
      ),
    );
  }
}
