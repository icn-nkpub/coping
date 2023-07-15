import 'package:dependencecoping/storage/trigger.dart';
import 'package:dependencecoping/storage/trigger_log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Triggers {
  Triggers(this.templates, this.triggerLog);

  List<Trigger> templates;
  List<TriggerLog> triggerLog;

  List<TriggerLog> get log => triggerLog.toList()
    ..sort((a, b) {
      return b.time.compareTo(a.time);
    });

  @override
  bool operator ==(Object other) => false; // ignore: hash_and_equals
}

class TriggersCubit extends Cubit<Triggers?> {
  TriggersCubit() : super(null);

  Future<void> toggle(User user, Trigger trigger) async {
    if (state != null) {
      List<Trigger> d = [];
      Set<String> seen = {};

      for (var t in state!.templates) {
        if (seen.contains(t.id)) continue;
        seen.add(t.id);

        d.add(t);
      }

      if (d.where((element) => trigger.id == element.id).isEmpty) {
        d.add(trigger);
      } else {
        d.removeWhere((element) => trigger.id == element.id);
      }

      var log = state!.triggerLog;

      emit(Triggers(d, log));
      syncTriggers(user, [...d]);
    }
  }

  Future<void> addPersonal(User user, String label) async {
    if (state != null) {
      List<Trigger> d = [];
      Set<String> seen = {};

      for (var t in state!.templates) {
        if (seen.contains(t.id)) continue;
        seen.add(t.id);

        d.add(t);
      }

      d.add(Trigger(id: 'personal/$label', label: label, relatedAddiction: 'smoking'));

      var log = state!.triggerLog;

      emit(Triggers(d, log));
      syncTriggers(user, [...d]);
    }
  }

  Future<void> removePersonal(User user, String id) async {
    if (state != null) {
      List<Trigger> d = [];
      Set<String> seen = {};

      for (var t in state!.templates) {
        if (seen.contains(t.id)) continue;
        seen.add(t.id);

        d.add(t);
      }

      d.removeWhere((element) => id == element.id);

      var log = state!.triggerLog;

      emit(Triggers(d, log));
      syncTriggers(user, [...d]);
    }
  }

  Future<void> send(User user, Trigger trigger, String situation, String thought, int impulse) async {
    if (state != null) {
      List<Trigger> d = [];
      Set<String> seen = {};

      for (var t in state!.templates) {
        if (seen.contains(t.id)) continue;
        seen.add(t.id);

        d.add(t);
      }

      await logTrigger(user, trigger, situation, thought, impulse);

      var log = state!.triggerLog;
      log.add(TriggerLog(
        label: trigger.label,
        situation: situation,
        thought: thought,
        impulse: impulse,
        time: DateTime.now(),
      ));

      emit(Triggers(d, log));
      syncTriggers(user, [...d]);
    }
  }

  // log.add(TriggerRecord(situation: situation, thought: thought, impulse: impulse, time: time))

  Future<void> overwrite(Triggers triggers) async {
    List<Trigger> d = [];
    Set<String> seen = {};

    for (var t in triggers.templates) {
      if (seen.contains(t.id)) continue;
      seen.add(t.id);

      d.add(t);
    }

    emit(Triggers(d, triggers.triggerLog));
  }
}
