import 'package:flutter/material.dart';
import 'package:cloudcircle/tokens/icons.dart';
import 'package:cloudcircle/tokens/measurable.dart';

class GoalCard extends StatefulWidget {
  const GoalCard({
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
  final Duration rate;

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final double value = (DateTime.now().difference(widget.from).inSeconds.toDouble() / widget.rate.inSeconds.toDouble());
    final bool finished = value > 1 ? true : false;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: finished
            ? _desc(finished, value)
            : Column(
                children: [
                  _desc(finished, value),
                  Container(
                    padding: const EdgeInsets.only(top: 8),
                    child: Container(
                      padding: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 4),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Theme.of(context).dividerColor.withOpacity(.2),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: SvgIcon(
                              assetName: widget.iconName,
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.centerRight,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                              child: LinearProgressIndicator(
                                minHeight: 8,
                                backgroundColor: ElevationOverlay.applySurfaceTint(
                                    Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.primary, 50),
                                color: Theme.of(context).colorScheme.primary,
                                value: value,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _desc(bool finished, double value) {
    String description = widget.descriptions[0]!;
    for (var d in widget.descriptions.entries) {
      if (value > d.key) description = d.value;
    }

    final c = Color.alphaBlend(
      Theme.of(context).colorScheme.inversePrimary.withOpacity(.4),
      Theme.of(context).colorScheme.surface.withOpacity(.6),
    );

    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => expanded = !expanded),
          child: Card(
            margin: EdgeInsets.zero,
            shadowColor: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (finished)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(800),
                        color: c,
                      ),
                      child: const SvgIcon(
                        assetName: 'done',
                        size: 24 - (4 * 2),
                      ),
                    ),
                  ),
                if (finished)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(800),
                        color: c,
                      ),
                      child: SvgIcon(
                        assetName: widget.iconName,
                        size: 24 - (4 * 2),
                      ),
                    ),
                  ),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Expanded(child: SizedBox()),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 100),
                  turns: expanded ? 0.5 : 0,
                  child: const SvgIcon(assetName: 'expand_more'),
                )
              ],
            ),
          ),
        ),
        Shrinkable(
          expanded: expanded,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            alignment: Alignment.centerLeft,
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
