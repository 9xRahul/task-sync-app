import 'package:flutter/material.dart';

Widget drawerListTile({
  required IconData icon,
  required Color iconColor,
  required double iconSize,
  required String title,
  required double textSize,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: iconColor, size: iconSize),
    title: Text(
      title,
      style: TextStyle(color: iconColor, fontSize: textSize),
    ),
    onTap: onTap,
  );
}
