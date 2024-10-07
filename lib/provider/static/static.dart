import 'package:dependencecoping/storage/trigger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StaticRecords {
  StaticRecords({
    required this.triggers,
  });

  List<Trigger> triggers;
  bool get isEmpty => triggers.isEmpty;

  @override
  bool operator ==(final Object other) => false; // ignore: hash_and_equals
}

class StaticCubit extends Cubit<StaticRecords?> {
  StaticCubit() : super(null);

  void overwrite(final StaticRecords s) {
    emit(s);
  }
}
