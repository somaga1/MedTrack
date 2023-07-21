import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String logo;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.logo,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            logo,
            height: 40.0,
          ),
          SizedBox(width: 8.0),
          Text(title),
        ],
      ),
      backgroundColor: Colors.green[900],
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
