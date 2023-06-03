import 'package:cloudcircle/modals/logout.dart';
import 'package:cloudcircle/modals/profile.dart';
import 'package:cloudcircle/modals/login.dart';
import 'package:cloudcircle/modals/register.dart';
import 'package:cloudcircle/tokens/icons.dart';
import 'package:flutter/material.dart';

Function(int) pagginator(BuildContext context) {
  return (int page) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return [
          _withBack(context, const LoginPage()),
          _withBack(context, const RegisterPage()),
          _withBack(context, const ProfilePage()),
          _withBack(context, const LogoutPage()),
        ][page];
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
          child: child,
        );
      },
    ));
  };
}

Widget _withBack(BuildContext context, Widget w) {
  return Scaffold(
    appBar: AppBar(
      toolbarHeight: 0,
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const SvgIcon(assetName: 'close'),
                ),
              ],
            ),
          ),
          w,
        ],
      ),
    ),
  );
}
