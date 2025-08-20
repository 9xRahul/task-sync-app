import 'package:flutter/material.dart';

Text textWidget({
  required String text,
  required Color color,
  required double fontSize,
  required FontWeight fontWeight,
  int? maxLines, // optional
}) {
  return Text(
    text,
    style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
    softWrap: true,
    maxLines: 8,
    overflow: TextOverflow.fade,
  );
}
