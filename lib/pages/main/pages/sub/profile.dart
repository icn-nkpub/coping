import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca6/provider/login/login.dart';
import 'package:sca6/tokens/input.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, Profile?>(builder: (context, u) {
      var cFirstName = TextEditingController(text: u?.profile?.firstName ?? "");
      var cSecondName =
          TextEditingController(text: u?.profile?.secondName ?? "");

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          child: Column(
            children: [
              Input(title: "First name", ctrl: cFirstName),
              const SizedBox(height: 8),
              Input(title: "Second name", ctrl: cSecondName),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {
                  context
                      .read<LoginCubit>()
                      .saveProfile(cFirstName.text, cSecondName.text);
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Save"),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
