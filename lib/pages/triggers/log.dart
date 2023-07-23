import 'package:dependencecoping/pages/triggers/modals/log_event.dart';
import 'package:dependencecoping/storage/trigger_log.dart';
import 'package:dependencecoping/tokens/modal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class TriggerLogCard extends StatelessWidget {
  const TriggerLogCard(
    this.tl, {
    super.key,
  });

  final TriggerLog tl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 16),
          child: Row(
            children: [
              IconButton.filledTonal(
                onPressed: () {
                  openModal(context, modal(context, AppLocalizations.of(context)!.modalTriggerLogEvent, TriggerLogEventModal(tl: tl)));
                },
                icon: Text(
                  tl.impulse.toString().replaceAll('0', 'O'),
                  style: GoogleFonts.spaceMono(
                    textStyle: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text(
                    tl.label,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    DateFormat("dd.MM.yyyy HH:mm").format(tl.time).replaceAll('0', 'O'),
                    style: GoogleFonts.spaceMono(
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                    ).copyWith(fontWeight: FontWeight.w100),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
