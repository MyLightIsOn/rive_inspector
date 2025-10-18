import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Rive before running the app
  await RiveFile.initialize();

  runApp(const ProviderScope(child: RiveInspectorApp()));
}