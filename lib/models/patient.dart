// Import the cloud_firestore package
import 'package:cloud_firestore/cloud_firestore.dart';


// Create a class called Patient
class PatientRecord {
  // Declare the properties of the class
  final String id; // A unique id for the patient
  final String patientName; // The name of the patient
  final int patientAge; // The age of the patient
  final String patientGender; // The gender of the patient
  final String medicalHistory; // The medical history of the patient
  final String patientDiagnosis;
  final String patientTreatment;

  // Create a constructor for the class that takes named parameters and assigns them to the properties
  PatientRecord({
    required this.id,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    required this.medicalHistory,
    required this.patientDiagnosis,
    required this.patientTreatment,
  });

  // Create a method to convert the class instance into a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': patientName,
      'age': patientAge,
      'gender': patientGender,
      'medicalHistory': medicalHistory,
      'patientDiagnosis': patientDiagnosis,
      'patientTreatment': patientTreatment,

    };
  }

  // Create a method to convert a map into a class instance
  factory PatientRecord.fromMap(Map<String, dynamic> map) {
    return PatientRecord(
      id: map['id'],
      patientName: map['name'],
      patientAge: map['age'],
      patientGender: map['gender'],
      medicalHistory: map['medicalHistory'],
      patientDiagnosis: map['patientDiagnosis'],
      patientTreatment: map['patientTreatment']
    );
  }
}
