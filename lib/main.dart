import 'dart:io';
import 'package:crypto_price_tracker/views/crypto_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize(); // ✅ Initialize notifications

  // ✅ Request notification permission for Android 13+ 
  if (Platform.isAndroid) {
    final androidImplementation =
        NotificationService.notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    bool? granted = await androidImplementation?.requestPermission();

    if (granted == true) {
      print("✅ Permission Granted");
      // Send test notification after 3 seconds
      Future.delayed(Duration(seconds: 30), () {
        NotificationService.showNotification(
          "Test Notification 🔔",
          "This is a test notification for debugging.",
        );
      });
    } else {
      print("❌ Permission Denied - Ask user manually");
    }
  }

  runApp(ProviderScope(child: MyApp()));
}

extension on AndroidFlutterLocalNotificationsPlugin? {
  requestPermission() {}
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CryptoView(),
    );
  }
}
