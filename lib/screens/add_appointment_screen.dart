import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medtrack/models/appointment.dart';
import 'package:medtrack/utils/colors.dart';
import 'package:medtrack/widgets/custom_appbar.dart';
import 'package:medtrack/widgets/custom_button.dart';
import 'package:medtrack/widgets/custom_textfield.dart';

class AddAppointmentScreen extends StatefulWidget {
  const AddAppointmentScreen({Key? key}) : super(key: key);

  @override
  _AddAppointmentScreenState createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _notifications = FlutterLocalNotificationsPlugin();

  String _patientName = '';
  String _patientPhone = '';
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(Duration(hours: 1));
  bool _loading = false;
  String _error = '';

  void _addAppointment() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
        _error = '';
      });
      try {
        final uid = _auth.currentUser!.uid;
        final docRef = await _firestore.collection('appointments').add({
          'userId': uid,
          'patientName': _patientName,
          'patientPhone': _patientPhone,
          'startTime': Timestamp.fromDate(_startTime),
          'endTime': Timestamp.fromDate(_endTime),
        });
        await _scheduleNotification(docRef.id);
        Fluttertoast.showToast(msg: 'Appointment added');
        Navigator.pop(context);
      } on FirebaseException catch (e) {
        setState(() {
          _loading = false;
          _error = e.message ?? 'An error occurred';
        });
      }
    }
  }

  void _scheduleNotification(String id) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      id,
      'MedTrack',
      'MedTrack notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        // iOS: iOSPlatformChannelSpecifics
        );
    await _notifications.schedule(
      int.parse(id),
      'MedTrack',
      'You have an appointment with $_patientName at ${DateFormat.jm().format(_startTime)}',
      _startTime.subtract(Duration(minutes: 15)),
      platformChannelSpecifics,
    );
  }

  void _showStartTimePicker() {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(Duration(days: 365)),
      onConfirm: (date) {
        setState(() {
          if (date.isAfter(_endTime)) {
            Fluttertoast.showToast(msg: 'Start time cannot be after end time');
          } else {
            _startTime = date;
          }
        });
      },
      currentTime: _startTime,
    );
  }

  void _showEndTimePicker() {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      maxTime: DateTime.now().add(Duration(days: 365)),
      onConfirm: (date) {
        setState(() {
          if (date.isBefore(_startTime)) {
            Fluttertoast.showToast(msg: 'End time cannot be before start time');
          } else {
            _endTime = date;
          }
        });
      },
      currentTime: _endTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add Appointment',
        logo: 'assets/images/logo.png',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                label: 'Patient Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the patient name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _patientName = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              CustomTextField(
                label: 'Patient Phone',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the patient phone number';
                  }
                  if (!value.startsWith('+')) {
                    return 'Please enter a valid phone number with country code';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _patientPhone = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Start Time',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                  Text(
                    DateFormat.yMd().add_jm().format(_startTime),
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[800],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.access_time),
                    color: Colors.green[900],
                    onPressed: _showStartTimePicker,
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'End Time',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                  Text(
                    DateFormat.yMd().add_jm().format(_endTime),
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[800],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.access_time),
                    color: Colors.green[900],
                    onPressed: _showEndTimePicker,
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              CustomButton(
                text: 'Add Appointment',
                color: AppColor.deepgreen,
                onPressed: _addAppointment,
              ),
              SizedBox(height: 16.0),
              if (_loading)
                Center(
                  child: CircularProgressIndicator(),
                ),
              if (_error.isNotEmpty)
                Center(
                  child: Text(
                    _error,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16.0,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
