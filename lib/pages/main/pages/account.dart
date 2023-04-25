import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca6/provider/login/login.dart';
import 'package:sca6/tokens/cardrope.dart';
import 'package:sca6/tokens/input.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var cEmail = TextEditingController(text: "test@sca-6.org");
    var cPwd = TextEditingController(text: "test");

    return BlocBuilder<LoginCubit, Profile?>(builder: (context, u) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          child: Column(
            children: [
              Input(title: "Email", ctrl: cEmail),
              const SizedBox(height: 8),
              Input(title: "Password", ctrl: cPwd),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  context.read<LoginCubit>().signIn(cEmail.text, cPwd.text);
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Login"),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
