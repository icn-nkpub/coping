import 'package:dependencecoping/provider/goal/goal.dart';
import 'package:dependencecoping/provider/static/static.dart';
import 'package:dependencecoping/storage/goal.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GoalModal extends StatefulWidget {
  const GoalModal({
    super.key,
    this.auth,
  });

  final User? auth;

  @override
  State<GoalModal> createState() => _GoalModalState();
}

class _GoalModalState extends State<GoalModal> {
  List<Goal> goals = [];

  @override
  void initState() {
    final settings = BlocProvider.of<GoalsCubit>(context);
    if (settings.state != null) goals.addAll(settings.state!.data);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaticCubit, StaticRecords?>(builder: (context, staticRec) {
      List<Widget> widgets = [];
      widgets.addAll(staticRec!.goals.map((g) => _togglableGoal(context, g)));

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(children: [
          Flexible(
            child: ListView(
              children: widgets,
            ),
          ),
          FilledButton(
              onPressed: () {
                if (widget.auth != null) context.read<GoalsCubit>().set(widget.auth!, Goals(goals));
                if (Navigator.of(context).canPop()) Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.goalsSave)),
        ]),
      );
    });
  }

  Widget _togglableGoal(BuildContext context, Goal g) {
    return Card(
      child: Row(
        children: [
          Checkbox(
            value: _isToggled(g),
            onChanged: _toggle(g),
          ),
          Expanded(
            child: Text(
              g.title,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SvgIcon(
              assetPath: 'assets/icons/${g.iconName}.svg',
              color: Theme.of(context).colorScheme.primary.withOpacity(.5),
            ),
          ),
        ],
      ),
    );
  }

  bool _isToggled(Goal g) => goals.where((element) => element.id == g.id).isNotEmpty;

  _toggle(Goal g) => (bool? v) {
        if (v == null) {
          return;
        }

        if (v) {
          setState(() {
            goals.add(g);
          });
          return;
        }

        setState(() {
          goals.removeWhere((element) => element.id == g.id);
        });
      };

  Column divider(BuildContext context, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            name,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }
}
