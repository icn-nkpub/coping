import 'package:dependencecoping/gen/fonts.gen.dart';
import 'package:dependencecoping/provider/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'theme.g.dart';

@HiveType(typeId: 0)
class ThemeState {
  ThemeState({
    required this.isLightMode,
    required this.colorIndex,
    this.data,
  });

  @HiveField(0)
  bool isLightMode;
  @HiveField(1)
  int colorIndex;
  ThemeData? data;

  void resetThemeData() {
    final color = ColorValue.values[colorIndex];

    var newData = ThemeData(
      fontFamily: FontFamily.spaceGrotesk,
      colorScheme: ColorScheme.fromSeed(
        seedColor: color.primary,
        brightness: isLightMode ? Brightness.light : Brightness.dark,
      ),
      useMaterial3: true,
      brightness: isLightMode ? Brightness.light : Brightness.dark,
    );

    final bc = newData.colorScheme.surface;
    final pc = newData.colorScheme.surfaceTint;

    const shadow = Colors.transparent;

    newData = newData.copyWith(
      iconTheme: newData.iconTheme.copyWith(
        color: newData.colorScheme.onPrimaryContainer,
      ),
      scaffoldBackgroundColor: isLightMode
          ? Colors.white
          : ElevationOverlay.applySurfaceTint(bc, pc, .5),
      appBarTheme: newData.appBarTheme.copyWith(
        color: ElevationOverlay.applySurfaceTint(bc, pc, 4),
        shadowColor: shadow,
      ),
      shadowColor: shadow,
      cardTheme: newData.cardTheme.copyWith(
        shadowColor: shadow,
      ),
      snackBarTheme: newData.snackBarTheme.copyWith(
        backgroundColor: ElevationOverlay.applySurfaceTint(bc, pc, 4),
      ),
    );

    data = newData;
  }

  @override
  bool operator ==(final Object other) => false; // ignore: hash_and_equals
}

void flipBrightness(final BuildContext context) async {
  final themebox = Hive.box<ThemeState>('ThemeState');
  final ThemeState state = (themebox.length > 0 ? themebox.getAt(0) : null) ??
      defaultThemeState(context);

  state.isLightMode = !state.isLightMode;

  state.resetThemeData();
  if (themebox.length > 0) {
    await themebox.putAt(0, state);
  } else {
    await themebox.add(state);
  }
}

void setColor(final BuildContext context, final ColorValue c) async {
  final themebox = Hive.box<ThemeState>('ThemeState');
  final ThemeState state = (themebox.length > 0 ? themebox.getAt(0) : null) ??
      defaultThemeState(context);

  state.colorIndex = ColorValue.values.indexOf(c);

  state.resetThemeData();
  if (themebox.length > 0) {
    await themebox.putAt(0, state);
  } else {
    await themebox.add(state);
  }
}

ThemeState defaultThemeState(final BuildContext context) {
  final data = ThemeState(
    isLightMode: MediaQuery.of(context).platformBrightness == Brightness.light,
    colorIndex: 0,
    data: ThemeData(),
  );
  data.resetThemeData();

  return data;
}
