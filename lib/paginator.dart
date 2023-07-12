import 'package:dependencecoping/modals/logout.dart';
import 'package:dependencecoping/modals/profile.dart';
import 'package:dependencecoping/modals/login.dart';
import 'package:dependencecoping/modals/register.dart';
import 'package:dependencecoping/tokens/modal.dart';
import 'package:flutter/material.dart';

Function(int) pagginator(BuildContext context) {
  return (int page) {
    openModal(
        context,
        [
          modal(context, 'Login', const LoginModal()),
          modal(context, 'Register', const RegisterModal()),
          modal(context, 'Profile', const ProfileModal()),
          modal(context, 'Logout', const LogoutModal()),
        ][page]);
  };
}
