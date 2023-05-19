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
    goTo(int pageKey) {
      return () {
        widget.setPage(pageKey);
        Future.delayed(
          const Duration(milliseconds: 300),
          () => setState(() {
            expandMenu = !expandMenu;
          }),
        );
      };
    }

    var navButtonsCount = 2;
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          BlocBuilder<LoginCubit, Profile?>(builder: (context, u) {
            return Card(
              margin: const EdgeInsets.only(top: 8, left: 8, right: 8),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: RichText(
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
              ),
            );
          }),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            alignment: Alignment.bottomRight,
            height:
                expandMenu ? 32 + 8 + ((32 + 8) * navButtonsCount) + 8 + 72 : 0,
            padding: EdgeInsets.symmetric(vertical: expandMenu ? 8 : 0),
            curve: Curves.ease,
            child: CardRope(cards: [
              RopedCard(
                children: [
                  BlocBuilder<LoginCubit, Profile?>(builder: (context, u) {
                    List<Widget> children = [];

                    if (u == null) {
                      children.add(NavButton("Login", onPressed: goTo(0)));
                      children.add(NavButton("Register", onPressed: goTo(1)));
                    } else {
                      children.add(NavButton("Profile", onPressed: goTo(2)));
                      children.add(NavButton("Logout", onPressed: goTo(3)));
                    }

                    return Wrap(
                      runSpacing: 8,
                      children: children,
                    );
                  }),
                ],
              ),
              RopedCard(
                children: [
                  _themeSettings(),
                ],
              ),
            ]),
          ),
          const Text("tist")
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

class NavButton extends StatelessWidget {
  const NavButton(
    this.page, {
    super.key,
    required this.onPressed,
  });
  final String page;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onPressed,
      child: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        child: Text(page),
      ),
    );
  }
}
