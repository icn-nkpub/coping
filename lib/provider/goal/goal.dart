import 'package:cloudcircle/storage/goal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Goals {
  Goals(this.data);

  List<Goal> data;

  @override
  bool operator ==(Object other) => false; // ignore: hash_and_equals
}

class GoalsCubit extends Cubit<Goals?> {
  GoalsCubit() : super(null);

  Future<void> set(User user, Goals goals) async {
    emit(goals);
    syncGoals(user, [...goals.data]);
  }

  Future<void> overwrite(Goals goals) async {
    emit(goals);
  }
}
