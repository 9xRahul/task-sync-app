import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasksync/bloc/signin/signin_bloc.dart';
import 'package:tasksync/bloc/signup/signup_bloc.dart';
import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/config/app_config/size_config.dart';
import 'package:tasksync/helpers/forgot_password_dialouge.dart';
import 'package:tasksync/helpers/text_field_fidget.dart';
import 'package:tasksync/helpers/toast_messenger.dart';
import 'package:tasksync/helpers/verification_dialouge.dart';
import 'package:tasksync/views/signup_screen/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSignup = true; // false = login, true = signup

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
  }

  // Reusable text field widget

  @override
  Widget build(BuildContext context) {
    print("rebuild");
    return Scaffold(
      body: BlocBuilder<SigninBloc, SigninState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              width: SizeConfig.screenWidth,
              height: SizeConfig.screenHeight,
              decoration: BoxDecoration(
                color: ColorConfig.primary,
                image: DecorationImage(
                  image: AssetImage('assets/images/authbg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        color: Colors.white,
                        width: SizeConfig().authLogoWidth,
                        height: SizeConfig().authLogoHeight,
                        image: AssetImage('assets/images/signup.png'),
                      ),

                      buildTextField(
                        customValidator: (p0) {
                          if (p0 == null || p0.trim().isEmpty) {
                            return "Email is required";
                          }
                          if (!RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          ).hasMatch(p0.trim())) {
                            return "Invalid email format";
                          }
                          return null;
                        },
                        maxLength: 20,
                        minLength: 6,
                        label: "Email",
                        controller: _emailController,
                        icon: Icons.email,
                      ),
                      SizedBox(height: 12),
                      buildTextField(
                        customValidator: (p0) {
                          if (p0 == null || p0.trim().isEmpty) {
                            return "Password is required";
                          }
                          if (p0.trim().length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                        maxLength: 20,
                        minLength: 2,
                        label: "Password",
                        icon: Icons.lock,
                        controller: _passwordController,
                        isPassword: true,
                      ),

                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            resetPasswordDialouge(context: context);
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      BlocConsumer<SigninBloc, SigninState>(
                        listener: (context, state) {
                          if (state.error) {
                            ToastHelper.show(
                              state.message,
                              bgColor: Colors.red,
                              textColor: Colors.white,
                            );
                          } else if (!state.error && state.message.isNotEmpty) {
                            ToastHelper.show(
                              state.message,
                              bgColor: Colors.green,
                              textColor: Colors.white,
                            );
                          }
                        },
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<SigninBloc>().add(
                                  LoginSubmitted(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                  ),
                                );
                              }
                            },
                            child: state.loading == true
                                ? Container(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  )
                                : Text("Login"),
                          );
                        },
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => SignupScreen()),
                          );

                          _formKey.currentState?.reset();
                        },
                        child: BlocBuilder<SigninBloc, SigninState>(
                          builder: (context, state) {
                            return Text(
                              "Don't have an account? Sign Up",
                              style: TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
