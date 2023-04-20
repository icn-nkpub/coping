import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca6/provider/login/login.dart';
import 'package:sca6/tokens/input.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
    required this.back,
  });
  final void Function() back;

  @override
  Widget build(BuildContext context) {
    var cEmail = TextEditingController(text: "test@sca-6.org");
    var cPwd = TextEditingController(text: "test");

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Input(title: "Email", ctrl: cEmail),
          const SizedBox(height: 8),
          Input(title: "Password", ctrl: cPwd),
          const SizedBox(height: 16),
          BlocBuilder<LoginCubit, Profile?>(builder: (context, u) {
            return FilledButton(
              onPressed: () {
                context.read<LoginCubit>().signIn(cEmail.text, cPwd.text);
                back();
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("Login"),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class LogoutPage extends StatelessWidget {
  const LogoutPage({
    super.key,
    required this.back,
  });
  final void Function() back;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, Profile?>(builder: (context, u) {
      return TextButton(
        onPressed: () {
          context.read<LoginCubit>().signOut();
          back();
        },
        child: Text("Logout"),
      );
    });
  }
}
