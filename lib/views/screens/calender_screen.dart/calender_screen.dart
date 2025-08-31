import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tasksync/bloc/add_task/add_task_bloc.dart';
import 'package:tasksync/bloc/bottom_nav/bottom_nav_bar_bloc.dart';
import 'package:tasksync/bloc/calender/calender_bloc.dart';
import 'package:tasksync/bloc/calender/calender_event.dart';
import 'package:tasksync/bloc/calender/calender_state.dart';
import 'package:tasksync/bloc/home_screen/home_screen_bloc.dart';
import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/config/app_config/enums.dart';
import 'package:tasksync/config/app_config/image_config.dart';
import 'package:tasksync/config/app_config/size_config.dart';
import 'package:tasksync/models/task_model.dart';
import 'package:tasksync/views/helpers/floatting_sction_button.dart';
import 'package:tasksync/views/helpers/text_widget.dart';
import 'package:tasksync/views/screens/add_task_screen/add_task_screen.dart';

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

  bool _hasPendingTask(DateTime day, List<TaskModel> tasks) {
    return tasks.any((task) {
      final dueDate = task.dueDate != null
          ? DateTime.tryParse(task.dueDate!)
          : null;
      return dueDate != null &&
          task.status == TaskStatus.pending.name &&
          dueDate.year == day.year &&
          dueDate.month == day.month &&
          dueDate.day == day.day;
    });
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
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: state.focusedDay,
                    calendarFormat: CalendarFormat.month,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    selectedDayPredicate: (day) =>
                        isSameDay(state.selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      context.read<CalendarBloc>().add(
                        SelectDayEvent(selectedDay),
                      );
                    },
                    onPageChanged: (focusedDay) {},
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    calendarStyle: const CalendarStyle(
                      cellMargin: EdgeInsets.all(2),
                      cellPadding: EdgeInsets.zero,
                      outsideDaysVisible: false,
                      defaultTextStyle: TextStyle(fontSize: 12),
                      todayTextStyle: TextStyle(fontSize: 12),
                      selectedTextStyle: TextStyle(fontSize: 12),
                    ),
                    calendarBuilders: CalendarBuilders(
                      todayBuilder: (context, day, focusedDay) {
                        return Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.blueAccent,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      },
                      selectedBuilder: (context, day, focusedDay) {
                        return Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      },
                      markerBuilder: (context, day, events) {
                        if (_hasPendingTask(day, state.tasks)) {
                          return Positioned(
                            bottom: 10,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),

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

                        return ListView(
                          children: filteredTasks.map((task) {
                            final dueDate = task.dueDate != null
                                ? DateTime.tryParse(task.dueDate!)
                                : null;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 2,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.pink.withOpacity(.03),
                                  border: Border(
                                    left: BorderSide(
                                      color: task.status == TaskStatus.done.name
                                          ? ColorConfig.success
                                          : ColorConfig.error,
                                      width: 8.0,
                                    ),
                                  ),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                child: ListTile(
                                  leading: Icon(
                                    task.status == TaskStatus.done.name
                                        ? Icons.check_circle
                                        : Icons.pending,
                                    color: task.status == TaskStatus.done.name
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  title: textWidget(
                                    text: task.title ?? "",
                                    color: ColorConfig.backTextColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (task.description != null &&
                                          task.description!.isNotEmpty)
                                        textWidget(
                                          text: task.description!,
                                          color: ColorConfig.backTextColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      if (dueDate != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color:
                                                  task.status ==
                                                      TaskStatus.done.name
                                                  ? ColorConfig.success
                                                  : ColorConfig.error,
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 60,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              child: textWidget(
                                                text:
                                                    "${dueDate.day}-${dueDate.month}-${dueDate.year} ${task.time ?? ""}",
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  trailing: textWidget(
                                    text: task.status ?? "",
                                    color: ColorConfig.backTextColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  onTap: () {
                                    context.read<AddTaskBloc>().add(
                                      GetTaskDetailsToEdit(task: task),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => AddTaskScreen(
                                          isUpdate: true,
                                          task: task,
                                        ),
                                      ),
                                    ).then((_) {
                                      context.read<HomeScreenBloc>().add(
                                        GetAllTasks(),
                                      );
                                    });
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        );
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
