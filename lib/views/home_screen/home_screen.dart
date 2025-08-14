import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasksync/bloc/app/app_bloc.dart';
import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/config/app_config/image_config.dart';
import 'package:tasksync/config/app_config/size_config.dart';
import 'package:tasksync/config/shared_preferences/auth_storage.dart';
import 'package:tasksync/helpers/app_bacr_icons.dart';
import 'package:tasksync/helpers/drawer_list_tile.dart';
import 'package:tasksync/helpers/text_widget.dart';
import 'package:tasksync/views/login_screen/signin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String user = "";

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    final userInfo = await AuthStorage.getUserInfo();
    final token = await AuthStorage.getToken();

    user = userInfo.name ?? "Guest";

    // Emit updated app state to Bloc
    context.read<AppBloc>().add(UpdateAppState(token: token, user: userInfo));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConfig.splashBg), // your bg image
              opacity: .1,
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: ColorConfig.appBArIconColor,
                  image: DecorationImage(
                    image: AssetImage(ImageConfig.splashBg),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage(ImageConfig.logo),
                      height: 100,
                      width: 100,
                    ),
                    textWidget(
                      text: "Welcome $user",
                      color: ColorConfig.textLight,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),

              drawerListTile(
                title: "Home",
                icon: Icons.home,
                iconColor: ColorConfig.textPrimary,
                iconSize: SizeConfig().drawerIconSize,
                textSize: SizeConfig().drawerFontSize,
                onTap: () {
                  print("Home tapped");
                },
              ),
              drawerListTile(
                title: "Settings",
                icon: Icons.settings,
                iconColor: ColorConfig.textPrimary,
                iconSize: SizeConfig().drawerIconSize,
                textSize: SizeConfig().drawerFontSize,
                onTap: () {
                  print("Settings tapped");
                },
              ),
              drawerListTile(
                title: "Logout",
                icon: Icons.logout_outlined,
                iconColor: ColorConfig.textPrimary,
                iconSize: SizeConfig().drawerIconSize,
                textSize: SizeConfig().drawerFontSize,
                onTap: () {
                  AuthStorage.logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),

      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: ColorConfig.appBArIconColor,
              size: SizeConfig().appBarIconSize,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // ✅ works now
            },
          ),
        ),
        title: textWidget(
          text: "TaskSync",
          color: ColorConfig.appBArIconColor,
          fontSize: SizeConfig().appBarFontSize,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          appBarIconButton(
            icon: Icons.search,
            iconSize: SizeConfig().appBarIconSize,
            iconColor: ColorConfig.appBArIconColor,
            onPressed: () {},
          ),
          appBarIconButton(
            icon: Icons.notifications,
            iconSize: SizeConfig().appBarIconSize,
            iconColor: ColorConfig.appBArIconColor,
            onPressed: () {},
          ),
          appBarIconButton(
            icon: Icons.more_vert,
            iconSize: SizeConfig().appBarIconSize,
            iconColor: ColorConfig.appBArIconColor,
            onPressed: () {},
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConfig.splashBg), // Your image path
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConfig.splashBg), // your asset path
            opacity: .1,
            fit: BoxFit.cover, // make it fill the screen
          ),
        ),
        child: Center(child: Text("Content goes here")),
      ),
    );
  }
}
