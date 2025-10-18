import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:rive/rive.dart';

class RiveCanvas extends StatefulWidget {
  const RiveCanvas({super.key});

  @override
  State<RiveCanvas> createState() => _RiveCanvasState();
}

class _RiveCanvasState extends State<RiveCanvas> {
  Artboard? _artboard;
  RiveAnimationController<dynamic>? _controller;
  String? _stateMachineName; // if we found one

  @override
  void initState() {
    super.initState();
    _loadRive();
  }

  Future<void> _loadRive() async {
    try {
      final bytes = await rootBundle.load('rive/skills.riv');
      final file = RiveFile.import(bytes);
      final artboard = file.mainArtboard;

      // Try to find a state machine first (preferred for our inspector).
      // If none exists, fall back to the first animation.
      RiveAnimationController? controller;

      // Collect state machines via artboard.stateMachines
      final machines = artboard.stateMachines;
      if (machines.isNotEmpty) {
        _stateMachineName = machines.first.name;
        controller = StateMachineController.fromArtboard(
          artboard,
          _stateMachineName!,
        );
        if (controller != null) {
          artboard.addController(controller);
        }
      } else if (artboard.animations.isNotEmpty) {
        controller = SimpleAnimation(artboard.animations.first.name);
        artboard.addController(controller);
      }

      setState(() {
        _artboard = artboard;
        _controller = controller;
      });
    } catch (e) {
      debugPrint('Failed to load Rive: $e');
      if (mounted) {
        setState(() {
          _artboard = null;
          _controller = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_artboard == null) {
      return const Center(child: Text('Loading .riv…'));
    }
    return Stack(
      children: [
        Positioned.fill(
          child: Rive(artboard: _artboard!),
        ),
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
                _stateMachineName != null
                    ? 'State Machine: $_stateMachineName'
                    : 'Animation: ${(_controller is SimpleAnimation) ? ( _artboard!.animations.first.name ) : 'None'}',
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
