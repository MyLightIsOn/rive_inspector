import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import '../state/inspector_state.dart';

class RiveCanvas extends ConsumerStatefulWidget {
  const RiveCanvas({super.key});

  @override
  ConsumerState<RiveCanvas> createState() => _RiveCanvasState();
}

class _RiveCanvasState extends ConsumerState<RiveCanvas> {
  Artboard? _artboard;
  RiveAnimationController? _controller;
  String? _stateMachineName;

  @override
  void initState() {
    super.initState();
    _loadRive();
  }

  Future<void> _loadRive() async {
    try {
      final data = await rootBundle.load('/rive/vehicles.riv');
      final file = RiveFile.import(data);
      final artboard = file.mainArtboard;

      RiveAnimationController? controller;
      String? smName;

      // Prefer a state machine if available; otherwise fall back to first animation.
      final machines = artboard.stateMachines;
      if (machines.isNotEmpty) {
        smName = machines.first.name;
        final smController = StateMachineController.fromArtboard(artboard, smName);
        if (smController != null) {
          artboard.addController(smController);
          controller = smController;
        }
      } else if (artboard.animations.isNotEmpty) {
        final anim = SimpleAnimation(artboard.animations.first.name);
        artboard.addController(anim);
        controller = anim;
      }

      setState(() {
        _artboard = artboard;
        _controller = controller;
        _stateMachineName = smName;
      });

      // Publish to provider (only pass a StateMachineController if we actually have one)
      StateMachineController? smForProvider;
      if (controller is StateMachineController) {
        smForProvider = controller;
      }

      ref.read(inspectorProvider.notifier).loadFromArtboard(
        artboard: artboard,
        stateMachineName: smName,
        controller: smForProvider,
      );
    } catch (e) {
      debugPrint('Failed to load Rive: $e');
      setState(() {
        _artboard = null;
        _controller = null;
        _stateMachineName = null;
      });
      ref.read(inspectorProvider.notifier).loadFromArtboard(
        artboard: null,
        stateMachineName: null,
        controller: null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_artboard == null) {
      return const Center(child: Text('Loading .riv…'));
    }
    return Stack(
      children: [
        Positioned.fill(child: Rive(artboard: _artboard!)),
        if (_stateMachineName != null)
          Positioned(
            left: 12,
            bottom: 12,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Text(
                  'State Machine: $_stateMachineName',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
