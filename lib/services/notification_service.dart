import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await notificationsPlugin.initialize(settings);

    // ✅ Request permission for notifications (Android 13+)
    final androidImplementation =
        notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    bool? granted = await androidImplementation?.requestPermission();

    if (granted == true) {
      print("✅ Notification Permission Granted");
    } else {
      print("❌ Notification Permission Denied");
    }
  }

  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'crypto_alerts', // Unique channel ID
      'Crypto Alerts',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await notificationsPlugin.show(0, title, body, details);
  }
}

extension on AndroidFlutterLocalNotificationsPlugin? {
  requestPermission() {}
}

