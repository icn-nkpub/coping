import 'dart:async';

import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:flutter/material.dart';

Widget modal(final BuildContext context, final String title, final Widget w) => Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        margin: const EdgeInsets.only(top: 8 * 10, left: 8, right: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8 * 3),
            topRight: Radius.circular(8 * 3),
          ),
        ),
        child: SafeArea(
          left: false,
          top: false,
          right: false,
          minimum: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                      },
                      icon: SvgIcon(assetPath: Assets.icons.arrowBack),
                    ),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Opacity(
                      opacity: 0,
                      child: IconButton(
                        onPressed: () {
                          if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                        },
                        icon: SvgIcon(assetPath: Assets.icons.arrowBack),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Expanded(child: w),
            ],
          ),
        ),
      ),
    );

void openModal(final BuildContext context, final Widget content) {
  unawaited(Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black.withOpacity(.75),
      pageBuilder: (final context, final animation, final _) => content,
      transitionsBuilder: (final context, final animation, final _, final child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.linear,
        )),
        child: child,
      ),
    ),
  ));
}
