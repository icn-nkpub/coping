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

    int score = 0;

    if (resets.isNotEmpty) {
      var total = const Duration();

      for (var r in resets.reversed) {
        var d = (r.resumeTime ?? DateTime.now()).difference(r.resetTime);
        total += d;
      }

      score = (total.inSeconds / 60).round();
    }

    final DateTime last;
    if (resets.lastOrNull?.resumeTime == null) {
      last = DateTime.now();
    } else {
      last = resets.last.resumeTime!;
    }

    return Splits(
      DateTime(last.year, last.month, last.day, last.hour, last.minute, last.second),
      score,
    );
  }
}

class Splits {
  const Splits(this.last, this.score);

  final DateTime? last;
  final int score;
}

class CountdownTimerCubit extends Cubit<CountdownTimer?> {
  CountdownTimerCubit() : super(null);

  Future<void> resume(User auth, DateTime dt) async {
    if (state == null) return;

    final id = await logCountdownResume(auth, 'smoking', dt);

    var resets = state!.sortedCopy();
    if (resets.isEmpty) {
      resets.add(CountdownReset(
        id: id,
        resetTime: state?.paused ?? DateTime.now(),
        resumeTime: dt,
      ));
    } else {
      resets.last = CountdownReset(
        id: id,
        resetTime: resets.last.resetTime,
        resumeTime: dt,
      );
    }

    emit(CountdownTimer(resumed: dt, paused: null, resets: resets));
  }

  Future<void> pause(User auth) async {
    if (state == null) return;

    var resets = state!.sortedCopy();
    final resetTime = state?.resumed ?? DateTime.now();

    final id = await logCountdownReset(auth, 'smoking', resetTime);
    resets.add(CountdownReset(
      id: id,
      resetTime: resetTime,
      resumeTime: null,
    ));

    emit(CountdownTimer(
      resumed: null,
      paused: DateTime.now(),
      resets: [...resets],
    ));
  }

  Future<void> editReset(User user, int id, DateTime time) async {
    await editCountdownReset(user, id, time);

    var resets = state!.sortedCopy();
    for (var i = 0; i < resets.length; i++) {
      var r = resets[i];
      if (r.id == id) resets[i] = CountdownReset(id: r.id, resetTime: time, resumeTime: r.resumeTime);
    }

    emit(CountdownTimer(
      resumed: state?.resumed,
      paused: state?.paused,
      resets: [...resets],
    ));
  }

  Future<void> editResume(User user, int id, DateTime time) async {
    await editCountdownResume(user, id, time);

    var resets = state!.sortedCopy();
    for (var i = 0; i < resets.length; i++) {
      var r = resets[i];
      if (r.id == id) resets[i] = CountdownReset(id: r.id, resetTime: r.resetTime, resumeTime: time);
    }

    emit(CountdownTimer(
      resumed: state?.resumed,
      paused: state?.paused,
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
