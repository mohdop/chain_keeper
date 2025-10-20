// lib/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/habit.dart';

class NotificationService {
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    // Initialize timezone database and set local zone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Europe/Paris'));

    // Android-only initialization
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    final initSettings = InitializationSettings(
      android: androidInit,
    );

    // Register callback for when the user taps a notification
    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    _initialized = true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap (payload available)
    // Example: navigate or print payload
    print('Notification tapped. Payload: ${response.payload}');
  }

  /// Request runtime permissions on Android:
  /// - Notifications permission (Android 13+)
  /// - Exact alarms permission (if you want to schedule exact alarms)
  Future<void> requestPermissions() async {
    final androidImpl = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImpl != null) {
      try {
        final notificationsGranted =
            await androidImpl.requestNotificationsPermission();
        print('Notifications permission granted: $notificationsGranted');
      } catch (e) {
        print('Error requesting notifications permission: $e');
      }

      try {
        final exactAlarmsGranted =
            await androidImpl.requestExactAlarmsPermission();
        print('Exact alarms permission granted: $exactAlarmsGranted');
      } catch (e) {
        print('Error requesting exact alarms permission: $e');
      }
    } else {
      print('Android implementation not available for permissions request.');
    }
  }

  /// Schedule a daily reminder for the given habit at its reminderHour/reminderMinute.
  /// This uses zonedSchedule with DateTimeComponents.time so it repeats every day.
  Future<void> scheduleHabitReminder(Habit habit) async {
    await initialize();
    // Ask for permissions before scheduling (harmless if already granted)
    await requestPermissions();

    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      habit.reminderHour,
      habit.reminderMinute,
    );

    // If the time already passed today, schedule for tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    final tzScheduledDate = tz.TZDateTime.from(scheduledDate, tz.local);

    const androidDetails = AndroidNotificationDetails(
      'habit_reminders', // channel id
      'Rappels d\'habitudes', // channel name
      channelDescription:
          'Notifications pour vous rappeler vos habitudes quotidiennes',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    try {
      await _notifications.zonedSchedule(
        habit.id.hashCode,
        'Chain Keeper 🔥',
        'N\'oublie pas de compléter "${habit.name}" aujourd\'hui !',
        tzScheduledDate,
        notificationDetails,
        // Use exactAllowWhileIdle to try to deliver exactly even in Doze (Android)
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: habit.id,
        // Repeat daily at the same time
        matchDateTimeComponents: DateTimeComponents.time,
      );

      print(
          'Notification programmée (quotidienne) pour ${habit.name} à ${habit.reminderHour}:${habit.reminderMinute}');
    } catch (e) {
      // Fallback: try inexact mode if exact scheduling fails
      print('Erreur en planifiant exactAllowWhileIdle: $e — tentative inexacte...');
      try {
        await _notifications.zonedSchedule(
          habit.id.hashCode,
          'Chain Keeper 🔥',
          'N\'oublie pas de compléter "${habit.name}" aujourd\'hui !',
          tzScheduledDate,
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexact,
          payload: habit.id,
          matchDateTimeComponents: DateTimeComponents.time,
        );
        print(
            'Notification programmée (quotidienne, inexact) pour ${habit.name}');
      } catch (e2) {
        print('Impossible de programmer la notification (inexact non plus): $e2');
      }
    }
  }

  Future<void> cancelHabitReminder(String habitId) async {
    await _notifications.cancel(habitId.hashCode);
  }

  Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
  }

  Future<void> showTestNotification() async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test',
      channelDescription: 'Test notification',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      'Chain Keeper 🔥',
      'Les notifications fonctionnent !',
      notificationDetails,
    );
  }
}
