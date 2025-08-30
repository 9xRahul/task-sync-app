import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:tasksync/bloc/app/app_bloc.dart';
import 'package:tasksync/bloc/home_screen/home_screen_bloc.dart';
import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/config/app_config/image_config.dart';
import 'package:tasksync/config/app_config/size_config.dart';
import 'package:tasksync/config/shared_preferences/auth_storage.dart';
import 'package:tasksync/views/helpers/app_bacr_icons.dart';
import 'package:tasksync/views/helpers/drawer_list_tile.dart';
import 'package:tasksync/views/helpers/empty_container.dart';
import 'package:tasksync/views/helpers/text_widget.dart';
import 'package:tasksync/views/screens/add_task_screen/add_task_screen.dart';
import 'package:tasksync/views/screens/login_screen/signin_screen.dart';
import 'package:tasksync/views/screens/taks_screen/widgets/category_item_widget.dart';
import 'package:tasksync/views/screens/taks_screen/widgets/select_tasks_by_status_widget.dart';
import 'package:tasksync/views/screens/taks_screen/widgets/sortDialog.dart';
import 'package:tasksync/views/screens/taks_screen/widgets/task_list_widget.dart';

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
    getTasks();
  }

  void getTasks() {
    context.read<HomeScreenBloc>().add(GetAllTasks());
  }

  Future<void> getUserInfo() async {
    final userInfo = await AuthStorage.getUserInfo();
    final token = await AuthStorage.getToken();
    if (!mounted) return;
    context.read<AppBloc>().add(UpdateAppState(token: token, user: userInfo));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                    BlocBuilder<AppBloc, AppState>(
                      builder: (context, state) {
                        return textWidget(
                          text: "Welcome\n${state.user.name}",
                          color: ColorConfig.textLight,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        );
                      },
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
                  BlocBuilder<HomeScreenBloc, HomeScreenState>(
                    builder: (context, state) {
                      return Expanded(
                        child: state.isSearching
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 0,
                                ),
                                child: TextField(
                                  onChanged: (value) {
                                    // 👇 send search query to your Bloc
                                    context.read<HomeScreenBloc>().add(
                                      SearchEvent(query: value),
                                    );
                                  },

                                  decoration: InputDecoration(
                                    hintText: "Search tasks...",
                                    hintStyle: TextStyle(
                                      color: ColorConfig
                                          .appBArIconColor, // your hint color
                                      fontSize: SizeConfig().appBarFontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    filled: true,
                                    isDense: true,
                                    fillColor: Colors
                                        .white, // ✅ background inside text box
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide:
                                          BorderSide.none, // ✅ no border line
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide:
                                          BorderSide.none, // ✅ no border line
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide:
                                          BorderSide.none, // ✅ no border line
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 10,
                                    ),
                                  ),
                                  style: GoogleFonts.aBeeZee().copyWith(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ), // ✅ typed text in black
                                ),
                              )
                            : textWidget(
                                text: "TaskSync",
                                color: ColorConfig.appBArIconColor,
                                fontSize: SizeConfig().appBarFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                      );
                    },
                  ),

                  BlocBuilder<HomeScreenBloc, HomeScreenState>(
                    builder: (context, state) {
                      return appBarIconButton(
                        icon: state.isSearching ? Icons.close : Icons.search,
                        iconSize: SizeConfig().appBarIconSize,
                        iconColor: ColorConfig.appBArIconColor,
                        onPressed: () {
                          final current = context
                              .read<HomeScreenBloc>()
                              .state
                              .isSearching;
                          print(current);
                          context.read<HomeScreenBloc>().add(
                            SetSearchStstusEvent(
                              isSearch: !current,
                            ), // <-- aligned name
                          );
                        },
                      );
                    },
                  ),

                  appBarIconButton(
                    icon: Icons.more_vert,
                    iconSize: SizeConfig().appBarIconSize,
                    iconColor: ColorConfig.appBArIconColor,
                    onPressed: () {
                      sortDialog(context);
                    },
                  ),
                ],
              ),
            ),

            categoryItemWidget(context: context),
            SelectTasksByStatusWidget(context: context),

            TasksItems(),
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
            MaterialPageRoute(builder: (_) => AddTaskScreen()),
          ).then((_) {
            context.read<HomeScreenBloc>().add(GetAllTasks());
          });
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
