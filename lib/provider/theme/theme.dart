import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dependencecoping/provider/theme/colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeState {
  ThemeState({
    required this.mode,
    required this.data,
    required this.color,
  });

  ThemeMode mode;
  ThemeData data;
  ColorValue color;

  resetThemeData() {
    data = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: color.primary,
        secondary: color.secondary,
        brightness: isLightMode() ? Brightness.light : Brightness.dark,
      ),
      useMaterial3: true,
      brightness: isLightMode() ? Brightness.light : Brightness.dark,
    );

    final bc = data.colorScheme.background;
    final pc = data.colorScheme.surfaceTint;

    final shadow = color.secondary.withOpacity(.2);
    // const shadow = Colors.transparent;

    data = data.copyWith(
      textTheme: GoogleFonts.interTextTheme(data.textTheme),
      iconTheme: data.iconTheme.copyWith(
        color: data.colorScheme.onPrimaryContainer,
      ),
      scaffoldBackgroundColor: isLightMode() ? Colors.white : ElevationOverlay.applySurfaceTint(bc, pc, .5),
      appBarTheme: data.appBarTheme.copyWith(
        color: ElevationOverlay.applySurfaceTint(bc, pc, 2),
        shadowColor: shadow,
      ),
      shadowColor: shadow,
      cardTheme: data.cardTheme.copyWith(
        shadowColor: shadow,
      ),
    );
  }

  bool isLightMode() {
    return mode == ThemeMode.light;
  }

  @override
  bool operator ==(Object other) => false; // ignore: hash_and_equals
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(ThemeState(
          mode: ThemeMode.system,
          color: ColorValue.ocean,
          data: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: ColorValue.ocean.primary,
              secondary: ColorValue.ocean.secondary,
              brightness: ThemeMode.system == ThemeMode.light ? Brightness.light : Brightness.dark,
            ),
            useMaterial3: true,
            brightness: ThemeMode.system == ThemeMode.light ? Brightness.light : Brightness.dark,
          ),
        ));

  Future<void> flipBrightness() async {
    if (state.isLightMode()) {
      state.mode = ThemeMode.dark;
    } else {
      state.mode = ThemeMode.light;
    }

    state.resetThemeData();

    emit(state);
  }

  Future<void> setBrightness(ThemeMode mode) async {
    state.mode = mode;
    state.resetThemeData();
    emit(state);
  }

  Future<void> setColor(ColorValue c) async {
    state.color = c;

    state.resetThemeData();

    emit(state);
  }
}
