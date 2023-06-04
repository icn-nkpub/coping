import 'package:cloudcircle/storage/goal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoalsCubit extends Cubit<List<Goal>?> {
  GoalsCubit() : super(null);

  Future<void> set(User user, List<Goal> goals) async {
    emit(goals);
    syncGoals(user, goals);
  }

  Future<void> overwrite(List<Goal> goals) async {
    emit(goals);
  }
}
