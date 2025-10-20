import 'package:rive/rive.dart';

enum DiscoveredInputType { number, boolean, trigger }

class DiscoveredInput<T> {
  final String name;
  final DiscoveredInputType type;
  final SMIInput<T> ref; // direct handle to the Rive input

  const DiscoveredInput({
    required this.name,
    required this.type,
    required this.ref,
  });
}

/// Type-erased wrapper so we can keep mixed input types in one list.
class AnyDiscoveredInput {
  final String name;
  final DiscoveredInputType type;
  final SMIInput<dynamic> ref;

  const AnyDiscoveredInput({
    required this.name,
    required this.type,
    required this.ref,
  });
}
