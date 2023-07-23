import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dependencecoping/provider/login/login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              Text(AppLocalizations.of(context)!.clearStorageWarning),
              Flexible(child: ListView()),
              FilledButton(
                onPressed: () {
                  context.read<LoginCubit>().signOut();
                  if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(AppLocalizations.of(context)!.clearStorage),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
