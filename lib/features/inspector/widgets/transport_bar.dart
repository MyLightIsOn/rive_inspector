import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/inspector_state.dart';

class TransportBar extends ConsumerWidget {
  const TransportBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(inspectorProvider);
    final ctrl = ref.read(inspectorProvider.notifier);

    final cs = Theme.of(context).colorScheme;
    final isSM = ctrl.isStateMachine;
    final isAnim = ctrl.isSimpleAnimation;
    final playing = ctrl.isPlaying;

    return Material(
      color: cs.surface,
      elevation: 1,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            const SizedBox(width: 8),

            IconButton(
              tooltip: 'Play',
              onPressed: ctrl.hasController && !playing ? ctrl.play : null,
              icon: const Icon(Icons.play_arrow),
            ),
            IconButton(
              tooltip: 'Pause',
              onPressed: ctrl.hasController && playing ? ctrl.pause : null,
              icon: const Icon(Icons.pause),
            ),
            IconButton(
              tooltip: 'Restart',
              onPressed: ctrl.hasController ? ctrl.restart : null,
              icon: const Icon(Icons.replay),
            ),

            const VerticalDivider(width: 12, indent: 12, endIndent: 12),

            // Scrubber (SimpleAnimation only)
            Expanded(
              child: isAnim
                  ? _Scrubber()
                  : Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  isSM
                      ? 'State Machine (no timeline)'
                      : 'No animation loaded',
                  style: TextStyle(
                    color: cs.onSurface.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Speed (SimpleAnimation only)
            if (isAnim)
              Row(
                children: [
                  const Text('Speed', style: TextStyle(fontSize: 12)),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 160,
                    child: _SpeedSlider(),
                  ),
                ],
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  'x1',
                  style: TextStyle(
                    color: cs.onSurface.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
              ),

            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class _Scrubber extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(inspectorProvider.notifier);
    final progress = ref.watch(inspectorProvider.select(
          (_) => notifier.normalizedProgress ?? 0.0,
    ));

    return Slider(
      value: progress,
      min: 0,
      max: 1,
      onChanged: (v) => notifier.setNormalizedProgress(v),
    );
  }
}

class _SpeedSlider extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(inspectorProvider.notifier);
    final speed = ref.watch(inspectorProvider.select(
          (_) => notifier.speed ?? 1.0,
    ));

    return Slider(
      value: speed.clamp(0.0, 2.0),
      min: 0.0,
      max: 2.0,
      divisions: 20,
      label: 'x${speed.toStringAsFixed(2)}',
      onChanged: (v) => notifier.setSpeed(v),
    );
  }
}
