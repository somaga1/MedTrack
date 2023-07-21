// // Import the flutter package
// import 'package:flutter/material.dart';
// import 'package:medtrack/utils/colors.dart';

// // Create a class called CustomButton that extends the ElevatedButton widget
// class CustomButton extends ElevatedButton {
//   // Create a constructor for the class that takes named parameters and passes them to the super constructor
//   CustomButton({
//     Key? key,
//     required VoidCallback onPressed,
//     Widget? child,
//     Color? color,
//     double? width,
//     double? height,
//   }) : super(
//           key: key,
//           onPressed: onPressed,
//           child: child,
//         );

//   get color => null;

//   get height => null;

//   get width => null;

//   // Override the build method to return a custom button widget
//   @override
//   Widget build(BuildContext context) {
//     // Return a Container widget with some padding and decoration
//     return Container(
//       padding: EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8.0),
//         color: color ?? AppColor.deepgreen,
//       ),
//       // Use a ConstrainedBox widget to set the width and height of the button
//       child: ConstrainedBox(
//         constraints:
//             BoxConstraints.tightFor(width: width ?? 400, height: height ?? 50),
//         // Use a Center widget to center the child widget inside the button
//         child: Center(child: child ?? Text('Button')),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color? textColor;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.color,
    this.textColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(text),
      style: ElevatedButton.styleFrom(
        primary: color,
        onPrimary: textColor ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      onPressed: onPressed,
    );
  }
}

