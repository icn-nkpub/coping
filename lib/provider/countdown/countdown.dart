import 'package:dependencecoping/storage/reset_log.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CountdownTimer {
  CountdownTimer({
    required this.resets,
    required this.resumed,
    required this.paused,
  });

  List<CountdownReset> resets;
  DateTime? resumed;
  DateTime? paused;

  @override
  bool operator ==(Object other) => false; // ignore: hash_and_equals

  List<CountdownReset> sortedCopy() {
    var r = [...resets];

    r.sort((a, b) => a.compareTo(b));

    return r;
  }

  Splits splits() {
    final resets = sortedCopy();

    var total = DateTime.now();

    for (var r in resets.reversed) {
      var d = (r.resumeTime ?? DateTime.now()).difference(r.resetTime);
      total = total.subtract(d);
    }

    final DateTime last;
    if (resets.lastOrNull?.resumeTime == null) {
      last = DateTime.now();
    } else {
      last = resets.last.resumeTime!;
    }

    return Splits(
      DateTime(last.year, last.month, last.day, last.hour, last.minute, last.second),
      resets.isEmpty ? null : DateTime(total.year, total.month, total.day, total.hour, total.minute, total.second),
    );
  }
}

class Splits {
  const Splits(this.last, this.total);

  final DateTime? last;
  final DateTime? total;
}

class CountdownTimerCubit extends Cubit<CountdownTimer?> {
  CountdownTimerCubit() : super(null);

  Future<void> resume(User auth, DateTime dt) async {
    if (state == null) return;

    var resets = state!.sortedCopy();
    if (resets.isEmpty) {
      resets.add(CountdownReset(resetTime: state?.paused ?? DateTime.now(), resumeTime: dt));
    } else {
      resets.last = CountdownReset(
        resetTime: resets.last.resetTime,
        resumeTime: dt,
      );
    }

    await logCountdownResume(auth, 'smoking', dt);

    emit(CountdownTimer(resumed: dt, paused: null, resets: resets));
  }

  Future<void> pause(User auth) async {
    if (state == null) return;

    var resets = state!.sortedCopy();
    final resetTime = state?.resumed ?? DateTime.now();

    resets.add(CountdownReset(
      resetTime: resetTime,
      resumeTime: null,
    ));

    await logCountdownReset(auth, 'smoking', resetTime);

    emit(CountdownTimer(
      resumed: null,
      paused: DateTime.now(),
      resets: [...resets],
    ));
  }

  Future<void> overwrite(
    List<CountdownReset> input,
  ) async {
    var resets = [...input];
    resets.sort((a, b) => a.compareTo(b));

    emit(CountdownTimer(
      paused: resets.lastOrNull?.resetTime ?? DateTime.now(),
      resumed: resets.lastOrNull?.resumeTime,
      resets: [...resets],
    ));
  }
}
