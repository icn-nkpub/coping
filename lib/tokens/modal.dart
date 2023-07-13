import 'package:dependencecoping/tokens/icons.dart';
import 'package:flutter/material.dart';

Widget modal(BuildContext context, String title, Widget w) {
  return Scaffold(
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
        bottom: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                    icon: const SvgIcon(assetName: 'arrow_back'),
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
                      icon: const SvgIcon(assetName: 'arrow_back'),
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
}

void openModal(BuildContext context, Widget content) {
  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black.withOpacity(.75),
      pageBuilder: (context, animation, _) {
        return content;
      },
      transitionsBuilder: (context, animation, _, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.linear,
          )),
          child: child,
        );
      },
    ),
  );
}
