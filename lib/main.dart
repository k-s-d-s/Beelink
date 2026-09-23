import 'package:flutter/material.dart';
import 'screens/role_selection_screen.dart';

void main() {
  runApp(const BeeLinkApp());
}

class BeeLinkApp extends StatelessWidget {
  const BeeLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeeLink',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const RoleSelectionScreen(),
    );
  }
}
