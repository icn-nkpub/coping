import 'package:sca6/pages/main/page.dart';
import 'package:sca6/pages/main/pages/logout.dart';
import 'package:sca6/pages/main/pages/profile.dart';
import 'package:sca6/pages/main/pages/login.dart';
import 'package:sca6/pages/main/pages/register.dart';
import 'package:sca6/tokens/icons.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainPage(
      setPage: (page) {
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
      },
    );
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
                    icon: const SvgIcon(assetName: "close"),
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
}
