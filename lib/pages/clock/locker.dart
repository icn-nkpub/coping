import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/provider/theme/fonts.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:flutter/material.dart';

const hourOpts = [1, 2, 3, 4, 5, 6, 9, 12, 18, 24, 36, 48, 96, 99];
const minuteOpts = [5, 10, 15, 20, 25, 30, 35, 45, 50, 55, 59];

class Locker extends StatefulWidget {
  const Locker({super.key});

  @override
  State<Locker> createState() => _LockerState();
}

class _LockerState extends State<Locker> {
  bool locked = true;
  var hours = PageController();
  var minutes = PageController();

  @override
  Widget build(final BuildContext context) => Card(
        margin: EdgeInsets.zero,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: _unlocked,
          ),
        ),
      );

  List<Widget> get _unlocked => [
      IconButton.filledTonal(
        onPressed: () {
          setState(() {
            locked = !locked;
          });
        },
        icon: SvgIcon(assetPath: Assets.icons.lock),
      ),
      Row(
        children: [
          ScrollOptions(controller: hours, options: hourOpts),
          const Padding(
            padding: EdgeInsets.all(4),
            child: Text(':'),
          ),
          ScrollOptions(controller: minutes, options: minuteOpts),
        ],
      ),
    ];
}

class ScrollOptions extends StatelessWidget {
  const ScrollOptions({
    required this.controller, required this.options, super.key,
  });

  final PageController controller;
  final List<int> options;

  @override
  Widget build(final BuildContext context) => Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(.1),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: PageView(
        scrollDirection: Axis.vertical,
        controller: controller,
        children: options.map((final e) => Number(label: '$e'.padLeft(2, 'O').replaceAll('0', 'O'))).toList(),
      ),
    );
}

class Number extends StatelessWidget {
  const Number({
    required this.label, super.key,
  });

  final String label;

  @override
  Widget build(final BuildContext context) => Center(
      child: Card(
        elevation: 2,
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(10),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: fAccent(
                textStyle: Theme.of(context).textTheme.displaySmall,
              )
                  .copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  )
                  .copyWith(fontSize: 160),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
}
