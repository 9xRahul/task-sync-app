import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final double fontSize;
  final FontWeight fontWeight;
  final String hintText;
  final int maxLines;
  final TextInputAction textInputAction;
  final ValueChanged<String> onChanged;
  int? maxLength;
  bool isUpdate;
  String textToEdit;

  CustomTextField({
    Key? key,
    required this.isUpdate,
    required this.controller,
    required this.fontSize,
    required this.fontWeight,
    required this.hintText,
    required this.onChanged,
    required this.textToEdit,
    this.maxLines = 1,
    maxLength = 10,

    this.textInputAction = TextInputAction.done,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isUpdate) {
      controller.text = textToEdit;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        maxLength: maxLength,
        controller: controller,
        onChanged: onChanged,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none, // removes underline
        ),
        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        textInputAction: textInputAction,
      ),
    );
  }
}
