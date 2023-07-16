import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/tokens/input.dart';
import 'package:supabase/supabase.dart';

class RegisterModal extends StatefulWidget {
  const RegisterModal({
    super.key,
  });

  @override
  State<RegisterModal> createState() => _RegisterModalState();
}

class _RegisterModalState extends State<RegisterModal> {
  String errorText = '';

  var cEmail = TextEditingController(text: '');
  var cPwd = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, Profile?>(builder: (context, u) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          child: Column(
            children: [
              Input(title: 'Email', ctrl: cEmail, autocorrect: false),
              const SizedBox(height: 8),
              Input(title: 'Password', ctrl: cPwd, autocorrect: false, obscureText: true),
              Flexible(child: ListView()),
              FilledButton(
                onPressed: () async {
                  try {
                    final n = Navigator.of(context);
                    await context.read<LoginCubit>().signUp(cEmail.text, cPwd.text);
                    if (n.canPop()) n.pop();
                  } on AuthException catch (error) {
                    setState(() {
                      errorText = error.message;
                    });
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Register'),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
