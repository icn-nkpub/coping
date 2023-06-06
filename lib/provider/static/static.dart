import 'package:cloudcircle/storage/goal.dart';
import 'package:cloudcircle/storage/trigger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaticRecords {
  StaticRecords({
    required this.goals,
    required this.triggers,
  });

  List<Goal> goals;
  List<Trigger> triggers;

  @override
  bool operator ==(Object other) => false; // ignore: hash_and_equals
}

class StaticCubit extends Cubit<StaticRecords?> {
  StaticCubit() : super(null);

  Future<void> overwrite(StaticRecords s) async {
    emit(s);
  }
}
