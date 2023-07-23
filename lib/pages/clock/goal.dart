import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:dependencecoping/tokens/measurable.dart';

class GoalCard extends StatefulWidget {
  const GoalCard({
    super.key,
    required this.from,
    required this.iconName,
    required this.titles,
    required this.descriptions,
    required this.rate,
  });

  final DateTime from;
  final String iconName;
  final Map<String, String> titles;
  final Map<String, String> descriptions;
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
    final segments = widget.rate.inDays.round().clamp(1, 7 * 4);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: finished
            ? _desc(context, finished, value)
            : Column(
                children: [
                  _desc(context, finished, value),
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
                              assetPath: 'assets/icons/${widget.iconName}.svg',
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Flexible(
                            child: Meter(
                              value,
                              segments: segments,
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

  Widget _desc(BuildContext context, bool finished, double value) {
    String description = widget.descriptions['en']!;
    for (var d in widget.descriptions.entries) {
      if (d.key == Localizations.localeOf(context).languageCode) description = d.value;
    }

    String title = widget.titles['en']!;
    for (var t in widget.titles.entries) {
      if (t.key == Localizations.localeOf(context).languageCode) title = t.value;
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
                      child: SvgIcon(
                        assetPath: Assets.icons.done,
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
                        assetPath: 'assets/icons/${widget.iconName}.svg',
                        size: 24 - (4 * 2),
                      ),
                    ),
                  ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Expanded(child: SizedBox()),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 100),
                  turns: expanded ? 0.5 : 0,
                  child: SvgIcon(assetPath: Assets.icons.expandMore),
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

class Meter extends StatelessWidget {
  const Meter(
    this.value, {
    this.segments = 10,
    super.key,
  });

  final double value;
  final int segments;

  @override
  Widget build(BuildContext context) {
    List<Widget> c = [];

    for (var i = 0; i < segments; i++) {
      c.add(
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.centerRight,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(1),
            child: LinearProgressIndicator(
              minHeight: 8,
              backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(.2),
              color: Theme.of(context).colorScheme.primary.withOpacity(.5),
              value: ((value * segments) - i).clamp(0, 1),
            ),
          ),
        ),
      );
    }

    return Row(
      children: c,
    );
  }
}
