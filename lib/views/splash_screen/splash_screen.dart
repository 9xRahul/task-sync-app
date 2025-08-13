import 'package:flutter/material.dart';
import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/config/app_config/size_config.dart';
import 'package:tasksync/config/shared_preferences/auth_storage.dart';
import 'package:tasksync/views/home_screen/home_screen.dart';
import 'package:tasksync/views/login_screen/signin_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    bool loggedIn = await AuthStorage.isLoggedIn();

    if (!mounted) return; // <- Prevent navigation if widget is gone

    if (loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen()),
      );
    } else {
      await Future.delayed(Duration(seconds: 2));
      if (!mounted) return; // <- Check again after delay
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.initialize(context);
    return Scaffold(
      body: Container(
        width: SizeConfig.screenWidth,
        height: SizeConfig.screenHeight,
        decoration: BoxDecoration(
          color: ColorConfig.primary,
          image: DecorationImage(
            image: AssetImage('assets/images/authbg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: SizeConfig.paddingAll(20),
        child: Center(
          child: Container(
            child: Image.asset(
              'assets/images/splashlogo.png',
              width: SizeConfig.scaleWidth(300),
              height: SizeConfig.scaleHeight(300),
            ),
          ),
        ),
      ),
    );
  }
}
