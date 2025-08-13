import 'package:flutter/material.dart';
import 'package:tasksync/config/shared_preferences/auth_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Screen")),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Thankyou for using TaskSync"),

            Image(image: AssetImage('assets/images/build.jpg')),
          ],
        ),
      ),
    );
  }

  void getToken() async {
    print("token got ${await AuthStorage.getToken()}");
  }
}
