import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:tasksync/bloc/bottom_nav/bottom_nav_bar_bloc.dart';
import 'package:tasksync/bloc/calender/calender_bloc.dart';
import 'package:tasksync/bloc/calender/calender_event.dart';
import 'package:tasksync/bloc/calender/calender_state.dart';

import 'package:tasksync/config/app_config/color_config.dart';

import 'package:tasksync/config/app_config/image_config.dart';
import 'package:tasksync/config/app_config/size_config.dart';

import 'package:tasksync/views/helpers/floatting_sction_button.dart';
import 'package:tasksync/views/helpers/text_widget.dart';

import 'package:tasksync/views/screens/calender_screen.dart/widgets/calender_widget.dart';
import 'package:tasksync/views/screens/calender_screen.dart/widgets/task_list.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CalendarBloc>().add(LoadCalendarTasks()); // load tasks on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConfig.splashBg),
                opacity: .1,
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                // ✅ Always visible AppBar
                Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                  height: kToolbarHeight + MediaQuery.of(context).padding.top,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageConfig.splashBg),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: ColorConfig.appBArIconColor,
                          size: SizeConfig().appBarIconSize,
                        ),
                        onPressed: () {
                          context.read<BottomNavBarBloc>().add(
                            BottomnavItemChangeEvent(index: 0),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 0,
                        ),
                        child: textWidget(
                          text: "Calendar",
                          color: ColorConfig.appBArIconColor,
                          fontSize: SizeConfig().appBarFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // ✅ Loader or Content
                if (state.isLoading)
                  Expanded(
                    child: Center(
                      child: Lottie.asset(
                        'assets/animations/searching.json',
                        width: 200,
                        height: 200,
                        repeat: true,
                      ),
                    ),
                  )
                else ...[
                  // ✅ Calendar
                  calenderWidget(state, context),

                  // ✅ Tasks
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        final filteredTasks = state.tasks.where((task) {
                          final dueDate = task.dueDate != null
                              ? DateTime.tryParse(task.dueDate!)
                              : null;
                          return dueDate != null &&
                              isSameDay(dueDate, state.selectedDay);
                        }).toList();

                        if (filteredTasks.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 100),
                              child: Column(
                                children: [
                                  textWidget(
                                    text: "No tasks for this day",
                                    color: ColorConfig.backTextColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textWidget(
                                    text: "Click '+' icon to create a task",
                                    color: ColorConfig.backTextColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return taskList(filteredTasks, context);
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloattingSctionButton(context),
    );
  }
}
