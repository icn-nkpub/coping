import 'dart:async';
import 'dart:core';

import 'package:dependencecoping/home.dart';
import 'package:dependencecoping/notifications.dart';
import 'package:dependencecoping/onboarding.dart';
import 'package:dependencecoping/provider/countdown/countdown.dart';
import 'package:dependencecoping/provider/goal/goal.dart';
import 'package:dependencecoping/provider/login/login.dart';
import 'package:dependencecoping/provider/static/static.dart';
import 'package:dependencecoping/provider/theme/colors.dart';
import 'package:dependencecoping/provider/theme/theme.dart';
import 'package:dependencecoping/provider/trigger/trigger.dart';
import 'package:dependencecoping/storage/init.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://tcqkyokyndgebhcybfhx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRjcWt5b2t5bmRnZWJoY3liZmh4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODU0NjUxOTMsImV4cCI6MjAwMTA0MTE5M30.Nd9M8OSPkIW2zjj_wJjPCBJi8NEApMise-W8nYso1Tw',
  );

  notifications();

  const app = App();

  if (kDebugMode) {
    imageCache.clear();
    runApp(app);
    return;
  }

  await SentryFlutter.init(
    (final options) {
      options.dsn = 'https://ffce3775524c43269e47662942503a06@o4505302255665152.ingest.sentry.io/4505302260449280';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1;
    },
    appRunner: () => runApp(app),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with AssetsInitializer {
  @override
  Widget build(final BuildContext context) {
    if (tryLock()) {
      unawaited(init(context));
    }

    if (loadingState != LoadingProgress.done) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Container(
          color: Colors.black,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      );
    }

    final tcb = MediaQuery.of(context).platformBrightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (final _) {
          final c = LoginCubit();
          if (user == null) {
            return c;
          }

          c.overwrite(user!, profile);

          return c;
        }),
        BlocProvider(create: (final _) {
          final c = StaticCubit();
          if (statics.isEmpty) {
            return c;
          }

          c.overwrite(statics);

          return c;
        }),
        BlocProvider(create: (final _) {
          final c = ThemeCubit()..setBrightness(tcb);
          if (profile == null) {
            return c;
          }

          if (profile != null && profile!.isLight != null) {
            c.setBrightness(profile!.isLight! ? ThemeMode.light : ThemeMode.dark);
          }
          if (profile != null && profile!.color != null) {
            c.setColor(findThemeColor(profile!.color!));
          }

          return c;
        }),
        BlocProvider(create: (final _) {
          final c = CountdownTimerCubit();
          if (resets == null) {
            return c;
          }

          c.overwrite(resets!);

          return c;
        }),
        BlocProvider(create: (final _) {
          final c = GoalsCubit();
          if (goals == null) {
            return c;
          }

          c.overwrite(Goals(goals!));

          return c;
        }),
        BlocProvider(create: (final _) {
          final c = TriggersCubit();
          if (triggers == null) {
            return c;
          }

          if (triggersLog == null) {
            c.overwrite(Triggers(triggers!, []));
            return c;
          }

          c.overwrite(Triggers(triggers!, triggersLog!));

          return c;
        }),
      ],
      child: BlocListener<LoginCubit, Profile?>(
        listenWhen: (final p, final c) => (!initOK) && (p?.auth.id != c?.auth.id),
        listener: (final context, final state) => unawaited(reset(context)),
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (final context, final state) => MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            title: 'Coping',
            theme: state.data,
            home: BlocBuilder<LoginCubit, Profile?>(builder: (final context, final u) => u == null ? const Onboarding() : const Home()),
          ),
        ),
      ),
    );
  }
}
