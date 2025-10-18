import 'package:flutter/material.dart';

class TransportBar extends StatelessWidget {
  const TransportBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surface,
      elevation: 1,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            const SizedBox(width: 8),
            IconButton(onPressed: null, icon: const Icon(Icons.play_arrow)),
            IconButton(onPressed: null, icon: const Icon(Icons.pause)),
            IconButton(onPressed: null, icon: const Icon(Icons.replay)),
            const VerticalDivider(width: 12, indent: 12, endIndent: 12),
            const Expanded(
              child: Slider(value: 0, onChanged: null), // timeline scrub (disabled for now)
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
