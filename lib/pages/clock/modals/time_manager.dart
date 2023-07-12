import 'package:dependencecoping/provider/countdown/countdown.dart';
import 'package:dependencecoping/provider/static/static.dart';
import 'package:dependencecoping/storage/reset_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TimeModal extends StatefulWidget {
  const TimeModal({
    super.key,
    this.auth,
  });

  final User? auth;

  @override
  State<TimeModal> createState() => _TimeModalState();
}

class _TimeModalState extends State<TimeModal> {
  List<CountdownReset> resets = [];

  @override
  void initState() {
    final settings = BlocProvider.of<CountdownTimerCubit>(context);
    if (settings.state != null) resets.addAll(settings.state!.resets);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaticCubit, StaticRecords?>(builder: (context, staticRec) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(children: [
          Flexible(
            child: ListView(
              children: resets.map((r) => Text('${r.resetTime} - ${r.resumeTime}')).toList(),
            ),
          ),
          FilledButton(
              onPressed: () {
                if (widget.auth != null) context.read<CountdownTimerCubit>().overwrite(resets);
                if (Navigator.of(context).canPop()) Navigator.of(context).pop();
              },
              child: const Text('Save')),
        ]),
      );
    });
  }
}
