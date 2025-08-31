import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tasksync/bloc/calender/calender_bloc.dart';
import 'package:tasksync/bloc/calender/calender_event.dart';
import 'package:tasksync/bloc/calender/calender_state.dart';
import 'package:tasksync/config/app_config/enums.dart';
import 'package:tasksync/models/task_model.dart';

TableCalendar<Object?> calenderWidget(
  CalendarState state,
  BuildContext context,
) {
  return TableCalendar(
    firstDay: DateTime.utc(2020, 1, 1),
    lastDay: DateTime.utc(2030, 12, 31),
    focusedDay: state.focusedDay,
    calendarFormat: CalendarFormat.month,
    startingDayOfWeek: StartingDayOfWeek.monday,
    selectedDayPredicate: (day) => isSameDay(state.selectedDay, day),
    onDaySelected: (selectedDay, focusedDay) {
      context.read<CalendarBloc>().add(SelectDayEvent(selectedDay));
    },
    onPageChanged: (focusedDay) {},
    headerStyle: const HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      titleTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
            border: Border.all(color: Colors.blueAccent, width: 2),
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
        if (hasPendingTask(day, state.tasks)) {
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
  );
}

bool hasPendingTask(DateTime day, List<TaskModel> tasks) {
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
