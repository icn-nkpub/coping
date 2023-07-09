import 'dart:async';

import 'package:dependencecoping/tokens/icons.dart';
import 'package:flutter/material.dart';
import 'package:dependencecoping/tokens/cardrope.dart';
import 'package:dependencecoping/provider/login/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dependencecoping/provider/theme/colors.dart';
import 'package:dependencecoping/provider/theme/theme.dart';
import 'package:dependencecoping/tokens/measurable.dart';

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
                    text: 'Good day',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
                    children: [
                      if (u?.profile?.firstName != null)
                        TextSpan(
                          text: ', ${u?.profile?.firstName ?? ''}',
                        ),
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
                icon: AnimatedRotation(
                  duration: const Duration(milliseconds: 100),
                  turns: expandMenu ? 0.5 : 0,
                  child: const SvgIcon(assetName: 'expand_more'),
                ),
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

  Widget _themeSettings() {
    return const ThemeChanger();
  }
}

class ThemeChanger extends StatelessWidget {
  const ThemeChanger({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, t) {
        return Row(
          children: [
            FilledButton.tonal(
              style: Theme.of(context).filledButtonTheme.style,
              onPressed: () {
                // '!' (NOT) because we just fliped but yet refreshed.
                context.read<LoginCubit>().setTheme(t.color.name, !t.isLightMode());
                context.read<ThemeCubit>().flipBrightness();
              },
              child: SvgIcon(
                assetName: t.isLightMode() ? 'light_mode' : 'dark_mode',
              ),
            ),
            Flexible(
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text(
                  t.color.name,
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
