import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasksync/bloc/signin/signin_bloc.dart';
import 'package:tasksync/bloc/signup/signup_bloc.dart';
import 'package:tasksync/config/shared_preferences/auth_storage.dart';
import 'package:tasksync/helpers/text_field_fidget.dart';
import 'package:tasksync/helpers/toast_messenger.dart';
import 'package:tasksync/views/login_screen/signin_screen.dart';

void updatePasswordDialouge({
  required BuildContext context,
  bool passwordResetScreen = false,
}) {
  final passwordController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return BlocListener<SigninBloc, SigninState>(
        listener: (_, state) {
          if (!state.error && !state.loading) {
            ToastHelper.show(
              "Password updated successfully",
              bgColor: Colors.green,
              textColor: Colors.white,
            );
            AuthStorage.logout();

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => LoginScreen()),
              (route) => false,
            );
          } else if (state.error && !state.loading) {
            ToastHelper.show(
              state.message,
              bgColor: Colors.red,
              textColor: Colors.white,
            );
          }
        },
        child: AlertDialog(
          backgroundColor: Colors.transparent, // Transparent background
          contentPadding: EdgeInsets.zero, // Remove default padding
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage('assets/images/authbg.jpg'),
                // <-- your background image
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Update Password",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                buildTextField(
                  label: "Enter New Password",
                  controller: passwordController,

                  customValidator: (p0) {
                    if (p0 == null || p0.trim().isEmpty) {
                      return "password is required";
                    }
                    if (p0.trim().length < 6) {
                      return "Password  must be 6 characters";
                    }
                    return null;
                  },
                  isVerfying: false,
                ),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final newPassword = passwordController.text.trim();

                    // Simple email regex pattern

                    if (newPassword.isEmpty) {
                      ToastHelper.show(
                        "Please enter your email address.",
                        bgColor: Colors.red,
                        textColor: Colors.white,
                      );
                    } else if (newPassword.length < 6) {
                      ToastHelper.show(
                        "Enter minimum 6 characters",
                        bgColor: Colors.red,
                        textColor: Colors.white,
                      );
                    } else {
                      context.read<SigninBloc>().add(
                        UpdatePasswordEvent(newPassword: newPassword),
                      );
                    }
                  },
                  child: BlocBuilder<SigninBloc, SigninState>(
                    builder: (context, state) {
                      if (state.loading) {
                        return const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        );
                      }
                      return const Text("Submit");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
