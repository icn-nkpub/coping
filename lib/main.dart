import 'dart:async';
import 'dart:core';

import 'package:dependencecoping/gen/assets.gen.dart';
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

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://tcqkyokyndgebhcybfhx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRjcWt5b2t5bmRnZWJoY3liZmh4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODU0NjUxOTMsImV4cCI6MjAwMTA0MTE5M30.Nd9M8OSPkIW2zjj_wJjPCBJi8NEApMise-W8nYso1Tw',
  );

  await notifications();

  final GlobalKey<NavigatorState> mainNavigatorKey = GlobalKey<NavigatorState>();

  final app = MaterialApp(
    navigatorKey: mainNavigatorKey,
    debugShowCheckedModeBanner: false,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    title: 'Coping',
    home: App(),
  );

  if (kDebugMode) {
    imageCache.clear();
    runApp(app);
    return;
  }

  await SentryFlutter.init((final options) {
    options.dsn = 'https://ffce3775524c43269e47662942503a06@o4505302255665152.ingest.sentry.io/4505302260449280';
    // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
    // We recommend adjusting this value in production.
    options.tracesSampleRate = 1;
  }, appRunner: () => runApp(app));
}

class App extends StatefulWidget {
  App({super.key});

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with AssetsInitializer, TickerProviderStateMixin {
  late final AnimationController _spinnerController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat();
  bool _spinnerActive = true;

  @override
  void dispose() {
    _spinnerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 100), () {
      WidgetsBinding.instance.addPostFrameCallback((final _) {
        if (tryLock()) {
          unawaited(init(() {
            setState(() {
              _spinnerActive = false;
            });
          }));
        }
      });
    });
  }

  @override
  Widget build(final BuildContext context) => Container(
        color: Colors.black,
        child: _spinnerActive
            ? Center(
                child: AnimatedBuilder(
                  animation: _spinnerController,
                  builder: (final context, final _) => Opacity(
                    opacity: _spinnerController.value,
                    child: ColorFiltered(
                      colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcATop),
                      child: Image.asset(Assets.opaqring.path, width: 148, height: 148),
                    ),
                  ),
                ),
              )
            : Builder(builder: (final context) {
                final loginCubit = LoginCubit();
                if (user != null) {
                  loginCubit.overwrite(user!, profile);
                }

                final staticCubit = StaticCubit();
                if (!statics.isEmpty) {
                  staticCubit.overwrite(statics);
                }

                final tcb = MediaQuery.of(context).platformBrightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;
                final themeCubit = ThemeCubit()..setBrightness(tcb);
                if (profile != null && profile!.isLight != null) {
                  themeCubit.setBrightness(profile!.isLight! ? ThemeMode.light : ThemeMode.dark);
                }
                if (profile != null && profile!.color != null) {
                  themeCubit.setColor(findThemeColor(profile!.color!));
                }

                final countdownTimerCubit = CountdownTimerCubit();
                if (resets != null) {
                  countdownTimerCubit.overwrite(resets!);
                }

                final goalsCubit = GoalsCubit();
                if (goals != null) {
                  goalsCubit.overwrite(Goals(goals!));
                }

                final triggersCubit = TriggersCubit();
                if (triggers != null) {
                  if (triggersLog == null) {
                    triggersCubit.overwrite(Triggers(triggers!, []));
                  } else {
                    triggersCubit.overwrite(Triggers(triggers!, triggersLog!));
                  }
                }

                return MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (final _) => loginCubit),
                    BlocProvider(create: (final _) => staticCubit),
                    BlocProvider(create: (final _) => themeCubit),
                    BlocProvider(create: (final _) => countdownTimerCubit),
                    BlocProvider(create: (final _) => goalsCubit),
                    BlocProvider(create: (final _) => triggersCubit),
                  ],
                  child: BlocListener<LoginCubit, Profile?>(
                    listenWhen: (final p, final c) => (!initOK) && (p?.auth.id != c?.auth.id),
                    listener: (final context, final state) => unawaited(reset(() {
                      // todo
                    })),
                    child: BlocBuilder<ThemeCubit, ThemeState>(
                      builder: (final context, final state) => Theme(
                        data: state.data,
                        child: BlocBuilder<LoginCubit, Profile?>(
                          builder: (final context, final u) => Navigator(
                            onGenerateRoute: (final settings) => MaterialPageRoute(
                              settings: settings,
                              builder: (final context) => u == null ? const Onboarding() : const Home(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
      );
}
