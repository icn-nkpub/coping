import 'package:sca6/pages/clock/main.dart';
import 'package:sca6/pages/triggers/triggers.dart';
import 'package:sca6/paginator.dart';
import 'package:sca6/pages/diary/diary.dart';
import 'package:sca6/tokens/icons.dart';
import 'package:sca6/pages/meditation/meditation.dart';
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
            icon: SvgIcon(assetName: 'stickynote'),
            label: 'Diary',
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
        MainScreen(setPage: pagginator(context)),
        TriggersScreen(setPage: pagginator(context)),
        DairyScreen(setPage: pagginator(context)),
        const MeditationScreen(),
      ][currentPageIndex],
    );
  }
}
