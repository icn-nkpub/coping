import 'dart:async';
import 'dart:developer';
import 'dart:io';

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

mixin AssetsInitializer<T extends StatefulWidget> on State<T> {
  LoadingProgress loadingState = LoadingProgress.notStarted;
  bool initOK = false;

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

  Future<String> localText(final BuildContext context, final String name) => DefaultAssetBundle.of(context).loadString(name);

  bool tryLock() {
    log('trying to lock: state $loadingState', name: 'tools.Assets');
    sleep(const Duration(seconds: 1));

    if (loadingState == LoadingProgress.notStarted) {
      setState(() {
        loadingState = LoadingProgress.started;
      });

      return true;
    }

    return false;
  }

  Future<void> reset(final BuildContext context) async {
    setState(() {
      loadingState = LoadingProgress.started;
    });

    await _load(context);
  }

  Future<void> init(final BuildContext context) async {
    setState(() {
      initOK = false;
    });

    await _load(context);

    setState(() {
      initOK = true;
    });
  }

  Future<void> _load(final BuildContext context) async {
    final userData = await restoreAuthInfo();
    setState(() {
      user = userData;
    });

    final List<Future> waitGroup = [];

    if (user != null) {
      final profileFuture = getProfile(user!);
      unawaited(profileFuture.then((final value) => setState(() => profile = value)));
      waitGroup.add(profileFuture);

      final staticGoalsFuture = getStaticGoals(user!);
      unawaited(staticGoalsFuture.then((final value) => setState(() => statics.goals = value)));
      waitGroup.add(staticGoalsFuture);

      final staticTriggersFuture = getStaticTriggers(user!);
      unawaited(staticTriggersFuture.then((final value) => setState(() => statics.triggers = value)));
      waitGroup.add(staticTriggersFuture);

      final resetsFuture = getCountdownResets(user!, 'smoking');
      unawaited(resetsFuture.then((final value) => setState(() => resets = value)));
      waitGroup.add(resetsFuture);

      final goalsFuture = getGoals(user!);
      unawaited(goalsFuture.then((final value) => setState(() => goals = value)));
      waitGroup.add(goalsFuture);

      final triggersFuture = getTriggers(user!);
      unawaited(triggersFuture.then((final value) => setState(() => triggers = value)));
      waitGroup.add(triggersFuture);

      final triggersLogFuture = getTriggersLog(user!, 'smoking');
      unawaited(triggersLogFuture.then((final value) => setState(() => triggersLog = value)));
      waitGroup.add(triggersLogFuture);
    }

    await Future.wait(waitGroup, eagerError: true);

    setState(() {
      loadingState = LoadingProgress.done;
    });
  }
}
