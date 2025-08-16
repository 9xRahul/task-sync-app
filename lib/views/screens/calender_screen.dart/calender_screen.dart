import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends StatefulWidget {
  CalenderScreen({super.key});

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen> {
  DateTime _focusedDay = DateTime.now();

  DateTime? _selectedDay;

  // Example pending tasks (replace with your DB data)
  final Map<DateTime, List<String>> _tasks = {
    DateTime.utc(2025, 8, 12): ['Task A', 'Task B'],
    DateTime.utc(2025, 8, 15): ['Task C'],
    DateTime.utc(2025, 8, 20): ['Task D', 'Task E', 'Task F'],
  };

  bool _hasTask(DateTime day) {
    return _tasks.keys.any(
      (taskDate) =>
          taskDate.year == day.year &&
          taskDate.month == day.month &&
          taskDate.day == day.day,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Calendar")),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,

            // Handle date selection
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },

            // Month navigation
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },

            // Highlight days with tasks
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                if (_hasTask(day)) {
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${day.day}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
                return null;
              },
              todayBuilder: (context, day, focusedDay) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Show tasks for selected day
          Expanded(
            child: ListView(
              children:
                  _tasks[_selectedDay ?? DateTime.now()]?.map((task) {
                    return ListTile(
                      title: Text(task),
                      leading: const Icon(Icons.task),
                    );
                  }).toList() ??
                  [
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("No tasks for this day"),
                      ),
                    ),
                  ],
            ),
          ),
        ],
      ),
    );
  }
}
