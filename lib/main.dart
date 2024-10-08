import 'dart:async';
import 'dart:core';

import 'package:dependencecoping/gen/assets.gen.dart';
import 'package:dependencecoping/home.dart';
import 'package:dependencecoping/init.dart';
import 'package:dependencecoping/notifications.dart';
import 'package:dependencecoping/provider/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  await notifications();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(ThemeStateAdapter());
  await Hive.openBox<ThemeState>('ThemeState');

  final app = App();

  if (kDebugMode) {
    imageCache.clear();
    runApp(app);
    return;
  }

  await SentryFlutter.init((final options) {
    options.dsn =
        'https://ffce3775524c43269e47662942503a06@o4505302255665152.ingest.sentry.io/4505302260449280';
    // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
    // We recommend adjusting this value in production.
    options.tracesSampleRate = 1;
  }, appRunner: () => runApp(app));
}

class App extends StatefulWidget {
  App({super.key});

  final GlobalKey<NavigatorState> mainNavigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App>
    with AssetsInitializer, TickerProviderStateMixin {
  late final AnimationController _spinnerController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  );
  bool _spinnerActive = true;

  @override
  void dispose() {
    _spinnerController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _spinnerController.repeat();
    Timer(const Duration(milliseconds: 200), () {
      WidgetsBinding.instance.addPostFrameCallback((final _) {
        if (tryLock()) {
          unawaited(init(() {
            setState(() {
              _spinnerActive = false;
            });
            FlutterNativeSplash.remove();
          }));
        }
      });
    });
  }

  @override
  Widget build(final BuildContext context) => MaterialApp(
        navigatorKey: widget.mainNavigatorKey,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        title: 'Coping',
        home: Container(
          color: Colors.black,
          child: _spinnerActive
              ? Center(
                  child: AnimatedBuilder(
                    animation: _spinnerController,
                    builder: (final context, final _) => Opacity(
                      opacity: ((final double x) =>
                          (x <= .5 ? x : 1 - x) * 2)(_spinnerController.value),
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                            Colors.grey, BlendMode.srcATop),
                        child: Image.asset(Assets.opaqring.path,
                            width: 148, height: 148),
                      ),
                    ),
                  ),
                )
              : ValueListenableBuilder<Box<ThemeState>>(
                  valueListenable:
                      Hive.box<ThemeState>('ThemeState').listenable(),
                  builder: (final context, final box, final _) {
                    final s = (box.length > 0 ? box.getAt(0) : null) ??
                        defaultThemeState(context);
                    return AnimatedTheme(
                      data: s.data!,
                      curve: Curves.slowMiddle,
                      duration: const Duration(milliseconds: 100),
                      child: Navigator(
                        onGenerateRoute: (final settings) => MaterialPageRoute(
                          settings: settings,
                          builder: (final context) => const Home(),
                        ),
                      ),
                    );
                  }),
        ),
      );
}
