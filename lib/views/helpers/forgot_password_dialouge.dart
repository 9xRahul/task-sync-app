import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasksync/bloc/signin/signin_bloc.dart';
import 'package:tasksync/views/helpers/text_field_fidget.dart';
import 'package:tasksync/views/helpers/toast_messenger.dart';
import 'package:tasksync/views/helpers/update_password_dialouge.dart';

void resetPasswordDialouge({
  required BuildContext context,
  bool passwordResetScreen = false,
}) {
  final emailController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return BlocListener<SigninBloc, SigninState>(
        listenWhen: (previous, current) {
          // Only react when:
          // - Loading state changes
          // - isResettingPassword changes (false → true after API)
          // - Error flag changes
          return previous.loading != current.loading ||
              previous.isResettingPassword != current.isResettingPassword ||
              previous.error != current.error ||
              previous.buttonIsLoading != current.buttonIsLoading;
        },
        listener: (_, state) {
          if (!state.loading &&
              state.isResettingPassword &&
              !state.buttonIsLoading) {
            // ✅ API call finished and reset process started successfully
            updatePasswordDialouge(context: context);
          } else if (state.error && !state.loading && !state.buttonIsLoading) {
            // Show error message only when API finishes with error
            ToastHelper.show(
              state.message,
              bgColor: Colors.red,
              textColor: Colors.white,
            );
          }
        },
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: const DecorationImage(
                image: AssetImage('assets/images/authbg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Enter your email",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                buildTextField(
                  label: "Registered Email",
                  controller: emailController,
                  customValidator: (p0) {
                    if (p0 == null || p0.trim().isEmpty) {
                      return "Email is required";
                    }
                    if (p0.trim().length < 6) {
                      return "Invalid email length";
                    }
                    return null;
                  },
                  isVerfying: false,
                ),
                const SizedBox(height: 20),
                BlocBuilder<SigninBloc, SigninState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.loading
                          ? null
                          : () {
                              final email = emailController.text.trim();
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );

                              if (email.isEmpty) {
                                ToastHelper.show(
                                  "Please enter your email address.",
                                  bgColor: Colors.red,
                                  textColor: Colors.white,
                                );
                              } else if (!emailRegex.hasMatch(email)) {
                                ToastHelper.show(
                                  "Please enter a valid email address.",
                                  bgColor: Colors.red,
                                  textColor: Colors.white,
                                );
                              } else {
                                context.read<SigninBloc>().add(
                                  ResetPasswordEvent(email: email),
                                );
                              }
                            },
                      child: state.buttonIsLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Submit"),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
