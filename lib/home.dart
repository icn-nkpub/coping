import 'package:sca6/pages/main/paginator.dart';
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
        // it's some bug on ios that appear in Flutter 3.10.1, revision d3d8effc68
        backgroundColor: ElevationOverlay.applySurfaceTint(
            Theme.of(context).cardColor, Theme.of(context).primaryColor, 2),
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
            icon: SvgIcon(assetName: "stickynote"),
            label: 'Diary',
          ),
          NavigationDestination(
            icon: SvgIcon(assetName: "relax"),
            label: 'Meditation',
          ),
          NavigationDestination(
            icon: SvgIcon(assetName: "mindfulness"),
            label: 'Triggers',
          ),
        ],
      ),
      body: [
        const MainScreen(),
        const MeditationScreen(),
        Container(
          alignment: Alignment.center,
          child: const Text('Page 3'),
        ),
      ][currentPageIndex],
    );
  }
}
