// ignore_for_file: discarded_futures

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

Map<String, Image> _imageCache = {};

double computeSizeFromOffset(final double offset) => 22 - offset;

class SvgIcon extends StatelessWidget {
  const SvgIcon(
    this.assetPath, {
    super.key,
    this.sizeOffset = 0,
    this.color,
  });

  final String assetPath;
  final double sizeOffset;
  final Color? color;

  @override
  Widget build(final BuildContext context) => SizedBox(
        width: computeSizeFromOffset(sizeOffset),
        height: computeSizeFromOffset(sizeOffset),
        child: FittedBox(
          fit: BoxFit.fill,
          child: SizedBox(
            width: 480,
            height: 480,
            child: FutureBuilder(
              future: Future(() async {
                if (_imageCache.containsKey(assetPath)) {
                  return _imageCache[assetPath]!;
                }

                final v = await vg.loadPicture(
                  SvgAssetLoader(assetPath),
                  null,
                );
                final oi = await v.picture.toImage(480 * 2, 480 * 2);
                final d = await oi.toByteData(format: ui.ImageByteFormat.png);

                final fi = Image.memory(
                  Uint8List.view(d!.buffer),
                  scale: 1 / 10,
                  filterQuality: FilterQuality.high,
                );

                _imageCache[assetPath] = fi;

                return fi;
              }),
              builder: (final BuildContext c, final AsyncSnapshot<Image?> p) =>
                  ImageFiltered(
                imageFilter: ui.ImageFilter.compose(
                  inner: ui.ImageFilter.blur(sigmaX: .1, sigmaY: .1),
                  outer: ColorFilter.mode(
                    color ?? Theme.of(context).iconTheme.color!,
                    BlendMode.srcATop,
                  ),
                ),
                child: p.data ?? _imageCache[assetPath] ?? const SizedBox(),
              ),
            ),
          ),
        ),
      );
}
