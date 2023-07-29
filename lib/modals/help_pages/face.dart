import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Guy extends StatelessWidget {
  const Guy({
    required this.t,
    required this.s,
    required this.text,
    required this.face,
    super.key,
  });

  final ThemeData t;
  final double s;
  final String text;
  final String face;

  @override
  Widget build(final BuildContext context) => Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: t.colorScheme.primaryContainer,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          children: [
            SizedBox(width: s),
            Expanded(
                child: Center(
              child: Text(
                text,
                style: t.textTheme.headlineSmall!.copyWith(color: t.colorScheme.onPrimaryContainer),
              ),
            )),
            SvgPicture.asset(
              face,
              colorFilter: ColorFilter.mode(
                t.colorScheme.onPrimaryContainer,
                BlendMode.srcATop,
              ),
              width: s,
              height: s,
              clipBehavior: Clip.antiAliasWithSaveLayer,
            ),
          ],
        ),
      );
}
