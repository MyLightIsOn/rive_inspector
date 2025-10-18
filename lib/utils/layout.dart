import 'package:flutter/material.dart';

const double kInspectorWidth = 340;
const double kNarrowBreakpoint = 800;

class SplitView extends StatelessWidget {
  final Widget left;
  final Widget right;
  const SplitView({super.key, required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isNarrow = w < kNarrowBreakpoint;

    if (isNarrow) {
      // Stack vertically on narrow screens
      return Column(
        children: [
          Expanded(child: left),
          SizedBox(
            height: 320,
            child: right,
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: left),
        const VerticalDivider(width: 1),
        SizedBox(width: kInspectorWidth, child: right),
      ],
    );
  }
}
