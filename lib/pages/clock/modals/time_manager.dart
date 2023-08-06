import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/provider/countdown/countdown.dart';
import 'package:dependencecoping/provider/static/static.dart';
import 'package:dependencecoping/provider/theme/fonts.dart';
import 'package:dependencecoping/storage/reset_log.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const enableEdit = false;

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
  Widget build(final BuildContext context) {
    final List<CountdownEvent> c = [];

    for (final element in resets.reversed) {
      if (element.resumeTime != null) c.add(CountdownEvent(id: element.id, resume: true, time: element.resumeTime!));
      c.add(CountdownEvent(id: element.id, resume: false, time: element.resetTime));
    }

    return BlocBuilder<StaticCubit, StaticRecords?>(
        builder: (final context, final staticRec) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(children: [
                Flexible(
                  child: ListView(
                    children: c.map(record).toList(),
                  ),
                ),
                if (enableEdit)
                  FilledButton(
                    onPressed: () {
                      if (Navigator.of(context).canPop() && widget.auth != null) {
                        context.read<CountdownTimerCubit>().overwrite(resets);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(AppLocalizations.of(context)!.timeManagerSave),
                  ),
              ]),
            ));
  }

  Widget record(final CountdownEvent r) => TimerJournalCard(
        resume: r.resume,
        dateText: DateFormat('dd.MM.yyyy HH:mm:ss').format(r.time),
        onEditPressed: () async {
          final c = context.read<CountdownTimerCubit>();
          final v = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(r.time),
          );
          if (v == null) return;

          if (widget.auth != null) {
            final t = r.time..copyWith(hour: v.hour, minute: v.minute);

            if (r.resume) {
              await c.editResume(widget.auth!, r.id, t);
            } else {
              await c.editReset(widget.auth!, r.id, t);
            }
          }
        },
      );
}

class TimerJournalCard extends StatelessWidget {
  const TimerJournalCard({
    required this.resume,
    required this.dateText,
    required this.onEditPressed,
    super.key,
  });

  final bool resume;
  final String dateText;
  final Future<void> Function() onEditPressed;

  @override
  Widget build(final BuildContext context) {
    final tsm = fAccent(
      textStyle: Theme.of(context).textTheme.titleSmall,
    ).copyWith(
      color: resume ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onTertiaryContainer,
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                flex: 0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: resume
                      ? SvgIcon(
                          assetPath: Assets.icons.playArrow,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        )
                      : SvgIcon(
                          assetPath: Assets.icons.stop,
                          color: Theme.of(context).colorScheme.onTertiaryContainer,
                        ),
                )),
            Flexible(
              child: Align(
                alignment: enableEdit ? Alignment.centerLeft : Alignment.centerRight,
                child: Text(
                  dateText,
                  style: tsm,
                ),
              ),
            ),
            if (enableEdit)
              Flexible(
                flex: 0,
                child: IconButton(
                  onPressed: onEditPressed,
                  icon: SvgIcon(
                    assetPath: Assets.icons.edit,
                    color: resume ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onTertiaryContainer,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class CountdownEvent {
  const CountdownEvent({
    required this.id,
    required this.resume,
    required this.time,
  });

  final int id;
  final bool resume;
  final DateTime time;
}
