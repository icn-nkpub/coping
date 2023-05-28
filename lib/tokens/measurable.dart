import 'package:flutter/material.dart';

class Measurable extends StatefulWidget {
  const Measurable({
    super.key,
    required this.reportHeight,
    required this.child,
  });

  final Function(double) reportHeight;
  final Widget child;

  @override
  State<Measurable> createState() => _MeasurableState();
}

class _MeasurableState extends State<Measurable> {
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rb = _key.currentContext!.findRenderObject()! as RenderBox;
      widget.reportHeight(rb.size.height);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Container(key: _key, child: widget.child),
    );
  }
}

class Shrinkable extends StatefulWidget {
  const Shrinkable({
    super.key,
    required this.child,
    required this.expanded,
    this.duration = const Duration(milliseconds: 200),
  });

  final Widget child;
  final bool expanded;
  final Duration duration;

  @override
  State<Shrinkable> createState() => _ShrinkableState();
}

class _ShrinkableState extends State<Shrinkable> {
  double size = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.duration,
      height: widget.expanded ? size : 0,
      child: Measurable(
        reportHeight: (h) => setState(() => size = h),
        child: widget.child,
      ),
    );
  }
}
