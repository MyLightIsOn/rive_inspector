// lib/app/app.dart
import 'package:flutter/material.dart';
import 'theme.dart';
import '../utils/layout.dart';
import '../features/inspector/widgets/rive_canvas.dart';
import '../features/inspector/widgets/inspector_panel.dart';
import '../features/inspector/widgets/transport_bar.dart';
import '../features/inspector/widgets/fps_badge.dart';

class RiveInspectorApp extends StatelessWidget {
  const RiveInspectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Rive Inspector',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      home: const _HomeScaffold(),
    );
  }
}

class _HomeScaffold extends StatelessWidget {
  const _HomeScaffold();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: const [
            SizedBox(width: 12),
            Text('Mini Rive Inspector'),
            Spacer(),
            FpsBadge(), // placeholder until Step 7
            SizedBox(width: 12),
          ],
        ),
      ),
      body: SplitView(
        left: const RiveCanvas(),
        right: const InspectorPanel(),
      ),
      bottomNavigationBar: const SafeArea(child: TransportBar()),
    );
  }
}
