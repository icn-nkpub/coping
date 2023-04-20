import 'package:sca6/pages/main/pages/login.dart';
import 'package:sca6/pages/main/pages/main.dart';
import 'package:sca6/tokens/icons.dart';
import 'package:sca6/provider/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca6/provider/theme/colors.dart';
import 'package:sca6/provider/theme/theme.dart';
import 'package:sca6/tokens/select.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return [
      MainPage(setPage: (x) => setState(() => page = x)),
      LoginPage(back: () => setState(() => page = 0)),
      LogoutPage(back: () => setState(() => page = 0)),
    ][page];
  }
}
