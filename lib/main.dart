import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cloudcircle/provider/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloudcircle/provider/theme/colors.dart';
import 'package:cloudcircle/provider/theme/theme.dart';
import 'package:cloudcircle/storage/local.dart';
import 'package:cloudcircle/storage/profiles.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://tcqkyokyndgebhcybfhx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRjcWt5b2t5bmRnZWJoY3liZmh4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODU0NjUxOTMsImV4cCI6MjAwMTA0MTE5M30.Nd9M8OSPkIW2zjj_wJjPCBJi8NEApMise-W8nYso1Tw',
  );

  User? u = await restoreAuthInfo();
  ProfileRecord? p;
  if (u != null) {
    p = await getProfile(u);
  }

  runApp(App(u, p));
}

class App extends StatelessWidget {
  const App(this.u, this.p, {super.key});

  final User? u;
  final ProfileRecord? p;

  @override
  Widget build(BuildContext context) {
    final tcb = MediaQuery.of(context).platformBrightness == Brightness.light ? ThemeMode.light : ThemeMode.dark;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) {
          var c = LoginCubit();
          if (u == null) {
            return c;
          }

          c.overwrite(u!, p);

          return c;
        }),
        BlocProvider(create: (_) {
          var c = ThemeCubit()..setBrightness(tcb);
          if (p == null) {
            return c;
          }

          if (p != null && p!.isLight != null) {
            c.setBrightness(p!.isLight! ? ThemeMode.light : ThemeMode.dark);
          }
          if (p != null && p!.color != null) {
            c.setColor(findThemeColor(p!.color!));
          }

          return c;
        }),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
          title: 'SCA-6',
          theme: state.data,
          home: const Home(),
        ),
      ),
    );
  }
}
