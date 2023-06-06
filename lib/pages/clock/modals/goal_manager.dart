import 'package:cloudcircle/provider/goal/goal.dart';
import 'package:cloudcircle/provider/static/static.dart';
import 'package:cloudcircle/storage/goal.dart';
import 'package:cloudcircle/tokens/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      widgets.add(_divider(context, 'Featured goals'));
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
              child: const Text("Save")),
        ]),
      );
    });
  }

  Row _togglableGoal(BuildContext context, Goal g) {
    return Row(
      children: [
        Checkbox(
          value: _isToggled(g),
          onChanged: _toggle(g),
        ),
        Column(
          children: [
            Text('${g.title} by ${g.author}'),
          ],
        ),
        const Expanded(child: SizedBox()),
        SvgIcon(
          assetName: g.iconName,
          color: Theme.of(context).colorScheme.primary.withOpacity(.5),
        ),
        const SizedBox(
          width: 16,
        )
      ],
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

  Column _divider(BuildContext context, String name) {
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
