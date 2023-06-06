import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medtrack/models/appointment.dart';
import 'package:medtrack/models/inventory_item.dart';
import 'package:medtrack/models/notification_model.dart';
import 'package:medtrack/models/patient.dart';

class FirestoreService {
  static final _instance = FirestoreService._internal();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal();

  Future<void> addAppointment(Appointment appointment) async {
    final uid = _auth.currentUser!.uid;
    await _firestore.collection('appointments').add({
      'userId': uid,
      'patientName': appointment.patientName,
      'patientPhone': appointment.patientPhone,
      'startTime': Timestamp.fromDate(appointment.startTime),
      'endTime': Timestamp.fromDate(appointment.endTime),
    });
  }

  Future<void> deleteAppointment(String id) async {
    await _firestore.collection('appointments').doc(id).delete();
  }

  Future<List<Appointment>> getAppointments() async {
    final uid = _auth.currentUser!.uid;
    final snapshot = await _firestore
        .collection('appointments')
        .where('userId', isEqualTo: uid)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final id = doc.id;
      final patientName = data['patientName'];
      final patientPhone = data['patientPhone'];
      final startTime = data['startTime'].toDate();
      final endTime = data['endTime'].toDate();
      return Appointment(id, patientName, patientPhone, startTime, endTime);
    }).toList();
  }

  Future<void> addInventoryItem(InventoryItem item) async {
    final uid = _auth.currentUser!.uid;
    await _firestore.collection('inventory').add({
      'userId': uid,
      'itemName': item.itemName,
      'itemQuantity': item.itemQuantity,
      'itemPrice': item.itemPrice,
      'itemExpiryDate': Timestamp.fromDate(item.itemExpiryDate),
    });
  }

  Future<void> deleteInventoryItem(String id) async {
    await _firestore.collection('inventory').doc(id).delete();
  }

  Future<List<InventoryItem>> getInventoryItems() async {
    final uid = _auth.currentUser!.uid;
    final snapshot = await _firestore
        .collection('inventory')
        .where('userId', isEqualTo: uid)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final id = doc.id;
      final itemName = data['itemName'];
      final itemQuantity = data['itemQuantity'];
      final itemPrice = data['itemPrice'];
      final itemExpiryDate = data['itemExpiryDate'].toDate();
      return InventoryItem(
          id, itemName, itemQuantity, itemPrice, itemExpiryDate);
    }).toList();
  }

  Future<void> addPatientRecord(PatientRecord record) async {
    final uid = _auth.currentUser!.uid;
    await _firestore.collection('patients').add({
      'userId': uid,
      'patientName': record.patientName,
      'patientAge': record.patientAge,
      'patientGender': record.patientGender,
      'patientDiagnosis': record.patientDiagnosis,
      'patientTreatment': record.patientTreatment,
    });
  }

  Future<void> deletePatientRecord(String id) async {
    await _firestore.collection('patients').doc(id).delete();
  }

  Future<List<PatientRecord>> getPatientRecords() async {
    final uid = _auth.currentUser!.uid;
    final snapshot = await _firestore
        .collection('patients')
        .where('userId', isEqualTo: uid)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final id = doc.id;
      final patientName = data['patientName'];
      final patientAge = data['patientAge'];
      final patientGender = data['patientGender'];
      final patientDiagnosis = data['patientDiagnosis'];
      final patientTreatment = data['patientTreatment'];
      return PatientRecord(id, patientName, patientAge, patientGender,
          patientDiagnosis, patientTreatment);
    }).toList();
  }

  Future<void> addNotification(NotificationModel notification) async {
    final uid = _auth.currentUser!.uid;
    await _firestore.collection('notifications').add({
      'userId': uid,
      'title': notification.title,
      'body': notification.body,
      'timestamp': Timestamp.fromDate(notification.timestamp),
    });
  }

  Future<void> deleteNotification(String id) async {
    await _firestore.collection('notifications').doc(id).delete();
  }

  Future<List<NotificationModel>> getNotifications() async {
    final uid = _auth.currentUser!.uid;
    final snapshot = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final id = doc.id;
      final title = data['title'];
      final body = data['body'];
      final timestamp = data['timestamp'].toDate();
      return NotificationModel(id, title, body, timestamp);
    }).toList();
  }
}
