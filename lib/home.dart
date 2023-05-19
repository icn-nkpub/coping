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
      appBar: AppBar(toolbarHeight: 0),
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
