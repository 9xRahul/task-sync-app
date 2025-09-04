import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tasksync/bloc/add_task/add_task_bloc.dart';
import 'package:tasksync/bloc/app/app_bloc.dart';
import 'package:tasksync/bloc/bottom_nav/bottom_nav_bar_bloc.dart';
import 'package:tasksync/bloc/calender/calender_bloc.dart';
import 'package:tasksync/bloc/home_screen/home_screen_bloc.dart';
import 'package:tasksync/bloc/signin/signin_bloc.dart';
import 'package:tasksync/bloc/signup/signup_bloc.dart' show SignupBloc;
import 'package:tasksync/bloc/summary/summary_bloc.dart';
import 'package:tasksync/config/app_config/size_config.dart';
import 'package:tasksync/repository/auth_methods.dart';
import 'package:tasksync/repository/task_reposiytory.dart';
import 'package:tasksync/views/screens/home_screen/home_screen.dart';
import 'package:tasksync/views/screens/splash_screen/splash_screen.dart';

/// 🔹 Background handler (runs when app is killed or in background)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 [Background] ${message.notification?.title} - ${message.data}");
}

/// 🔹 Local notifications plugin (foreground use)
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ✅ Register background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ Local notifications setup
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // ✅ Request permission (important for iOS + Android 13+)
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // ✅ Print the device token (send this to your backend when user logs in)
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print("🔥 FCM Token: $fcmToken");

  // ✅ Foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📩 [Foreground] ${message.notification?.title}");

    if (message.notification != null) {
      flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000, // unique ID
        message.notification!.title,
        message.notification!.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'task_channel',
            'Task Notifications',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  });

  // ✅ Notification tapped while app is in background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("📩 [Tapped from background] ${message.data}");
    // Example: Navigate to task details screen
  });

  // ✅ App opened from terminated state (cold start)
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    print("📩 [Opened from terminated] ${initialMessage.data}");
    // Example: Navigate to task details
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SignupBloc(authRepository: AuthRepository()),
        ),
        BlocProvider(
          create: (_) => SigninBloc(authRepository: AuthRepository()),
        ),
        BlocProvider(
          create: (_) => SummaryBloc(taskRepository: TaskRepository()),
        ),
        BlocProvider(
          create: (_) => HomeScreenBloc(taskRepository: TaskRepository()),
        ),
        BlocProvider(create: (_) => BottomNavBarBloc()),
        BlocProvider(
          create: (_) => AddTaskBloc(taskRepository: TaskRepository()),
        ),
        BlocProvider(
          create: (_) => CalendarBloc(taskRepository: TaskRepository()),
        ),
      ],
      child: MyApp(),
    ),
  );
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

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(textTheme: GoogleFonts.poorStoryTextTheme()),
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
          );
        },
      ),
    );
  }
}
