import 'package:cloudcircle/tokens/icons.dart';
import 'package:flutter/material.dart';

Widget modal(BuildContext context, Widget w) {
  return Scaffold(
    appBar: AppBar(
      toolbarHeight: 0,
    ),
    bottomNavigationBar: const SafeArea(
      left: false,
      top: false,
      right: false,
      bottom: true,
      child: SizedBox(),
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                  },
                  icon: const SvgIcon(assetName: 'close'),
                ),
              ],
            ),
          ),
          Flexible(
            child: w,
          )
        ],
      ),
    ),
  );
}
