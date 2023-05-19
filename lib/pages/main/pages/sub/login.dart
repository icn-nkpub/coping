import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca6/provider/login/login.dart';
import 'package:sca6/tokens/input.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errorText = "";

  var cEmail = TextEditingController(text: "w@w.c");
  var cPwd = TextEditingController(text: "12345678");

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return BlocBuilder<LoginCubit, Profile?>(builder: (context, u) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          child: Column(
            children: [
              Input(title: "Email", ctrl: cEmail),
              const SizedBox(height: 8),
              Input(title: "Password", ctrl: cPwd),
              if (errorText != "") const SizedBox(height: 8),
              if (errorText != "")
                Text(
                  errorText,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Theme.of(context).hintColor),
                ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  try {
                    await context
                        .read<LoginCubit>()
                        .signIn(cEmail.text, cPwd.text);
                    navigator.pop();
                  } on AuthException catch (error) {
                    setState(() {
                      errorText = error.message;
                    });
                  }
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
