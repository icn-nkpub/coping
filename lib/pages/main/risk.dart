import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:sca6/tokens/icons.dart';

class Risk extends StatelessWidget {
  const Risk({
    super.key,
    required this.from,
    required this.iconName,
    required this.title,
    required this.descriptions,
    required this.rate,
  });

  final DateTime from;
  final String iconName;
  final String title;
  final Map<double, String> descriptions;
  final double rate;

  @override
  Widget build(BuildContext context) {
    final double value =
        (DateTime.now().difference(from).inMilliseconds.toDouble() / rate);
    final bool finished = value > 1 ? true : false;

    String description = descriptions[0]!;
    for (var d in descriptions.entries) {
      if (value > d.key) description = d.value;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 12),
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(.2),
                ),
              )),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: SvgIcon(
                      assetName: iconName,
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      child: LinearProgressIndicator(
                        value: value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 4, bottom: 8, top: 12),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 4, bottom: 8),
              alignment: Alignment.centerLeft,
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: Theme.of(context).hintColor,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
