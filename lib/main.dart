// // import 'dart:io';
// // import 'package:crypto_price_tracker/views/crypto_view.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'services/notification_service.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await NotificationService.initialize(); // ✅ Initialize notifications

// //   // ✅ Request notification permission for Android 13+ 
// //   if (Platform.isAndroid) {
// //     final androidImplementation =
// //         NotificationService.notificationsPlugin.resolvePlatformSpecificImplementation<
// //             AndroidFlutterLocalNotificationsPlugin>();

// //     bool? granted = await androidImplementation?.requestPermission();

// //     if (granted == true) {
// //       print("✅ Permission Granted");
// //       // Send test notification after 3 seconds
// //       Future.delayed(Duration(seconds: 30), () {
// //         NotificationService.showNotification(
// //           "Test Notification 🔔",
// //           "This is a test notification for debugging.",
// //         );
// //       });
// //     } else {
// //       print("❌ Permission Denied - Ask user manually");
// //     }
// //   }

// //   runApp(ProviderScope(child: MyApp()));
// // }

// // extension on AndroidFlutterLocalNotificationsPlugin? {
// //   requestPermission() {}
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: CryptoView(),
// //     );
// //   }
// // }
// import 'dart:io' if (dart.library.html) 'dart:html'; // Web compatibility
// import 'package:crypto_price_tracker/theme_provider.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'services/notification_service.dart';
// import 'views/crypto_view.dart';
// import 'providers/theme_provider.dart';  // We'll create this provider later

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await NotificationService.initialize(); // ✅ Initialize notifications

//   if (!kIsWeb) { // ✅ Skip notifications on Web
//     await NotificationService.initialize();

//   // Request notification permission for Android 13+
//   if (Platform.isAndroid) {
//     final androidImplementation =
//         NotificationService.notificationsPlugin.resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>();

//     bool? granted = await androidImplementation?.requestPermission();

//     if (granted == true) {
//       print("✅ Permission Granted");
//     } else {
//       print("❌ Permission Denied");
//     }
//   }
//   }

//   runApp(ProviderScope(child: MyApp()));
// }

// extension on AndroidFlutterLocalNotificationsPlugin? {
//   requestPermission() {}
// }

// class MyApp extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Listen to the themeProvider to get the current theme mode
//     final isDarkMode = ref.watch(themeProvider);
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Crypto Price Tracker',
//       themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,  // Set theme mode based on user preference
//       theme: _lightTheme,  // Light theme
//       darkTheme: _darkTheme,  // Dark theme
//       home: CryptoView(),
//     );
//   }
// }

// // Light theme
// final ThemeData _lightTheme = ThemeData(
//   brightness: Brightness.light,
//   primaryColor: Colors.blue,
//   hintColor: Colors.green,
//   scaffoldBackgroundColor: Colors.white,
//   appBarTheme: AppBarTheme(
//     backgroundColor: Colors.blue,
//     foregroundColor: Colors.white,
//   ),
// );

// // Dark theme
// final ThemeData _darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   primaryColor: Colors.black,
//   hintColor: Colors.amber,
//   scaffoldBackgroundColor: Colors.black,
//   appBarTheme: AppBarTheme(
//     backgroundColor: Colors.black,
//     foregroundColor: Colors.white,
//   ),
// );
import 'dart:io' if (dart.library.html) 'dart:html'; // Conditional import
import 'package:crypto_price_tracker/theme_provider.dart';
import 'package:flutter/foundation.dart'; // Required for kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'services/notification_service.dart';
import 'views/crypto_view.dart';
import 'providers/theme_provider.dart';  

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) { // ✅ Skip notifications on Web
    await NotificationService.initialize();

    if (!kIsWeb && Platform.isAndroid) { // ✅ Ensure Platform is used only on Android
      final androidImplementation =
          NotificationService.notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      bool? granted = await androidImplementation?.requestPermission();

      if (granted == true) {
        print("✅ Permission Granted");
      } else {
        print("❌ Permission Denied");
      }
    }
  }

  runApp(ProviderScope(child: MyApp()));
}

extension on AndroidFlutterLocalNotificationsPlugin? {
  requestPermission() {}
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crypto Price Tracker',
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: _lightTheme,
      darkTheme: _darkTheme,
      home: CryptoView(),
    );
  }
}

// Light theme
final ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  hintColor: Colors.green,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
);

// Dark theme
final ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  hintColor: Colors.amber,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
);
