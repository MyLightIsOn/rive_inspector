// lib/app/app.dart
import 'package:flutter/material.dart';
import 'theme.dart';

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
      appBar: AppBar(title: const Text('Mini Rive Inspector')),
      body: Row(
        children: const [
          Expanded(
            child: ColoredBox(
              color: Colors.black12,
              child: Center(child: Text('Canvas', style: TextStyle(fontSize: 18))),
            ),
          ),
          SizedBox(
            width: 340,
            child: ColoredBox(
              color: Color(0xFFF7F7F7),
              child: Center(child: Text('Inspector Panel', style: TextStyle(fontSize: 16))),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 56,
          alignment: Alignment.center,
          child: const Text('Transport Bar'),
        ),
      ),
    );
  }
}
