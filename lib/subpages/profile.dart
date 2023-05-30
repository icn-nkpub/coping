import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // ignore: depend_on_referenced_packages
import 'package:cloudcircle/provider/login/login.dart';
import 'package:cloudcircle/tokens/input.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  DateTime? noSmokingTime;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, Profile?>(builder: (context, u) {
      var cFirstName = TextEditingController(text: u?.profile?.firstName ?? '');
      var cSecondName = TextEditingController(text: u?.profile?.secondName ?? '');
      DateTime lts = noSmokingTime ?? u?.profile?.noSmokingTime ?? DateTime.now();
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
                    Text("Last time: $day, ${lts.hour}:${lts.minute}:${lts.second}"),
                    FilledButton.tonal(onPressed: () => setState(() => noSmokingTime = DateTime.now()), child: const Text("reset"))
                  ],
                ),
              ),
              FilledButton(
                onPressed: () {
                  context.read<LoginCubit>().saveProfile(
                        cFirstName.text,
                        cSecondName.text,
                        noSmokingTime ?? u?.profile?.noSmokingTime ?? DateTime.now(),
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
