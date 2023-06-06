// Import the firebase_auth package
import 'package:firebase_auth/firebase_auth.dart';

// Create a class called AuthenticationService
class AuthenticationService {
  // Create a private instance of FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a method to sign up a user with email and password
  Future<void> signUp(String email, String password) async {
    try {
      // Use the createUserWithEmailAndPassword method of FirebaseAuth
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // Handle any errors
      print(e);
    }
  }

  // Create a method to log in a user with email and password
  Future<void> logIn(String email, String password) async {
    try {
      // Use the signInWithEmailAndPassword method of FirebaseAuth
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      // Handle any errors
      print(e);
    }
  }

  // Create a method to log out a user
  Future<void> logOut() async {
    try {
      // Use the signOut method of FirebaseAuth
      await _auth.signOut();
    } catch (e) {
      // Handle any errors
      print(e);
    }
  }

  // Create a method to get the current user
  User? getCurrentUser() {
    // Use the currentUser property of FirebaseAuth
    return _auth.currentUser;
  }
}

