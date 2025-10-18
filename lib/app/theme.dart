import 'package:flutter/material.dart';

ThemeData buildTheme(Brightness brightness) {
  final base = ThemeData(
    colorSchemeSeed: const Color(0xFF6C7AF0),
    useMaterial3: true,
    brightness: brightness,
  );
  return base.copyWith(
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: base.colorScheme.surface,
      foregroundColor: base.colorScheme.onSurface,
    ),
  );
}
