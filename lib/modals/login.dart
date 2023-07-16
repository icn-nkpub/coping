import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/tokens/input.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginModal extends StatefulWidget {
  const LoginModal({
    super.key,
  });

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  String errorText = '';

  var cEmail = TextEditingController(text: '');
  var cPwd = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return BlocBuilder<LoginCubit, Profile?>(builder: (context, u) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          child: Column(
            children: [
              Input(title: 'Email', ctrl: cEmail, autocorrect: false),
              const SizedBox(height: 8),
              Input(title: 'Password', ctrl: cPwd, autocorrect: false, obscureText: true),
              if (errorText != '') const SizedBox(height: 8),
              if (errorText != '')
                Text(
                  errorText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
                ),
              Flexible(child: ListView()),
              FilledButton(
                onPressed: () async {
                  try {
                    await context.read<LoginCubit>().signIn(cEmail.text, cPwd.text);
                    if (navigator.canPop()) navigator.pop();
                  } on AuthException catch (error) {
                    setState(() {
                      errorText = error.message;
                    });
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
