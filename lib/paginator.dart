import 'package:dependencecoping/modals/logout.dart';
import 'package:dependencecoping/modals/profile.dart';
import 'package:dependencecoping/modals/login.dart';
import 'package:dependencecoping/modals/register.dart';
import 'package:dependencecoping/tokens/modal.dart';
import 'package:flutter/material.dart';

Function(int) pagginator(BuildContext context) {
  return (int page) {
    Navigator.of(context).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return [
          modal(context, const LoginModal()),
          modal(context, const RegisterModal()),
          modal(context, const ProfileModal()),
          modal(context, const LogoutModal()),
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
