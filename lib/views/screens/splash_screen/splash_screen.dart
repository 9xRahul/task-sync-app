import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/config/app_config/size_config.dart';
import 'package:tasksync/config/shared_preferences/auth_storage.dart';
import 'package:tasksync/views/screens/home_screen/home_screen.dart';
import 'package:tasksync/views/screens/login_screen/signin_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // ✅ Ask notification permission only once after install
    _checkAndRequestNotificationPermission();

    _navigate();
  }

  Future<void> _checkAndRequestNotificationPermission() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyAsked =
        prefs.getBool("notification_permission_asked") ?? false;

    if (!alreadyAsked) {
      NotificationSettings settings = await FirebaseMessaging.instance
          .getNotificationSettings();

      if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
        settings = await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
        print("🔔 User granted permission: ${settings.authorizationStatus}");
      }

      // ✅ Save flag so we don’t ask again
      await prefs.setBool("notification_permission_asked", true);
    }
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
