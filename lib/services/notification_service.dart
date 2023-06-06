import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _instance = NotificationService._internal();
  final _notifications = FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> init() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    // var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        //  iOS: initializationSettingsIOS
         );
    await _notifications.initialize(initializationSettings);
  }

  Future<void> showNotification(String id, String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      id,
      'MedTrack',
      channelDescription: 'MedTrack notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        // iOS: iOSPlatformChannelSpecifics
        );
    await _notifications.show(
      int.parse(id),
      title,
      body,
      platformChannelSpecifics,
    );
  }
}
