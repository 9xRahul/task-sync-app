import 'package:flutter/material.dart';

class EmptyContainer {
  static horizontalEmptyContainer({required double width}) {
    return Container(width: width);
  }

  static verticalEmptyContainer({required double height}) {
    return Container(height: height);
  }
}
