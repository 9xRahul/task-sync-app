import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tasksync/bloc/app/app_bloc.dart';
import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/config/app_config/image_config.dart';
import 'package:tasksync/config/app_config/size_config.dart';
import 'package:tasksync/config/shared_preferences/auth_storage.dart';
import 'package:tasksync/views/helpers/app_bacr_icons.dart';
import 'package:tasksync/views/helpers/drawer_list_tile.dart';
import 'package:tasksync/views/helpers/text_widget.dart';
import 'package:tasksync/views/screens/add_task_screen/add_task_screen.dart';
import 'package:tasksync/views/screens/login_screen/signin_screen.dart';
import 'package:tasksync/views/screens/taks_screen/widgets/category_item_widget.dart';
import 'package:tasksync/views/screens/taks_screen/widgets/select_tasks_by_status_widget.dart';

class HomeScreenTasks extends StatefulWidget {
  const HomeScreenTasks({super.key});

  @override
  State<HomeScreenTasks> createState() => _HomeScreenTasksState();
}

class _HomeScreenTasksState extends State<HomeScreenTasks> {
  String user = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    final userInfo = await AuthStorage.getUserInfo();
    final token = await AuthStorage.getToken();
    if (!mounted) return;
    context.read<AppBloc>().add(UpdateAppState(token: token, user: userInfo));

    // widget may have been disposed

    setState(() {
      user = userInfo.name ?? "Guest";
    });

    // Emit updated app state to Bloc safely
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImageConfig.splashBg), // your asset path
            opacity: .1,
            fit: BoxFit.cover, // make it fill the screen
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              height: kToolbarHeight + MediaQuery.of(context).padding.top,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageConfig.splashBg),
                  fit: BoxFit.cover,
                ),
              ),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: ColorConfig.appBArIconColor,
                        size: SizeConfig().appBarIconSize,
                      ),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  Expanded(
                    child: textWidget(
                      text: "TaskSync",
                      color: ColorConfig.appBArIconColor,
                      fontSize: SizeConfig().appBarFontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
              ),
            ),

            categoryItemWidget(context: context),
            SelectTasksByStatusWidget(context: context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent, // Make FAB background transparent
        elevation: 0, // Remove shadow
        highlightElevation: 0,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },

        child: Lottie.asset(
          'assets/animations/add.json',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          repeat: true, // repeat animation
        ),
      ),
    );
  }
}
