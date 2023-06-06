// // Import the flutter package
// import 'package:flutter/material.dart';



// class CustomTextField extends StatelessWidget {
//   final String labelText;
//   final IconData icon;
//   final bool obscureText;
//   final TextEditingController controller;
//   final String? Function(String?)? validator;

//   CustomTextField({
//     required this.labelText,
//     required this.icon,
//     required this.controller,
//     this.validator,
//     this.obscureText = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 16.0),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.grey.shade300, width: 1.0),
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         validator: validator,
//         decoration: InputDecoration(
//           contentPadding:
//               EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
//           border: InputBorder.none,
//           hintText: labelText,
//           hintStyle: TextStyle(color: Colors.grey.shade500),
//           icon: Icon(
//             icon,
//             color: Colors.blue.shade500,
//           ),
//         ),
//       ),
//     );
//   }
// }
// // CustomTextField(
// //   labelText: 'Name',
// //   icon: Icons.person,
// //   controller: nameController,
// //   validator: (value) {
// //     if (value!.isEmpty) return 'Name is required';
// //   },
// // )
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const CustomTextField({
    Key? key,
    required this.label,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
