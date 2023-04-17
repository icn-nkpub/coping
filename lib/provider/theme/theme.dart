import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ColorValue { red, green, blue }

Color themeColor(ColorValue c) {
  switch (c) {
    case ColorValue.red:
      return Colors.red;
    case ColorValue.green:
      return Colors.green;
    case ColorValue.blue:
      return Colors.blue;
  }
}

class ThemeState {
  ThemeState({
    required this.mode,
    required this.data,
    required this.color,
  });

  ThemeMode mode;
  ThemeData data;
  Color color;

  resetThemeData() {
    data = ThemeData(
      colorSchemeSeed: color,
      useMaterial3: true,
      brightness: isLightMode() ? Brightness.light : Brightness.dark,
    );
  }

  bool isLightMode() {
    switch (mode) {
      case ThemeMode.system:
        return SchedulerBinding.instance.window.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  @override
  bool operator ==(Object other) => false;
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit()
      : super(ThemeState(
          mode: ThemeMode.system,
          color: Colors.red,
          data: ThemeData(
            colorSchemeSeed: Colors.red,
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

  Future<void> setColor(ColorValue c) async {
    state.color = themeColor(c);

    state.resetThemeData();

    emit(state);
  }
}
