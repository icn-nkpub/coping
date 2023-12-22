import 'dart:ui';

import 'package:flutter/material.dart';

class DrawFrag extends StatefulWidget {
  const DrawFrag({
    required this.frag,
    super.key,
  });

  final String frag;

  @override
  State<DrawFrag> createState() => _DrawFragState();
}

class _DrawFragState extends State<DrawFrag>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.repeat(reverse: true);
  }

  @override
  Widget build(final BuildContext context) => FutureBuilder<FragmentShader>(
        // ignore: discarded_futures
        future: _load(widget.frag),
        builder: (final context, final snapshot) {
          if (snapshot.hasData) {
            final shader = snapshot.data!;
            shader.setFloat(1, MediaQuery.of(context).size.width);
            shader.setFloat(2, MediaQuery.of(context).size.height);
            return AnimatedBuilder(
              animation:
                  _controller.drive(CurveTween(curve: Curves.bounceInOut)),
              builder: (final bc, final child) {
                shader.setFloat(0, _controller.value * 2);
                return CustomPaint(
                  painter: ShaderPainter(shader),
                );
              },
            );
          }

          return const CircularProgressIndicator();
        },
      );
}

class ShaderPainter extends CustomPainter {
  ShaderPainter(this.shader);
  final FragmentShader shader;

  @override
  void paint(final Canvas canvas, final Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant final CustomPainter oldDelegate) =>
      oldDelegate != this;
}

Future<FragmentShader> _load(final String name) async {
  final FragmentProgram program =
      await FragmentProgram.fromAsset('shaders/$name.frag');
  return program.fragmentShader();
}
