import 'package:dependencecoping/pages/clock/main.dart';
import 'package:dependencecoping/pages/triggers/triggers.dart';
import 'package:dependencecoping/paginator.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:dependencecoping/pages/meditation/meditation.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: SvgIcon(assetName: 'timer'),
            label: 'Clock',
          ),
          NavigationDestination(
            icon: SvgIcon(assetName: 'mindfulness'),
            label: 'Triggers',
          ),
          NavigationDestination(
            icon: SvgIcon(assetName: 'relax'),
            label: 'Meditation',
          ),
        ],
      ),
      body: [
        ClockScreen(setPage: pagginator(context)),
        TriggersScreen(setPage: pagginator(context)),
        const MeditationScreen(),
      ][currentPageIndex],
    );
  }
}
