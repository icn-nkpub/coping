import 'package:dependencecoping/provider/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpModal extends StatelessWidget {
  const HelpModal({
    super.key,
  });

  @override
  Widget build(final BuildContext context) => BlocBuilder<LoginCubit, Profile?>(
        builder: (final context, final u) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text('123'),
        ),
      );
}
