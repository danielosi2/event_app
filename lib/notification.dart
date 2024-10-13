import 'package:event_app/models_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        final String? payload = notificationResponse.payload;
        if (payload != null) {
          print('notification payload: $payload');
        }
      },
    );

    tz.initializeTimeZones();
  }

  Future<void> showNewEventNotification(Event event) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'new_event_channel',
      'New Event Notifications',
      channelDescription: 'Notifications for new events',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'New Event: ${event.title}',
      'Date: ${event.date.toString().split(' ')[0]}',
      platformChannelSpecifics,
      payload: event.id,
    );
  }

  Future<void> scheduleEventReminder(Event event) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'event_reminder_channel',
      'Event Reminder Notifications',
      channelDescription: 'Reminders for events you are attending',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      event.id.hashCode,
      'Event Reminder: ${event.title}',
      'Your event is about to start at ${event.time.format(MaterialLocalizations.of(tz.local as BuildContext) as BuildContext)}',
      tz.TZDateTime.from(
        event.date.add(Duration(hours: event.time.hour, minutes: event.time.minute)).subtract(Duration(hours: 1)),
        tz.local,
      ),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      payload: event.id,
    );
  }

  Future<void> cancelEventReminder(Event event) async {
    await flutterLocalNotificationsPlugin.cancel(event.id.hashCode);
  }
}
