import 'package:flutter/material.dart';

class FpsBadge extends StatelessWidget {
  final double? fps; // null = placeholder
  const FpsBadge({super.key, this.fps});

  @override
  Widget build(BuildContext context) {
    final bg = Theme.of(context).colorScheme.secondaryContainer;
    final fg = Theme.of(context).colorScheme.onSecondaryContainer;
    final text = fps == null ? 'FPS' : '${fps!.toStringAsFixed(0)} FPS';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}
