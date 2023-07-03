import 'package:dependencecoping/storage/trigger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Triggers {
  Triggers(this.data);

  List<Trigger> data;

  @override
  bool operator ==(Object other) => false; // ignore: hash_and_equals
}

class TriggersCubit extends Cubit<Triggers?> {
  TriggersCubit() : super(null);

  Future<void> toggle(User user, Trigger trigger) async {
    if (state != null) {
      var d = state!.data;

      if (d.where((element) => trigger.id == element.id).isEmpty) {
        d.add(trigger);
      } else {
        d.removeWhere((element) => trigger.id == element.id);
      }

      emit(Triggers(d));
      syncTriggers(user, [...d]);
    }
  }

  Future<void> set(User user, Triggers triggers) async {
    emit(triggers);
    syncTriggers(user, [...triggers.data]);
  }

  Future<void> overwrite(Triggers triggers) async {
    emit(triggers);
  }
}
