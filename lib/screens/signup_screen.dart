import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medtrack/screens/dashboard_screen.dart';
import 'package:medtrack/utils/colors.dart';
import 'package:medtrack/widgets/custom_button.dart';
import 'package:medtrack/widgets/custom_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  String _name = '';
  String _email = '';
  String _password = '';
  String _phone = '';
  bool _loading = false;
  String _error = '';

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
        _error = '';
      });
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        await _auth.currentUser!.updateDisplayName(_name);
        // await _auth.currentUser!.updatePhoneNumber(_phone);
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
                label: 'Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
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
              CustomTextField(
                label: 'Phone',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!value.startsWith('+')) {
                    return 'Please enter a valid phone number with country code';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _phone = value;
                  });
                },
              ),
              SizedBox(height: 16.0),
              CustomButton(
                text: 'Sign up',
                color: AppColor.deepgreen,
                onPressed: _signUp,
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
