import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import 'discovered_input.dart';

/// Immutable UI/model state for the inspector.
class InspectorModel {
  final Artboard? artboard;
  final String? stateMachineName;
  final StateMachineController? controller; // null or StateMachineController
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

/// Riverpod v2: use Notifier<T>.
class InspectorNotifier extends Notifier<InspectorModel> {
  // Handle to whichever controller is active for the artboard:
  // either a StateMachineController or a SimpleAnimation.
  RiveAnimationController? _activeController;

  // Since newer rive runtimes don’t expose SimpleAnimation.speed,
  // we track a local “desired speed” and (optionally) use it when
  // we implement a custom advance loop later.
  double _speed = 1.0;

  @override
  InspectorModel build() => const InspectorModel.initial();

  /// Called by the canvas after it loads the artboard + controller.
  void loadFromArtboard({
    required Artboard? artboard,
    String? stateMachineName,
    required StateMachineController? controller,
    RiveAnimationController? activeController,
  }) {
    _activeController = activeController ?? controller;

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

  // ============ Playback helpers (Step 6) ============

  bool get hasController => _activeController != null;

  bool get isStateMachine => _activeController is StateMachineController;
  bool get isSimpleAnimation => _activeController is SimpleAnimation;

  /// Play/pause mirrors the controller's active state.
  bool get isPlaying => _activeController?.isActive ?? false;

  void play() {
    final c = _activeController;
    if (c == null) return;
    c.isActive = true;
    state = state.copyWith(); // notify UI
  }

  void pause() {
    final c = _activeController;
    if (c == null) return;
    c.isActive = false;
    state = state.copyWith();
  }

  /// Restart:
  /// - SimpleAnimation: reset() and play
  /// - StateMachine: deactivate/activate to re-enter default state
  void restart() {
    final c = _activeController;
    if (c == null) return;

    if (c is SimpleAnimation) {
      c.reset();
      c.isActive = true;
    } else {
      c.isActive = false;
      c.isActive = true;
    }
    state.artboard?.advance(0); // force a render tick
    state = state.copyWith();
  }

  /// UI-facing speed value (SimpleAnimation only).
  /// Note: With recent rive versions, there is no built-in SimpleAnimation.speed.
  /// We track a local value for UI and (optionally) to scale time in a custom loop.
  double? get speed {
    final c = _activeController;
    if (c is SimpleAnimation) return _speed;
    return null;
  }

  void setSpeed(double value) {
    final c = _activeController;
    if (c is SimpleAnimation) {
      _speed = value.clamp(0.0, 2.0);
      // If you implement a custom frame advance, multiply elapsedSeconds by _speed.
      state = state.copyWith();
    }
  }

  /// Scrub support (SimpleAnimation only): [0,1] normalized progress.
  double? get normalizedProgress {
    final c = _activeController;
    if (c is SimpleAnimation) {
      final inst = c.instance;
      final duration = inst?.animation.duration ?? 0;
      final time = inst?.time ?? 0;
      if (duration <= 0) return 0;
      final p = (time / duration).clamp(0.0, 1.0);
      return p;
    }
    return null; // not applicable for state machines
  }

  void setNormalizedProgress(double p) {
    final c = _activeController;
    if (c is SimpleAnimation) {
      final inst = c.instance;
      final duration = inst?.animation.duration ?? 0;
      if (inst != null && duration > 0) {
        inst.time = (p.clamp(0.0, 1.0)) * duration;
        // Pause while scrubbing so it sticks where the user puts it.
        c.isActive = false;
        // Force a render without advancing time.
        state.artboard?.advance(0);
        state = state.copyWith();
      }
    }
  }

  // ------- Inputs helpers (Step 5) -------

  AnyDiscoveredInput? _find(String name) {
    for (final i in state.inputs) {
      if (i.name == name) return i;
    }
    return null;
  }

  bool? boolValue(String name) {
    final i = _find(name)?.ref;
    if (i is SMIInput<bool>) return i.value;
    return null;
  }

  double? numberValue(String name) {
    final i = _find(name)?.ref;
    if (i is SMIInput<double>) return i.value;
    return null;
  }

  void setBool(String name, bool v) {
    final i = _find(name)?.ref;
    if (i is SMIInput<bool>) {
      i.value = v;
      state = state.copyWith();
    }
  }

  void setNumber(String name, double v) {
    final i = _find(name)?.ref;
    if (i is SMIInput<double>) {
      i.value = v;
      state = state.copyWith();
    }
  }

  void fireTrigger(String name) {
    final i = _find(name)?.ref;
    if (i is SMITrigger) {
      i.fire();
      state = state.copyWith();
    }
  }
}

/// Riverpod v2 provider for the inspector.
final inspectorProvider =
NotifierProvider<InspectorNotifier, InspectorModel>(InspectorNotifier.new);
