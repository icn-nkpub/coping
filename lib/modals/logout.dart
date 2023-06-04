import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloudcircle/provider/login/login.dart';

class LogoutModal extends StatelessWidget {
  const LogoutModal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, Profile?>(builder: (context, u) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          child: Column(
            children: [
              Text('${u?.profile?.firstName ?? 'Please'}, confirm that you want to logout.'),
              const SizedBox(
                height: 16,
              ),
              FilledButton(
                onPressed: () {
                  context.read<LoginCubit>().signOut();
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
