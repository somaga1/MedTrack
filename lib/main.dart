// Import the flutter package
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:medtrack/screens/inventory_management_screen.dart';
// Import the screens that you have created
import 'package:medtrack/screens/landing_screen.dart';
import 'package:medtrack/screens/login_screen.dart';
import 'package:medtrack/screens/signup_screen.dart';
import 'package:medtrack/screens/dashboard_screen.dart';
import 'package:medtrack/screens/appointment_scheduling_screen.dart';
import 'package:medtrack/screens/add_appointment_screen.dart';
import 'package:medtrack/screens/add_inventory_item_screen.dart';
import 'package:medtrack/screens/patient_records_screen.dart';
import 'package:medtrack/screens/add_patient_record_screen.dart';
// import 'package:medtrack/screens/edit_patient_record_screen.dart';
import 'package:medtrack/screens/notifications_screen.dart';
import 'package:medtrack/utils/colors.dart';

// Create a class called MyApp that extends the StatelessWidget widget
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? _user = FirebaseAuth.instance.currentUser;
  // Override the build method to return a custom app widget
  @override
  Widget build(BuildContext context) {
    // Return a MaterialApp widget with some basic properties and widgets
    return MaterialApp(
      // Set the title property to the name of your app
      title: 'MedTrack',
      debugShowCheckedModeBanner: false,
      // Set the theme property to a ThemeData object that defines the appearance of your app
      theme: ThemeData(
          primaryColor: AppColor.deepgreen,
          // textTheme: GoogleFonts.poppinsTextTheme(),
          backgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
              backgroundColor: AppColor.deepgreen,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500)),
          iconTheme: IconThemeData(color: Colors.white),
          scaffoldBackgroundColor: Colors.white
          // platform: TargetPlatform.iOS,
          ),
      // Set the initialRoute property to the name of the screen that you want to show first when your app launches
      initialRoute: '/landing_screen',
      // Set the routes property to a map of screen names and screen widgets that defines the navigation of your app
      routes: {
        '/landing_screen': (context) => LandingScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/appointment_scheduling': (context) => AppointmentSchedulingScreen(),
        // '/add_appointment': (context) => AddAppointmentScreen(),
        '/inventory_management': (context) => InventoryManagementScreen(),
        // '/add_inventory_item': (context) => AddInventoryItemScreen(),
        '/patient_records': (context) => PatientRecordsScreen(),
        // '/add_patient_record': (context) => AddPatientRecordScreen(),
        // '/edit_patient_record': (context) => EditPatientRecordScreen(),
        '/notifications': (context) => NotificationsScreen(),
      },
    );
  }
}

// Call the runApp function with an instance of MyApp as an argument
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase app
  await Firebase.initializeApp();
  runApp(const MyApp());
}
