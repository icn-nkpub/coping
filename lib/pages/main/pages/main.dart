import 'package:sca6/pages/main/main.dart';
import 'package:sca6/tokens/cardrope.dart';
import 'package:sca6/tokens/icons.dart';
import 'package:sca6/provider/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca6/provider/theme/colors.dart';
import 'package:sca6/provider/theme/theme.dart';

class MainPage extends StatelessWidget {
  const MainPage({
    super.key,
    required this.setPage,
  });

  final void Function(int) setPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopBar(setPage: setPage),
      ],
    );
  }
}

class TopBar extends StatefulWidget {
  const TopBar({
    super.key,
    required this.setPage,
  });

  final void Function(int) setPage;

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  bool expandMenu = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          BlocBuilder<LoginCubit, Profile?>(builder: (context, u) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Hello, ',
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(text: u?.profile?.firstName ?? 'and'),
                        const TextSpan(text: " "),
                        TextSpan(text: u?.profile?.secondName ?? 'welcome'),
                        const TextSpan(text: "!"),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        expandMenu = !expandMenu;
                      });
                    },
                    icon: const SvgIcon(assetName: "more"),
                  )
                  // context.read<LoginCubit>().signIn("test@sca-6.org", "test");
                ],
              ),
            );
          }),
          if (expandMenu)
            CardRope(cards: [
              RopedCard(
                children: [
                  Column(
                    children: mainNav.entries.map((MapEntry<int, String> page) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: page.key == 0 ? 0 : 8.0,
                        ),
                        child: FilledButton.tonal(
                          onPressed: () => widget.setPage(page.key),
                          child: Container(
                            width: double.maxFinite,
                            alignment: Alignment.center,
                            child: Text(page.value),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              RopedCard(
                children: [
                  _themeSettings(),
                ],
              ),
            ]),
        ],
      ),
    );
  }

  BlocBuilder<ThemeCubit, ThemeState> _themeSettings() {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, t) {
        return Row(
          children: [
            FilledButton.tonal(
              style: Theme.of(context).filledButtonTheme.style,
              onPressed: () {
                context.read<ThemeCubit>().flipBrightness();
              },
              child: SvgIcon(
                assetName: t.isLightMode() ? "mode_light" : "mode_dark",
              ),
            ),
            Flexible(
              child: Container(
                width: double.maxFinite,
                alignment: Alignment.center,
                child: Text(
                  themeColorName(t.color),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
            FilledButton.tonal(
              onPressed: () {
                var next = (ColorValue.values.indexOf(t.color) + 1) %
                    (ColorValue.values.length);
                var selected = ColorValue.values[next];
                context.read<ThemeCubit>().setColor(selected);
              },
              child: const SvgIcon(assetName: "palette"),
            ),
          ],
        );
      },
    );
  }
}
