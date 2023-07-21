import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:date_utils/date_utils.dart' as dateUtils;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medtrack/models/appointment.dart';
import 'package:medtrack/screens/add_appointment_screen.dart';
import 'package:medtrack/utils/colors.dart';
import 'package:medtrack/widgets/custom_appbar.dart';

class AppointmentSchedulingScreen extends StatefulWidget {
  const AppointmentSchedulingScreen({Key? key}) : super(key: key);

  @override
  _AppointmentSchedulingScreenState createState() =>
      _AppointmentSchedulingScreenState();
}

class _AppointmentSchedulingScreenState
    extends State<AppointmentSchedulingScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _notifications = FlutterLocalNotificationsPlugin();

  DateTime _selectedDate = DateTime.now();
  EventList<Event> _markedDates = EventList<Event>();
  List<Appointment> _appointments = [];

  void _fetchAppointments() async {
    setState(() {
      _appointments = [];
      _markedDates = EventList<Event>();
    });
    final uid = _auth.currentUser!.uid;
    final snapshot = await _firestore
        .collection('appointments')
        .where('userId', isEqualTo: uid)
        .get();
    snapshot.docs.forEach((doc) {
      final data = doc.data();
      final id = doc.id;
      final patientName = data['patientName'];
      final patientPhone = data['patientPhone'];
      final startTime = data['startTime'].toDate();
      final endTime = data['endTime'].toDate();
      final appointment = Appointment(
          id: '1',
          patientName: 'Barbara',
          patientPhone: '09028021766',
          startTime: DateTime.parse('2023-07-20 20:18:04Z'),
          endTime: DateTime.parse('2023-07-20 22:18:04Z'));
      setState(() {
        _appointments.add(appointment);
        _markedDates.add(
          startTime,
          Event(
            date: startTime,
            title: 'Appointment',
            icon: Container(
              decoration: BoxDecoration(
                color: Colors.green[900],
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      });
    });
  }

  void _deleteAppointment(String id) async {
    await _firestore.collection('appointments').doc(id).delete();
    await _notifications.cancel(int.parse(id));
    Fluttertoast.showToast(msg: 'Appointment deleted');
    _fetchAppointments();
  }

  void _showDatePicker() {
    DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(Duration(days: 365)),
      onConfirm: (date) {
        setState(() {
          _selectedDate = date;
        });
      },
      currentTime: _selectedDate,
    );
  }

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    // var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    _notifications.initialize(initializationSettings);
    _fetchAppointments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Appointment Scheduling',
        logo: 'assets/images/logo.png',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CalendarCarousel<Event>(
              onDayPressed: (date, events) {
                setState(() {
                  _selectedDate = date;
                });
              },
              weekendTextStyle: TextStyle(
                color: Colors.red,
              ),
              thisMonthDayBorderColor: Colors.grey,
              weekFormat: false,
              markedDatesMap: _markedDates,
              height: 420.0,
              selectedDateTime: _selectedDate,
              customGridViewPhysics: NeverScrollableScrollPhysics(),
              markedDateShowIcon: true,
              markedDateIconMaxShown: 1,
              markedDateMoreShowTotal:
                  false, // null for not showing hidden events indicator
              showHeaderButton: false,
              todayTextStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              todayButtonColor: AppColor.deepgreen,
              selectedDayTextStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              selectedDayButtonColor:
                  AppColor.deepgreen, //Theme.of(context).primaryColor,
              minSelectedDate:
                  dateUtils.DateUtils.firstDayOfMonth(DateTime.now()),
              maxSelectedDate:
                  dateUtils.DateUtils.lastDayOfMonth(DateTime.now()),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMMMMd().format(_selectedDate),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.date_range),
                  color: Colors.green[900],
                  onPressed: _showDatePicker,
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _appointments.length,
                itemBuilder: (context, index) {
                  final appointment = _appointments[index];
                  if (dateUtils.DateUtils.isSameDay(
                      appointment.startTime, _selectedDate)) {
                    return AppointmentCard(
                      id: appointment.id,
                      patientName: appointment.patientName,
                      patientPhone: appointment.patientPhone,
                      startTime: appointment.startTime,
                      endTime: appointment.endTime,
                    );
                  } else {
                    return
                    SizedBox.shrink();
      //                   //   return Slidable(
      //                   //     actionPane: SlidableDrawerActionPane(),
      //                   //     actionExtentRatio: 0.25,
      //                   //     child: Card(
      //                   //       elevation: 4.0,
      //                   //       shape: RoundedRectangleBorder(
      //                   //         borderRadius: BorderRadius.circular(8.0),
      //                   //       ),
      //                   //       child: ListTile(
      //                   //         leading: CircleAvatar(
      //                   //           backgroundColor: Colors.green[100],
      //                   //           child: Icon(
      //                   //             Icons.person,
      //                   //             color: Colors.green[900],
      //                   //           ),
      //                   //         ),
      //                   //         title: Text(appointment.patientName),
      //                   //         subtitle: Text(
      //                   //             DateFormat.jm().format(appointment.startTime)),
      //                   //         trailing:
      //                   //             Text(DateFormat.jm().format(appointment.endTime)),
      //                   //       ),
      //                   //     ),
      //                   //     secondaryActions: [
      //                   //       IconSlideAction(
      //                   //         caption: 'Delete',
      //                   //         color: Colors.red,
      //                   //         icon: Icons.delete,
      //                   //         onTap: () {
      //                   //           _deleteAppointment(appointment.id);
      //                   //         },
      //                   //       ),
      //                   //     ],
      //                   //   );
      //                   // } else {
      //                   //   return
      //                   SizedBox.shrink();
      //             }
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.green[900],
      //   onPressed: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => AddAppointmentScreen(),
      //     ),
      //   ).then((value) => _fetchAppointments()),
      //   child: Icon(Icons.add),
      // ),
      
    // );
    //   floatingActionButton: FloatingActionButton(
    //     backgroundColor: Colors.green[900],
    //     child: Icon(Icons.add),
    //     onPressed: () {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => AddAppointmentScreen(),
    //         ),
    //       );
    //     },
    //   ),
    // );
  }
}
              ),),],),),
              floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddAppointmentScreen(),
          ),
        ).then((value) => _fetchAppointments()),
        child: Icon(Icons.add),
      ),
    );
  }
}



class AppointmentCard extends StatelessWidget {
  final String id;
  final String patientName;
  final String patientPhone;
  final DateTime startTime;
  final DateTime endTime;

  const AppointmentCard({
    Key? key,
    required this.id,
    required this.patientName,
    required this.patientPhone,
    required this.startTime,
    required this.endTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: ListTile(
        leading: Icon(Icons.person),
        title: Text(patientName),
        subtitle: Text(patientPhone),
        trailing: Text(DateFormat.jm().format(startTime)),
      ),
      secondaryActions: [
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteAppointment(id),
        ),
      ],
    );
  }
}

