import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medtrack/screens/login_screen.dart';
import 'package:medtrack/screens/signup_screen.dart';
import 'package:medtrack/utils/colors.dart';
import 'package:medtrack/widgets/custom_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error initializing Firebase'),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo.jpg'),
                  SizedBox(height: 16.0),
                  Text(
                    'Welcome to MedTrack',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[900],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text('The best app for managing your medical practice',
                      style: TextStyle(
                          color: AppColor.gray,
                          fontSize: 17.0,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 32.0),
                  CustomButton(
                    text: 'Sign in',
                    color: AppColor.deepgreen,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16.0),
                  CustomButton(
                    text: 'Sign up',
                    color: Colors.white,
                    textColor: Colors.green[900],
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
