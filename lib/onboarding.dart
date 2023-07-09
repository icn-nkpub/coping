import 'package:dependencecoping/paginator.dart';
import 'package:dependencecoping/provider/theme/theme.dart';
import 'package:dependencecoping/pages/meditation/meditation.dart';
import 'package:dependencecoping/tokens/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funvas/funvas.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({
    super.key,
  });

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int currentPageIndex = 0;
  double animationOffset = 4;

  @override
  Widget build(BuildContext context) {
    var goTo = pagginator(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: const SafeArea(
          left: false,
          top: false,
          right: false,
          bottom: true,
          child: SizedBox(),
        ),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            const Flexible(
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Display(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8 * 2),
              child: NavButton('Login', onPressed: () => goTo(0)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8 * 2),
              child: NavButton('Register', onPressed: () => goTo(1)),
            ),
            const SizedBox(
              height: 8 * 6,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8 * 4),
              child: ThemeChanger(),
            ),
          ],
        ),
      ),
    );
  }
}

class Display extends StatelessWidget {
  const Display({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cd = CanvasDrawer(
      backdrop: context.read<ThemeCubit>().state.data.scaffoldBackgroundColor,
      primary: HSLColor.fromColor(context.read<ThemeCubit>().state.data.colorScheme.primary),
      secondary: HSLColor.fromColor(context.read<ThemeCubit>().state.data.colorScheme.secondary),
      fullCycleDuration: 4,
      scale: 2,
      rounds: 12,
      slideDist: 0,
      muted: true,
    );

    return BlocListener<ThemeCubit, ThemeState>(
      listener: (context, state) {
        cd.backdrop = context.read<ThemeCubit>().state.data.scaffoldBackgroundColor;
        cd.primary = HSLColor.fromColor(state.data.colorScheme.primary);
        cd.secondary = HSLColor.fromColor(state.data.colorScheme.secondary);
      },
      child: FunvasContainer(
        funvas: cd,
      ),
    );
  }
}
