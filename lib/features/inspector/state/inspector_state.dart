import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import 'discovered_input.dart';

/// Immutable UI/model state for the inspector.
class InspectorModel {
  final Artboard? artboard;
  final String? stateMachineName;
  final StateMachineController? controller;
  final List<AnyDiscoveredInput> inputs;

  const InspectorModel({
    required this.artboard,
    required this.stateMachineName,
    required this.controller,
    required this.inputs,
  });

  const InspectorModel.initial()
      : artboard = null,
        stateMachineName = null,
        controller = null,
        inputs = const [];

  InspectorModel copyWith({
    Artboard? artboard,
    String? stateMachineName,
    StateMachineController? controller,
    List<AnyDiscoveredInput>? inputs,
  }) {
    return InspectorModel(
      artboard: artboard ?? this.artboard,
      stateMachineName: stateMachineName ?? this.stateMachineName,
      controller: controller ?? this.controller,
      inputs: inputs ?? this.inputs,
    );
  }
}

/// Riverpod v2: use Notifier<T> instead of StateNotifier<T>.
class InspectorNotifier extends Notifier<InspectorModel> {
  @override
  InspectorModel build() => const InspectorModel.initial();

  /// Load artboard/controller and discover inputs from the controller (if any).
  void loadFromArtboard({
    required Artboard? artboard,
    String? stateMachineName,
    required StateMachineController? controller,
  }) {
    final discovered = <AnyDiscoveredInput>[];

    if (controller != null) {
      for (final input in controller.inputs) {
        if (input is SMITrigger) {
          discovered.add(AnyDiscoveredInput(
            name: input.name,
            type: DiscoveredInputType.trigger,
            ref: input,
          ));
        } else if (input is SMIInput<bool>) {
          discovered.add(AnyDiscoveredInput(
            name: input.name,
            type: DiscoveredInputType.boolean,
            ref: input,
          ));
        } else if (input is SMIInput<double>) {
          discovered.add(AnyDiscoveredInput(
            name: input.name,
            type: DiscoveredInputType.number,
            ref: input,
          ));
        }
      }
    }

    state = state.copyWith(
      artboard: artboard,
      stateMachineName: stateMachineName,
      controller: controller,
      inputs: discovered,
    );
  }
}

/// Riverpod v2 provider for the inspector.
final inspectorProvider =
NotifierProvider<InspectorNotifier, InspectorModel>(InspectorNotifier.new);
