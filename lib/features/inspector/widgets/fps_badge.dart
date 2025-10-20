import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/fps_state.dart';

class FpsBadge extends ConsumerWidget {
  const FpsBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fps = ref.watch(fpsProvider);
    final bg = Theme.of(context).colorScheme.secondaryContainer;
    final fg = Theme.of(context).colorScheme.onSecondaryContainer;

    final text = (fps <= 0)
        ? 'FPS'
        : '${fps.isFinite ? fps : 0.0}'.split('.').first + ' FPS';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
