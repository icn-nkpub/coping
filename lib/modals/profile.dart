import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // ignore: depend_on_referenced_packages
import 'package:cloudcircle/provider/login/login.dart';
import 'package:cloudcircle/tokens/input.dart';

class ProfileModal extends StatefulWidget {
  const ProfileModal({
    super.key,
  });

  @override
  State<ProfileModal> createState() => _ProfileModalState();
}

class _ProfileModalState extends State<ProfileModal> {
  DateTime? noAddictionTime;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, Profile?>(builder: (context, u) {
      var cFirstName = TextEditingController(text: u?.profile?.firstName ?? '');
      var cSecondName = TextEditingController(text: u?.profile?.secondName ?? '');
      DateTime lts = noAddictionTime ?? u?.profile?.noAddictionTime ?? DateTime.now();
      String day = DateFormat.MMMMEEEEd('en').format(lts);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          child: Column(
            children: [
              Input(title: 'First name', ctrl: cFirstName),
              const SizedBox(height: 8),
              Input(title: 'Second name', ctrl: cSecondName),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Last time: $day, ${lts.hour}:${lts.minute}:${lts.second}'),
                    FilledButton.tonal(onPressed: () => setState(() => noAddictionTime = DateTime.now()), child: const Text('reset'))
                  ],
                ),
              ),
              Flexible(child: ListView()),
              FilledButton(
                onPressed: () {
                  context.read<LoginCubit>().saveProfile(
                        cFirstName.text,
                        cSecondName.text,
                        noAddictionTime,
                      );
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
