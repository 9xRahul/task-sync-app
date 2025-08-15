import 'package:flutter/material.dart';
import 'package:tasksync/config/app_config/image_config.dart';

class OverViewScreen extends StatelessWidget {
  const OverViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print("rebuild overview");
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageConfig.splashBg), // your asset path
          opacity: .1,
          fit: BoxFit.cover, // make it fill the screen
        ),
      ),
      child: Column(children: [Text("Over View Screen")]),
    );
  }
}
