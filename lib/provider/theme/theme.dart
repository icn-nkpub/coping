import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca6/provider/theme/colors.dart';
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
      colorSchemeSeed: themeColor(color),
      useMaterial3: true,
      brightness: isLightMode() ? Brightness.light : Brightness.dark,
    );
    data = data.copyWith(
      textTheme: GoogleFonts.latoTextTheme(data.textTheme),
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
            colorSchemeSeed: themeColor(ColorValue.ocean),
            useMaterial3: true,
            brightness: ThemeMode.system == ThemeMode.light
                ? Brightness.light
                : Brightness.dark,
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
