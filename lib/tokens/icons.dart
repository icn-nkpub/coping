import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  const SvgIcon({
    required this.assetPath,
    super.key,
    this.sizeOffset = 0,
    this.color,
  });

  final String assetPath;
  final double sizeOffset;
  final Color? color;

  @override
  Widget build(final BuildContext context) => SizedBox(
        width: 22 - sizeOffset,
        height: 22 - sizeOffset,
        child: FittedBox(
          fit: BoxFit.cover,
          child: ImageFiltered(
            imageFilter: ImageFilter.compose(
              inner: ImageFilter.blur(sigmaX: .1, sigmaY: .1),
              outer: ColorFilter.mode(
                color ?? Theme.of(context).iconTheme.color!,
                BlendMode.srcATop,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                assetPath,
                allowDrawingOutsideViewBox: true,
                width: 100,
                height: 100,
                clipBehavior: Clip.none,
              ),
            ),
          ),
        ),
      );
}
