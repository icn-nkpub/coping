import 'dart:developer';

import 'package:dependencecoping/provider/static/static.dart';
import 'package:dependencecoping/storage/goal.dart';
import 'package:dependencecoping/storage/local.dart';
import 'package:dependencecoping/storage/profiles.dart';
import 'package:dependencecoping/storage/reset_log.dart';
import 'package:dependencecoping/storage/static.dart';
import 'package:dependencecoping/storage/trigger.dart';
import 'package:dependencecoping/storage/trigger_log.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum LoadingProgress { notStarted, started, done }

mixin Assets<T extends StatefulWidget> on State<T> {
  LoadingProgress loadingState = LoadingProgress.notStarted;

  User? user;
  ProfileRecord? profile;
  List<CountdownReset>? resets;
  List<Goal>? goals;
  List<Trigger>? triggers;
  List<TriggerLog>? triggersLog;
  StaticRecords statics = StaticRecords(
    goals: [],
    triggers: [],
  );

  @override
  void initState() {
    super.initState();
  }

  Future<String> localText(BuildContext context, String name) async {
    return await DefaultAssetBundle.of(context).loadString(name);
  }

  bool tryLock() {
    log('trying to lock: state $loadingState', name: 'tools.Assets');

    if (loadingState == LoadingProgress.notStarted) {
      setState(() {
        loadingState = LoadingProgress.started;
      });

      return true;
    }

    return false;
  }

  Future<void> reset(BuildContext context) async {
    setState(() {
      loadingState = LoadingProgress.started;
    });

    await load(context);
  }

  Future<void> load(BuildContext context) async {
    final userData = await restoreAuthInfo();
    setState(() {
      user = userData;
    });

    List<Future> waitGroup = [];

    if (user != null) {
      final profileFuture = getProfile(user!);
      profileFuture.then((value) => setState(() => profile = value));
      waitGroup.add(profileFuture);

      final staticGoalsFuture = getStaticGoals(user!);
      staticGoalsFuture.then((value) => setState(() => statics.goals = value));
      waitGroup.add(staticGoalsFuture);

      final staticTriggersFuture = getStaticTriggers(user!);
      staticTriggersFuture.then((value) => setState(() => statics.triggers = value));
      waitGroup.add(staticTriggersFuture);

      final resetsFuture = getCountdownResets(user!, 'smoking');
      resetsFuture.then((value) => setState(() => resets = value));
      waitGroup.add(resetsFuture);

      final goalsFuture = getGoals(user!);
      goalsFuture.then((value) => setState(() => goals = value));
      waitGroup.add(goalsFuture);

      final triggersFuture = getTriggers(user!);
      triggersFuture.then((value) => setState(() => triggers = value));
      waitGroup.add(triggersFuture);

      final triggersLogFuture = getTriggersLog(user!, 'smoking');
      triggersLogFuture.then((value) => setState(() => triggersLog = value));
      waitGroup.add(triggersLogFuture);
    }

    await Future.wait(waitGroup, eagerError: true);

    setState(() {
      loadingState = LoadingProgress.done;
    });
  }
}
