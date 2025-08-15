import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasksync/bloc/app/app_bloc.dart';
import 'package:tasksync/bloc/bottom_nav/bottom_nav_bar_bloc.dart';
import 'package:tasksync/bloc/home_screen/home_screen_bloc.dart';
import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/config/app_config/constants.dart';
import 'package:tasksync/config/app_config/enums.dart';
import 'package:tasksync/config/app_config/image_config.dart';
import 'package:tasksync/config/app_config/size_config.dart';
import 'package:tasksync/config/shared_preferences/auth_storage.dart';
import 'package:tasksync/helpers/app_bacr_icons.dart';
import 'package:tasksync/helpers/drawer_list_tile.dart';
import 'package:tasksync/helpers/text_widget.dart';
import 'package:tasksync/views/calender_screen.dart/calender_screen.dart';
import 'package:tasksync/views/home_screen/widgets/category_item_widget.dart';
import 'package:tasksync/views/home_screen/widgets/select_tasks_by_status_widget.dart';
import 'package:tasksync/views/login_screen/signin_screen.dart';
import 'package:tasksync/views/overview_screen/overview_screen.dart';

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

  final List<Widget> _pages = [
    const HomeScreenTasks(),
    CalenderScreen(),
    const OverViewScreen(),
  ];

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

      body: BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
        builder: (context, state) {
          return _pages[state.bottomNavIndex];
        },
      ),
      bottomNavigationBar: BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: state.bottomNavIndex,
            selectedItemColor: Colors.pink,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              context.read<BottomNavBarBloc>().add(
                BottomnavItemChangeEvent(index: index),
              );
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.task_alt_outlined),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                label: 'Calender',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.show_chart_outlined),
                label: 'Overview',
              ),
            ],
          );
        },
      ),
    );
  }
}

class HomeScreenTasks extends StatelessWidget {
  const HomeScreenTasks({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
