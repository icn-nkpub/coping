import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/provider/static/static.dart';
import 'package:dependencecoping/provider/trigger/trigger.dart';
import 'package:dependencecoping/storage/trigger_log.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:dependencecoping/tokens/topbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TriggersScreen extends StatelessWidget {
  const TriggersScreen({
    super.key,
    required this.setPage,
  });

  final void Function(int) setPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TopBar(setPage: setPage),
        Expanded(
          child: ListView(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  'Personal triggers',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              userFolder(),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  'Discover triggers',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              comunityFolder(),
            ],
          ),
        ),
      ],
    );
  }

  Padding userFolder() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<LoginCubit, Profile?>(builder: (context, p) {
        return BlocBuilder<TriggersCubit, Triggers?>(
          builder: (context, triggers) {
            List<Widget> children = [];

            if (triggers != null) {
              children.addAll(
                triggers.data.map(
                  (t) => FilledButton.tonal(
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 8 * 2)),
                    ),
                    onPressed: () {
                      if (p != null) logTrigger(p.auth, t);
                    },
                    child: Text(t.label),
                  ),
                ),
              );
            }

            children.add(
              IconButton.filledTonal(
                style: const ButtonStyle(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 8 * 2)),
                ),
                onPressed: () {},
                icon: const SvgIcon(
                  assetName: 'add',
                ),
              ),
            );

            return Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              runAlignment: WrapAlignment.start,
              runSpacing: 4,
              spacing: 4,
              children: children,
            );
          },
        );
      }),
    );
  }

  Padding comunityFolder() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<LoginCubit, Profile?>(builder: (context, p) {
        return BlocBuilder<StaticCubit, StaticRecords?>(
          builder: (context, s) {
            List<Widget> children = [];

            if (s != null) {
              children.addAll(
                s.triggers.map(
                  (t) => FilledButton.tonal(
                    style: const ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 8 * 2)),
                    ),
                    onPressed: () {
                      if (p != null) context.read<TriggersCubit>().toggle(p.auth, t);
                    },
                    child: Text(t.label),
                  ),
                ),
              );
            }

            return Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              runAlignment: WrapAlignment.start,
              runSpacing: 4,
              spacing: 4,
              children: children,
            );
          },
        );
      }),
    );
  }
}
