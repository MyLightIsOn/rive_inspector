import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/inspector_state.dart';
import '../state/discovered_input.dart';

class InspectorPanel extends ConsumerWidget {
  const InspectorPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(inspectorProvider);

    return ColoredBox(
      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.35),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
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
            ...model.inputs.map(
                  (i) => ListTile(
                dense: true,
                title: Text(i.name),
                subtitle: Text(_labelFor(i.type)),
              ),
            ),
          const SizedBox(height: 24),
          const _SectionHeader('Properties'),
          const SizedBox(height: 8),
          const Text('Coming soon…'),
        ],
      ),
    );
  }

  static String _labelFor(DiscoveredInputType t) {
    switch (t) {
      case DiscoveredInputType.boolean:
        return 'Boolean';
      case DiscoveredInputType.number:
        return 'Number';
      case DiscoveredInputType.trigger:
        return 'Trigger';
    }
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
