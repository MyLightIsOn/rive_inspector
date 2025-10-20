import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/inspector_state.dart';
import '../state/discovered_input.dart';

class InspectorPanel extends ConsumerWidget {
  const InspectorPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(inspectorProvider);
    final notifier = ref.read(inspectorProvider.notifier);
    final cs = Theme.of(context).colorScheme;

    return ColoredBox(
      color: cs.surfaceVariant.withOpacity(0.35),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const _SectionHeader('State Machine'),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  model.stateMachineName ?? '(none)',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 12,
                    color: cs.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          const _SectionHeader('Inputs'),
          const SizedBox(height: 8),

          if (model.controller == null)
            const Text(
              'No state machine controller found.\n'
                  'Add a state machine to your .riv to enable input controls.',
            )
          else if (model.inputs.isEmpty)
            const Text('State machine has no inputs.')
          else
            ...model.inputs.map((i) {
              switch (i.type) {
                case DiscoveredInputType.boolean:
                  final v = notifier.boolValue(i.name) ?? false;
                  return SwitchListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(i.name),
                    value: v,
                    onChanged: (val) => notifier.setBool(i.name, val),
                  );
                case DiscoveredInputType.number:
                  final v = notifier.numberValue(i.name) ?? 0.0;
                  return _NumberControl(
                    name: i.name,
                    value: v,
                    onChanged: (val) => notifier.setNumber(i.name, val),
                  );
                case DiscoveredInputType.trigger:
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(child: Text(i.name)),
                        ElevatedButton(
                          onPressed: () => notifier.fireTrigger(i.name),
                          child: const Text('Fire'),
                        ),
                      ],
                    ),
                  );
              }
            }),
          const SizedBox(height: 24),

          const _SectionHeader('Properties'),
          const SizedBox(height: 8),
          const Text('Coming soon…'),
        ],
      ),
    );
  }
}

class _NumberControl extends StatefulWidget {
  final String name;
  final double value;
  final ValueChanged<double> onChanged;

  const _NumberControl({
    required this.name,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_NumberControl> createState() => _NumberControlState();
}

class _NumberControlState extends State<_NumberControl> {
  // Heuristic range; Rive inputs don't expose explicit min/max.
  static const double kMin = -100.0;
  static const double kMax = 100.0;

  late double _val;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _val = widget.value.clamp(kMin, kMax);
    _controller.text = _val.toStringAsFixed(2);
  }

  @override
  void didUpdateWidget(covariant _NumberControl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _val = widget.value.clamp(kMin, kMax);
      _controller.text = _val.toStringAsFixed(2);
    }
  }

  void _commitFromText() {
    final text = _controller.text.trim();
    final parsed = double.tryParse(text);
    if (parsed != null) {
      final clamped = parsed.clamp(kMin, kMax);
      setState(() => _val = clamped);
      widget.onChanged(clamped);
    } else {
      // Revert on invalid input
      _controller.text = _val.toStringAsFixed(2);
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.name, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Slider(
            value: _val,
            min: kMin,
            max: kMax,
            onChanged: (v) {
              setState(() => _val = v);
              widget.onChanged(v);
            },
          ),
          Row(
            children: [
              SizedBox(
                width: 96,
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Value',
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                  onSubmitted: (_) => _commitFromText(),
                  onEditingComplete: _commitFromText,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _val.toStringAsFixed(2),
                style: TextStyle(
                  fontFeatures: const [FontFeature.tabularFigures()],
                  color: cs.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: cs.onSurface.withOpacity(0.7),
        letterSpacing: 0.3,
      ),
    );
  }
}
