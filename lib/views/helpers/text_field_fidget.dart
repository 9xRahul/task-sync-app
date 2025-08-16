import 'package:flutter/material.dart';

Widget buildTextField({
  required String label,
  required TextEditingController controller,
  IconData? icon,
  bool isPassword = false,
  int minLength = 0,
  int maxLength = 100,
  isVerfying = false,
  String? Function(String?)? customValidator,
}) {
  return TextFormField(
    controller: controller,
    obscureText: isPassword,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      errorStyle: const TextStyle(
        color: Color(0x001F54), // keep red
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 0.0,
            color: Colors.black,
          ),
        ],
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(50),
      ),
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      hintStyle: const TextStyle(color: Colors.white),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
      prefixIcon: icon != null ? Icon(icon, color: Colors.white) : null,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    ),
    validator:
        customValidator ??
        (value) {
          if (value == null || value.trim().isEmpty) {
            return "$label is required";
          }

          if (isVerfying == true && value.trim().length < 6) {
            return "$label must be 6 characters";
          }

          if (value.trim().length < minLength) {
            return "$label must be at least $minLength characters";
          }
          if (value.trim().length > maxLength) {
            return "$label must be less than or equal to $maxLength characters";
          }
          return null;
        },
  );
}
