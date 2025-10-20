import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Simple moving-average FPS calculator over the last N frames.
/// Holds the current FPS as Riverpod state (double).
class FpsNotifier extends Notifier<double> {
  static const int _window = 60; // last 60 frames
  final List<double> _dts = <double>[];
  double _sum = 0.0;

  @override
  double build() => 0.0;

  /// Call this once per frame with the elapsed seconds since the previous frame.
  void onTick(double dtSeconds) {
    if (dtSeconds.isNaN || dtSeconds.isInfinite || dtSeconds <= 0) return;
    _dts.add(dtSeconds);
    _sum += dtSeconds;
    if (_dts.length > _window) {
      _sum -= _dts.removeAt(0);
    }
    final count = _dts.length;
    if (count == 0 || _sum <= 0) {
      state = 0.0;
    } else {
      final avg = _sum / count;
      state = 1.0 / avg; // frames per second
    }
  }

  void reset() {
    _dts.clear();
    _sum = 0.0;
    state = 0.0;
  }
}

final fpsProvider = NotifierProvider<FpsNotifier, double>(FpsNotifier.new);
