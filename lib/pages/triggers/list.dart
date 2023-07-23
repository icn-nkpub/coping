import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/pages/triggers/impulse.dart';
import 'package:dependencecoping/pages/triggers/modals/personal.dart';
import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/provider/theme/fonts.dart';
import 'package:dependencecoping/provider/trigger/trigger.dart';
import 'package:dependencecoping/storage/trigger.dart';
import 'package:dependencecoping/tokens/icons.dart';
import 'package:dependencecoping/tokens/input.dart';
import 'package:dependencecoping/tokens/modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TriggerList extends StatefulWidget {
  const TriggerList({
    super.key,
  });

  @override
  State<TriggerList> createState() => _TriggerListState();
}

class _TriggerListState extends State<TriggerList> with TickerProviderStateMixin {
  late final _c = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat();

  var situation = TextEditingController();
  var thought = TextEditingController();
  int impulse = 3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<LoginCubit, Profile?>(builder: (context, p) {
        return BlocBuilder<TriggersCubit, Triggers?>(
          builder: (context, triggers) {
            List<Widget> children = [];

            if (triggers != null) {
              children.addAll(
                triggers.templates.map(
                  (t) => FilledButton.tonal(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.tertiaryContainer),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 8 * 2)),
                    ),
                    onLongPress: () {
                      if (p?.auth != null) context.read<TriggersCubit>().removePersonal(p!.auth, t.id);
                    },
                    onPressed: () {
                      openModal(context, modal(context, AppLocalizations.of(context)!.modalLogTrigger, triggerModal(t)));
                    },
                    child: Text(t.labels[Localizations.localeOf(context).languageCode] ?? t.labels["en"] ?? "[...]"),
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
                onPressed: () {
                  openModal(context, modal(context, AppLocalizations.of(context)!.modalAddPersonalTrigger, const PersonalTriggerFormModal()));
                },
                icon: SvgIcon(
                  assetPath: Assets.icons.add,
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

  Padding triggerModal(Trigger t) {
    final navigator = Navigator.of(context);

    var g = LinearGradient(colors: [
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.primary,
      Theme.of(context).colorScheme.tertiary,
    ]);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8 * 4),
            child: Center(
              child: AnimatedBuilder(
                animation: _c,
                child: Text(
                  t.labels[Localizations.localeOf(context).languageCode] ?? t.labels["en"] ?? "[...]",
                  style: fAccent(
                    textStyle: Theme.of(context).textTheme.displaySmall,
                  ).copyWith(fontWeight: FontWeight.w900),
                ),
                builder: (context, child) {
                  return ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => g.createShader(
                      Rect.fromLTWH((bounds.width) * (1 - (_c.value * 2)).abs(), 0, bounds.width / 2, bounds.height),
                    ),
                    child: child,
                  );
                },
              ),
            ),
          ),
          Input(title: AppLocalizations.of(context)!.personalTriggerSituation, ctrl: situation, autocorrect: true),
          const SizedBox(height: 8),
          Input(title: AppLocalizations.of(context)!.personalTriggerThought, ctrl: thought, autocorrect: true),
          const SizedBox(height: 8 * 4),
          ImpulseSlider(
            title: AppLocalizations.of(context)!.personalTriggerImpulse,
            callback: (i) => setState(() => impulse = i.round()),
          ),
          Flexible(child: ListView()),
          FilledButton(
            onPressed: () async {
              var p = context.read<LoginCubit>().state;
              if (p != null) context.read<TriggersCubit>().send(p.auth, t, situation.value.text, thought.value.text, impulse);
              if (navigator.canPop()) navigator.pop();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(AppLocalizations.of(context)!.personalTriggerSubmit),
            ),
          ),
        ],
      ),
    );
  }
}
