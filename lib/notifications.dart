import 'dart:developer';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin? fnp;

Future<void> notifications() async {
  tz.initializeTimeZones();

  fnp = FlutterLocalNotificationsPlugin();

  if (Platform.isAndroid) {
    final notPlugAndroid = FlutterLocalNotificationsPlugin();
    await notPlugAndroid
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  try {
    await fnp!.initialize(InitializationSettings(
      iOS: DarwinInitializationSettings(
        onDidReceiveLocalNotification:
            (final id, final title, final body, final _) =>
                log('$id - $title', name: 'silence notificaion'),
      ),
    ));

    // ignore: avoid_catches_without_on_clauses
  } catch (e) {
    fnp = null;
    log(e.toString());
  }
}

Future<void> scheduleNotification(
  final int id,
  final Duration after,
  final String title,
  final String body,
) async {
  if (fnp == null) {
    return;
  }

  await fnp!.cancel(id);
  await fnp!.zonedSchedule(
    id,
    title,
    body,
    tz.TZDateTime.now(tz.local).add(after),
    const NotificationDetails(),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
  );
}

Future<void> unscheduleNotification(final int id) async {
  if (fnp == null) {
    return;
  }

  await fnp!.cancel(id);
}
