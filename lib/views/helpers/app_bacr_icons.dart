import 'package:flutter/material.dart';

Widget appBarIconButton({
  required IconData icon,
  required double iconSize,
  Color iconColor = Colors.black, // default if not passed
  required VoidCallback onPressed,
}) {
  return IconButton(
    icon: Icon(icon, size: iconSize, color: iconColor),
    onPressed: onPressed,
  );
}
