import 'package:sca6/icons.dart';
import 'package:sca6/pages/meditation/meditation.dart';
import 'package:sca6/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.useLightMode,
    required this.handleBrightnessChange,
  });

  final bool useLightMode;
  final void Function(bool useLightMode) handleBrightnessChange;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              BlocBuilder<LoginCubit, Profile?>(
                builder: (context, u) {
                  return u != null
                      ? Text(
                          "${u.id}, ${u.email} ${u.profile!.createdAt.toString()}")
                      : Container(
                          child: Column(children: [
                            TextButton(
                              onPressed: () {
                                context
                                    .read<LoginCubit>()
                                    .signIn("test@sca-6.org", "test");
                              },
                              child: const Text("login"),
                            )
                          ]),
                        );
                },
              ),
              TextButton(
                  onPressed: () =>
                      widget.handleBrightnessChange(!widget.useLightMode),
                  child: const Text("change"))
            ],
          ),
        ),
        const MeditationScreen(),
        Container(
          alignment: Alignment.center,
          child: const Text('Page 3'),
        ),
      ][currentPageIndex],
    );
  }
}
