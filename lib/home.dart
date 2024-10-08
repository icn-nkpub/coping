import 'package:dependencecoping/pages/dao/dao.dart';
import 'package:dependencecoping/pages/meditation/meditation.dart';
import 'package:dependencecoping/paginator.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentPageIndex,
          onDestinationSelected: (final int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(
                Icons.group,
                size: computeSizeFromOffset(0),
              ),
              label: AppLocalizations.of(context)!.screenAssistant,
            ),
            NavigationDestination(
              icon: Icon(
                Icons.spa,
                size: computeSizeFromOffset(0),
              ),
              label: AppLocalizations.of(context)!.screenMeditation,
            ),
          ],
        ),
        body: [
          CopeScreen(setPage: pagginator(context)),
          const MeditationScreen(),
        ][currentPageIndex],
      );
}
