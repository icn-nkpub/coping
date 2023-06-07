import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloudcircle/provider/login/login.dart';
import 'package:cloudcircle/tokens/input.dart';

class RegisterModal extends StatelessWidget {
  const RegisterModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var cEmail = TextEditingController(text: '');
    var cPwd = TextEditingController(text: '');

    return BlocBuilder<LoginCubit, Profile?>(builder: (context, u) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          child: Column(
            children: [
              Input(title: 'Email', ctrl: cEmail),
              const SizedBox(height: 8),
              Input(title: 'Password', ctrl: cPwd),
              Flexible(child: ListView()),
              FilledButton(
                onPressed: () {
                  context.read<LoginCubit>().signUp(cEmail.text, cPwd.text);
                  if (Navigator.of(context).canPop()) Navigator.of(context).pop();
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
