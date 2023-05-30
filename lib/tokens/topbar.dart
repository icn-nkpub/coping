import 'dart:async';

import 'package:sca6/tokens/icons.dart';
import 'package:flutter/material.dart';
import 'package:sca6/tokens/cardrope.dart';
import 'package:sca6/provider/login/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca6/provider/theme/colors.dart';
import 'package:sca6/provider/theme/theme.dart';
import 'package:sca6/tokens/measurable.dart';

class NullTopBar extends StatelessWidget {
  const NullTopBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).appBarTheme.backgroundColor,
      shadowColor: Theme.of(context).appBarTheme.shadowColor,
      elevation: 2,
      child: const SizedBox(
        width: double.infinity,
        height: 4,
      ),
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
        verticalDirection: VerticalDirection.up,
        children: [
          body(),
          head(context),
        ],
      ),
    );
  }

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

  BlocBuilder<LoginCubit, Profile?> head(BuildContext context) {
    return BlocBuilder<LoginCubit, Profile?>(builder: (_, u) {
      return Material(
        color: Theme.of(context).appBarTheme.backgroundColor,
        shadowColor: Theme.of(context).appBarTheme.shadowColor,
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Opacity(
                opacity: 0,
                child: IconButton(
                  onPressed: () {},
                  icon: const SvgIcon(assetName: 'more'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Hello, ',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: u?.profile?.firstName ?? 'and'),
                      const TextSpan(text: ' '),
                      TextSpan(text: u?.profile?.secondName ?? 'welcome'),
                      const TextSpan(text: '!'),
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
                icon: const SvgIcon(assetName: 'settings'),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget body() {
    return Shrinkable(
      expanded: expandMenu,
      child: CardRope(
        cards: [
          RopedCard(
            children: [
              BlocBuilder<LoginCubit, Profile?>(builder: (context, u) {
                List<Widget> children = [];

                if (u == null) {
                  children.add(NavButton('Login', onPressed: goTo(0)));
                  children.add(NavButton('Register', onPressed: goTo(1)));
                } else {
                  children.add(NavButton('Profile', onPressed: goTo(2)));
                  children.add(NavButton('Logout', onPressed: goTo(3)));
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
          const SizedBox(
            height: 0,
          ),
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
                // "!" (NOT) because we just fliped but yet refreshed.
                context.read<LoginCubit>().setTheme(t.color.name, !t.isLightMode());
                context.read<ThemeCubit>().flipBrightness();
              },
              child: SvgIcon(
                assetName: t.isLightMode() ? 'mode_light' : 'mode_dark',
              ),
            ),
            Flexible(
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  themeColorName(t.color),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
            FilledButton.tonal(
              onPressed: () {
                var next = (ColorValue.values.indexOf(t.color) + 1) % (ColorValue.values.length);
                var selected = ColorValue.values[next];
                context.read<ThemeCubit>().setColor(selected);
                context.read<LoginCubit>().setTheme(selected.name, t.isLightMode());
              },
              child: const SvgIcon(assetName: 'palette'),
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
        width: double.infinity,
        alignment: Alignment.center,
        child: Text(page),
      ),
    );
  }
}
