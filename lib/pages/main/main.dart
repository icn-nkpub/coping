import 'package:sca6/tokens/icons.dart';
import 'package:sca6/provider/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca6/provider/theme/colors.dart';
import 'package:sca6/provider/theme/theme.dart';
import 'package:sca6/tokens/select.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool expandMenu = false;

  @override
  Widget build(BuildContext context) {
    const p = EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 16,
    );

    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          BlocBuilder<LoginCubit, Profile?>(builder: (context, u) {
            return Padding(
              padding: p,
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
            Container(
              width: double.maxFinite,
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () => context
                                  .read<LoginCubit>()
                                  .signIn("test@sca-6.org", "test"),
                              child: const Text("Login"),
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.read<LoginCubit>().signOut(),
                              child: const Text("Logout"),
                            ),
                          ],
                        ),
                      ),
                      _themeSettings(),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  BlocBuilder<ThemeCubit, ThemeState> _themeSettings() {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, t) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                context.read<ThemeCubit>().flipBrightness();
              },
              icon: SvgIcon(
                  assetName: t.isLightMode() ? "mode_light" : "mode_dark"),
            ),
            Flexible(
              child: Select(
                value: t.color,
                items: ColorValue.values
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Text(themeColorName(e)),
                        )))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    context.read<ThemeCubit>().setColor(value);
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
