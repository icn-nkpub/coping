import 'package:dependencecoping/modals/help_pages/intro.dart';
import 'package:dependencecoping/provider/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpModal extends StatelessWidget {
  const HelpModal({
    super.key,
  });

  @override
  Widget build(final BuildContext context) => BlocBuilder<LoginCubit, Profile?>(
        builder: (final context, final u) {
          final t = Theme.of(context);
          final s = (MediaQuery.of(context).size.width / 8).roundToDouble();

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            width: double.maxFinite,
            child: ListView(
              children: [
                Container(
                  // padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: t.colorScheme.primaryContainer),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  // clipBehavior: Clip.antiAlias,
                  child: IntroHelpPage(t: t, s: s),
                ),
              ],
            ),
          );
        },
      );
}
