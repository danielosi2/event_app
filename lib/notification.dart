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

  // Ensure the init function is called on app startup
  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: true, // Request sound permission on iOS
      requestBadgePermission: true,
      requestAlertPermission: true, // Ensure this is set to true for notifications
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
          print('Notification payload: $payload');
        }
      },
    );

    tz.initializeTimeZones(); // Ensure timezones are initialized
  }

  // Modified this function to show "Reminder" notification immediately after event creation
  Future<void> showNewEventNotificationAsReminder(Event event, BuildContext context) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'new_event_channel',
      'Event Reminder Notifications',
      channelDescription: 'Notifications for events happening soon',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    // Simulate reminder notification with "event happening in 1 hour"
    await flutterLocalNotificationsPlugin.show(
      0,
      'Reminder: ${event.title}',
      'Your event is happening in 1 hour at ${event.time.format(context)}',
      platformChannelSpecifics,
      payload: event.id,
    );
  }

  Future<void> scheduleEventReminder(Event event, BuildContext context) async {
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'event_reminder_channel',
      'Event Reminder Notifications',
      channelDescription: 'Reminders for events you are attending',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    // Ensure event time is properly calculated
    final tz.TZDateTime eventTime = tz.TZDateTime.from(
      event.date.add(Duration(hours: event.time.hour, minutes: event.time.minute)).subtract(Duration(hours: 1)), // Reminder 1 hour before
      tz.local,
    );

    print('Scheduling reminder for ${event.title} at $eventTime');

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      event.id.hashCode, // Use event ID hash for unique notification ID
      'Event Reminder: ${event.title}',
      'Your event is about to start at ${event.time.format(context)}', // Format time based on context
      eventTime,
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
