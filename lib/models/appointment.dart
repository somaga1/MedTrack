// Import the cloud_firestore package
import 'package:cloud_firestore/cloud_firestore.dart';

// Create a class called Appointment
class Appointment {
  // Declare the properties of the class
  final String id; // A unique id for the appointment
  // final String doctor; // The name of the doctor
  final String patientName; // The name of the patient
  final DateTime endTime; // The date of the appointment
  final DateTime startTime; // The time of the appointment
  final String
      patientPhone; // The status of the appointment (pending, confirmed, cancelled, etc.)

  // Create a constructor for the class that takes named parameters and assigns them to the properties
  Appointment({
    required this.id,
    // required this.doctor,
    required this.patientName,
    required this.endTime,
    required this.startTime,
    required this.patientPhone,
  });

  // Create a method to convert the class instance into a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // 'doctor': doctor,
      'patient': patientName,
      'date': endTime,
      'time': startTime,
      'status': patientPhone,
    };
  }

  // Create a method to convert a map into a class instance
  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      // doctor: map['doctor'],
      patientName: map['patient'],
      endTime: map['date']
          .toDate(), // Use the toDate method to convert the Timestamp object into a DateTime object
      startTime: map['time'],
      patientPhone: map['status'],
    );
  }
}
