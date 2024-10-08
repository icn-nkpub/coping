import 'package:dependencecoping/tokens/icons.dart';
import 'package:flutter/material.dart';

class NullTopBar extends StatelessWidget {
  const NullTopBar({
    super.key,
  });

  @override
  Widget build(final BuildContext context) => Material(
        color: Theme.of(context).appBarTheme.backgroundColor,
        shadowColor: Theme.of(context).appBarTheme.shadowColor,
        elevation: 2,
        child: const SizedBox(
          width: double.infinity,
          height: 4,
        ),
      );
}

class TopBar extends StatefulWidget {
  const TopBar({
    required this.setPage,
    required this.subTitle,
    super.key,
  });

  final void Function(int) setPage;
  final String subTitle;

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  bool expandMenu = false;

  @override
  Widget build(final BuildContext context) => Container(
        alignment: Alignment.center,
        child: Column(
          verticalDirection: VerticalDirection.up,
          children: [
            head(context),
          ],
        ),
      );

  void Function() goTo(final int pageKey) => () {
        widget.setPage(pageKey);
        setState(() {
          expandMenu = !expandMenu;
        });
      };

  Widget head(final BuildContext context) => Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Opacity(
                  opacity: 0,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.live_help, size: computeSizeFromOffset(0)),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text(
                    'Coping ',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontVariations: [const FontVariation('wght', 700.0)],
                    ),
                  ),
                  Opacity(
                    opacity: .6,
                    child: Text(
                      widget.subTitle,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontVariations: [const FontVariation('wght', 300.0)]),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Opacity(
                  opacity: 0,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        expandMenu = !expandMenu;
                      });
                    },
                    icon: AnimatedRotation(
                      duration: const Duration(milliseconds: 100),
                      turns: expandMenu ? 0.5 : 0,
                      child: Icon(Icons.expand_more,
                          size: computeSizeFromOffset(0)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class NavButton extends StatelessWidget {
  const NavButton(
    this.page, {
    required this.onPressed,
    super.key,
  });
  final String page;
  final Function() onPressed;

  @override
  Widget build(final BuildContext context) => FilledButton.tonal(
        onPressed: onPressed,
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(page),
        ),
      );
}
