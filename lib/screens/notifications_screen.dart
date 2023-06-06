import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medtrack/services/notification_service.dart';
import 'package:medtrack/services/firestore_service.dart';
import 'package:medtrack/widgets/custom_appbar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _firestoreService = FirestoreService();

  List<Notification> _notifications = [];

  void _fetchNotifications() async {
    setState(() {
      _notifications = [];
    });
    final notifications = await _firestoreService.getNotifications();
    setState(() {
      _notifications = notifications;
    });
  }

  void _deleteNotification(String id) async {
    await _firestoreService.deleteNotification(id);
    Fluttertoast.showToast(msg: 'Notification deleted');
    _fetchNotifications();
  }

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notifications',
        logo: 'assets/images/logo.png',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            final notification = _notifications[index];
            return Slidable(
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  title: Text(notification.title),
                  subtitle: Text(
                      DateFormat.yMd().add_jm().format(notification.timestamp)),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
              secondaryActions: [
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    _deleteNotification(notification.id);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
