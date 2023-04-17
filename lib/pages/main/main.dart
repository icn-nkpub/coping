import 'package:sca6/provider/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca6/provider/theme/theme.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const p = EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 24,
    );

    return Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          BlocBuilder<LoginCubit, Profile?>(builder: (context, u) {
            return Padding(
              padding: p,
              child: (u != null ? _logined : _notLogined)(context, u),
            );
          }),
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, u) {
              return Padding(
                padding: p,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.read<ThemeCubit>().flipBrightness();
                      },
                      icon: Icon(
                          u.isLightMode() ? Icons.sunny : Icons.nightlight),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<ThemeCubit>().setColor(ColorValue.red);
                      },
                      child: const Text("red"),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<ThemeCubit>().setColor(ColorValue.green);
                      },
                      child: const Text("green"),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<ThemeCubit>().setColor(ColorValue.blue);
                      },
                      child: const Text("blue"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Row _logined(BuildContext context, Profile? u) {
    return Row(
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
        TextButton(
          onPressed: () {
            context.read<LoginCubit>().signOut();
          },
          child: const Text("logout"),
        )
      ],
    );
  }

  Row _notLogined(BuildContext context, Profile? _) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            text: 'Hello!',
            style: DefaultTextStyle.of(context).style,
            children: [],
          ),
        ),
        TextButton(
          onPressed: () {
            context.read<LoginCubit>().signIn("test@sca-6.org", "test");
          },
          child: const Text("login"),
        ),
      ],
    );
  }
}
