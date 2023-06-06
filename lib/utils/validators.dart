// Define some functions for validating user input using String type and RegExp class

// A function that validates an email address using regular expression pattern matching
String? validateEmail(String? value) {
  // Define a regular expression pattern for email address
  final RegExp emailPattern = RegExp(
      r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$');

  // Check if value matches email pattern
  if (!emailPattern.hasMatch(value ?? '')) {
    // Return error message if not matched
    return 'Please enter a valid email address';
  }

  // Return null if matched
  return null;
}

// A function that validates a password using length criteria
// A function that validates a password using length criteria
String? validatePassword(String? value) {
  // Define a constant for the minimum length of the password
  const int minLength = 6;
  // Check if value is null or empty
  if (value == null || value.isEmpty) {
    // Return error message if null or empty
    return 'Password cannot be empty';
  }
  // Check if value has at least the minimum length
  if (value.length < minLength) {
    // Return error message if not met
    return 'Password must be at least $minLength characters long';
  }
  // Return null if met
  return null;
}

// A function that validates if two passwords match
String? validateConfirmPassword(String? value, String? password) {
  // Check if value is equal to password
  if (value != password) {
    // Return error message if not equal
    return 'Passwords do not match';
  }

  // Return null if equal
  return null;
}
