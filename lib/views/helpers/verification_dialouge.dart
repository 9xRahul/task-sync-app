import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasksync/bloc/signup/signup_bloc.dart';
import 'package:tasksync/views/helpers/text_field_fidget.dart';
import 'package:tasksync/views/helpers/toast_messenger.dart';
import 'package:tasksync/views/screens/login_screen/signin_screen.dart';

void showVerificationDialog({
  required BuildContext context,
  required void Function(bool isVerified) onVerified,
}) {
  final codeController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return BlocListener<SignupBloc, SignupState>(
        listenWhen: (previous, current) {
          // Only listen when verificationLoading changes OR success/error changes
          return previous.verificationLoading != current.verificationLoading ||
              previous.isEmailVerified != current.isEmailVerified ||
              previous.error != current.error;
        },
        listener: (_, state) {
          if (!state.verificationLoading && state.isEmailVerified) {
            ToastHelper.show(
              "Account created & ${state.message}",
              bgColor: Colors.green,
              textColor: Colors.white,
            );
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => LoginScreen()),
              (route) => false,
            );
          } else if (state.error && !state.verificationLoading) {
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
                  "Verify Email",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                buildTextField(
                  label: "Verification code",
                  controller: codeController,
                  customValidator: (p0) {
                    if (p0 == null || p0.trim().isEmpty) {
                      return "Code is required";
                    }
                    if (p0.trim().length < 6) {
                      return "Code must be 6 characters";
                    }
                    return null;
                  },
                  isVerfying: true,
                ),
                const SizedBox(height: 20),
                BlocBuilder<SignupBloc, SignupState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state.verificationLoading
                          ? null
                          : () {
                              final code = codeController.text.trim();
                              if (code.length != 6) {
                                ToastHelper.show(
                                  "Code must be 6 characters.",
                                  bgColor: Colors.red,
                                  textColor: Colors.white,
                                );
                                return;
                              }
                              // Trigger verification and reset flag
                              context.read<SignupBloc>().add(
                                EmailVerify(verificationCode: code),
                              );
                            },
                      child: state.verificationLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text("Verify"),
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
