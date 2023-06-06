class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;

  NotificationModel(this.id, this.title, this.body, this.timestamp);

  String get getId => id;
  String get getTitle => title;
  String get getBody => body;
  DateTime get getTimestamp => timestamp;
}
