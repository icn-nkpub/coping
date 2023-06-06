import 'package:cloudcircle/storage/trigger.dart';
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
      if (state!.data.where((element) => trigger.id == element.id).isEmpty) {
        state!.data.add(trigger);
      } else {
        state!.data.removeWhere((element) => trigger.id == element.id);
      }
      emit(state);
      syncTriggers(user, state!.data);
    }
  }

  Future<void> set(User user, Triggers triggers) async {
    emit(triggers);
    syncTriggers(user, triggers.data);
  }

  Future<void> overwrite(Triggers triggers) async {
    emit(triggers);
  }
}
