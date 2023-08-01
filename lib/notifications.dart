import 'dart:developer';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin? fnp;

Future<void> notifications() async {
  tz.initializeTimeZones();

  fnp = FlutterLocalNotificationsPlugin();
  await fnp!.initialize(InitializationSettings(
    iOS: DarwinInitializationSettings(
      onDidReceiveLocalNotification: (final id, final title, final body, final _) => log('$id - $title', name: 'silence notificaion'),
    ),
  ));

  await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  await OneSignal.shared.setAppId('334d0f7c-7da2-4734-922c-12e49dccbfd8');
  await OneSignal.shared.promptUserForPushNotificationPermission().then((final accepted) {
    log('Accepted permission: $accepted', name: 'one signal');
  });

  OneSignal.shared.setNotificationWillShowInForegroundHandler((final OSNotificationReceivedEvent event) {
    // Will be called whenever a notification is received in foreground
    // Display Notification, pass null param for not displaying the notification

    // event.complete(event.notification);
  });

  OneSignal.shared.setNotificationOpenedHandler((final OSNotificationOpenedResult result) {
    // Will be called whenever a notification is opened/button pressed.
  });

  OneSignal.shared.setPermissionObserver((final OSPermissionStateChanges changes) {
    // Will be called whenever the permission changes
    // (ie. user taps Allow on the permission prompt in iOS)
  });

  OneSignal.shared.setSubscriptionObserver((final OSSubscriptionStateChanges changes) {
    // Will be called whenever the subscription changes
    // (ie. user gets registered with OneSignal and gets a user ID)
  });
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
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  );
}

Future<void> unscheduleNotification(final int id) async {
  if (fnp == null) {
    return;
  }

  await fnp!.cancel(id);
}
