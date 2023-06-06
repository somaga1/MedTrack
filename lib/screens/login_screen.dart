// // Import the flutter package
// import 'package:flutter/material.dart';
// import 'package:medtrack/utils/colors.dart';

// // Import the custom widgets, constants, services and validators
// import 'package:medtrack/widgets/custom_appbar.dart';
// import 'package:medtrack/widgets/custom_button.dart';
// import 'package:medtrack/widgets/custom_textfield.dart';
// import 'package:medtrack/utils/constants.dart';
// import 'package:medtrack/services/authentication_service.dart';
// import 'package:medtrack/utils/validators.dart';

// // Create a class called LoginScreen that extends the StatefulWidget widget
// class LoginScreen extends StatefulWidget {
//   // Override the createState method to return a custom state object
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// // Create a class called _LoginScreenState that extends the State<LoginScreen> widget
// class _LoginScreenState extends State<LoginScreen> {
//   // Declare a global key for the form state
//   final _formKey = GlobalKey<FormState>();

//   // Declare a text editing controller for the email field
//   final _emailController = TextEditingController();

//   // Declare a text editing controller for the password field
//   final _passwordController = TextEditingController();

//   // Declare a boolean variable for the loading state
//   bool _isLoading = false;

//   // Override the build method to return a custom login screen widget
//   @override
//   Widget build(BuildContext context) {
//     // Return a Scaffold widget with some basic layout and widgets
//     return Scaffold(
//       // Use the CustomAppBar widget to display the app bar
//       appBar: CustomAppBar(
//         title: Text('Log In'),
//       ),
//       // Use a SafeArea widget to avoid any system UI intrusions
//       body: SafeArea(
//         // Use a Container widget with some padding and color
//         child: Container(
//           padding: EdgeInsets.all(kDefaultPadding),
//           color: kBackgroundColor,
//           // Use a Form widget with a global key to validate and save the form fields
//           child: Form(
//             key: _formKey,
//             // Use a Column widget to arrange the form widgets vertically
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Use a CustomTextField widget to display a text field for email address
//                 CustomTextField(
//                   controller: _emailController,
//                   labelText: 'Email',
//                   icon: Icons.email,
//                   validator: validateEmail,
//                 ),
//                 // Use a CustomTextField widget to display a text field for password
//                 CustomTextField(
//                   controller: _passwordController,
//                   labelText: 'Password',
//                   icon: Icons.lock,
//                   validator: validatePassword,
//                   obscureText: true,
//                 ),
//                 // Use a SizedBox widget to add some vertical space
//                 SizedBox(height: kDefaultMargin),
//                 // Use a CustomButton widget to display a button for logging in
//                 CustomButton(
//                   text: 'Login',
//                   color: AppColor.deepgreen,
//                   onPressed: () async {
//                     // Check if the form is valid by using the validate method of the form state
//                     if (_formKey.currentState!.validate()) {
//                       // Set the loading state to true and rebuild the screen
//                       setState(() {
//                         _isLoading = true;
//                       });
//                       try {
//                         // Use the AuthenticationService instance to log in the user with email and password by using the logIn method
//                         await AuthenticationService().logIn(
//                           _emailController.text,
//                           _passwordController.text,
//                         );
//                         // Navigate to the dashboard screen if successful
//                         Navigator.of(context)
//                             .pushReplacementNamed('/dashboard');
//                       } catch (e) {
//                         // Show an error message if failed
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text(e.toString())),
//                         );
//                       } finally {
//                         // Set the loading state to false and rebuild the screen
//                         setState(() {
//                           _isLoading = false;
//                         });
//                       }
//                     }
//                   },
//                   // child:
//                   //     // Use a conditional expression to display either a text or a circular progress indicator depending on the loading state
//                   //     _isLoading ? CircularProgressIndicator() : Text('Log In'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medtrack/screens/dashboard_screen.dart';
import 'package:medtrack/utils/colors.dart';
import 'package:medtrack/widgets/custom_button.dart';
import 'package:medtrack/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  String _email = '';
  String _password = '';
  bool _loading = false;
  String _error = '';

  void _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
        _error = '';
      });
      try {
        await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardScreen(),
          ),
          (route) => false,
        );
      } on FirebaseAuthException catch (e) {
        setState(() {
          _loading = false;
          _error = e.message ?? 'An error occurred';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MedTrack'),
        backgroundColor: Colors.green[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _email = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              CustomTextField(
                label: 'Password',
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Please enter a password with at least 6 characters';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              CustomButton(
                text: 'Sign in',
                color: AppColor.deepgreen,
                onPressed: _signIn,
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
