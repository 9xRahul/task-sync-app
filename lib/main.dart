import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasksync/bloc/app/app_bloc.dart';
import 'package:tasksync/bloc/signin/signin_bloc.dart';
import 'package:tasksync/bloc/signup/signup_bloc.dart' show SignupBloc;
import 'package:tasksync/config/app_config/size_config.dart';
import 'package:tasksync/config/shared_preferences/auth_storage.dart';
import 'package:tasksync/repository/auth_methods.dart';
import 'package:tasksync/views/home_screen/home_screen.dart';
import 'package:tasksync/views/splash_screen/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc(),
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          if (state.isLoading) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: SplashScreen(),
            );
          }

          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => SignupBloc(authRepository: AuthRepository()),
              ),
              BlocProvider(
                create: (_) => SigninBloc(authRepository: AuthRepository()),
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Builder(
                builder: (context) {
                  SizeConfig.initialize(context);

                  if (state.token != null && state.token!.isNotEmpty) {
                    return HomeScreen();
                  } else {
                    return SplashScreen();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
