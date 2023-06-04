import 'package:cloudcircle/storage/goal.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaticRecords {
  StaticRecords({
    required this.goals,
  });

  List<Goal> goals;
}

class StaticCubit extends Cubit<StaticRecords?> {
  StaticCubit() : super(null);

  Future<void> overwrite(StaticRecords s) async {
    emit(s);
  }
}
