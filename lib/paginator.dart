import 'package:dependencecoping/modals/logout.dart';
import 'package:dependencecoping/modals/profile.dart';
import 'package:dependencecoping/modals/login.dart';
import 'package:dependencecoping/modals/register.dart';
import 'package:dependencecoping/tokens/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Function(int) pagginator(BuildContext context) {
  return (int page) {
    openModal(
        context,
        [
          modal(context, AppLocalizations.of(context)!.screenLogin, const LoginModal()),
          modal(context, AppLocalizations.of(context)!.screenRegister, const RegisterModal()),
          modal(context, AppLocalizations.of(context)!.screenProfile, const ProfileModal()),
          modal(context, AppLocalizations.of(context)!.screenLogout, const LogoutModal()),
        ][page]);
  };
}
