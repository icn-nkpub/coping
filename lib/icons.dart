import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgIcon extends StatelessWidget {
  const SvgIcon({
    super.key,
    required this.assetName,
    this.size = 24,
  });

  final String assetName;
  final double size;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).iconTheme;

    return SvgPicture.asset(
      "assets/icons/$assetName.svg",
      colorFilter: ColorFilter.mode(
        t.color!,
        BlendMode.srcIn,
      ),
      width: size,
      height: size,
    );
  }
}
