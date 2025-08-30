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
  bool _isCalendarView = true; // 🔁 toggle between calendar & horizontal list

  // Example tasks (replace with your DB data)
  final Map<DateTime, List<String>> _tasks = {
    DateTime.utc(2025, 8, 12): ['Task A', 'Task B'],
    DateTime.utc(2025, 8, 15): ['Task C'],
    DateTime.utc(2025, 8, 20): ['Task D', 'Task E', 'Task F'],
  };

  // Normalize to Y/M/D (so time doesn't affect equality)
  DateTime _d(DateTime d) => DateTime(d.year, d.month, d.day);

  bool _hasTask(DateTime day) {
    final k = _d(day);
    return _tasks.keys.any((t) => _d(t) == k);
  }

  List<String> _tasksFor(DateTime day) => _tasks[_d(day)] ?? [];

  List<DateTime> _daysInMonth(DateTime month) {
    final first = DateTime(month.year, month.month, 1);
    final next = DateTime(month.year, month.month + 1, 1);
    final last = next.subtract(const Duration(days: 1));
    return List.generate(
      last.day,
      (i) => DateTime(month.year, month.month, i + 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selectedDay ?? _focusedDay;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Calendar"),
        actions: [
          IconButton(
            tooltip: _isCalendarView ? "Show dates list" : "Show calendar",
            icon: Icon(
              _isCalendarView ? Icons.view_agenda : Icons.calendar_month,
            ),
            onPressed: () {
              setState(() => _isCalendarView = !_isCalendarView);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ======= TOP: Calendar OR Horizontal Strip =======
          if (_isCalendarView)
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
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
            )
          else
            // ======= HORIZONTAL DATES STRIP (with overflow-safe sizing) =======
            SizedBox(
              height: 100, // total height for the strip
              child: Column(
                children: [
                  // Month label + arrows
                  SizedBox(
                    height: 32,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Text(
                            "${_focusedDay.year}-${_focusedDay.month.toString().padLeft(2, '0')}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                _focusedDay = DateTime(
                                  _focusedDay.year,
                                  _focusedDay.month - 1,
                                  1,
                                );
                                _selectedDay = DateTime(
                                  _focusedDay.year,
                                  _focusedDay.month,
                                  1,
                                );
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              setState(() {
                                _focusedDay = DateTime(
                                  _focusedDay.year,
                                  _focusedDay.month + 1,
                                  1,
                                );
                                _selectedDay = DateTime(
                                  _focusedDay.year,
                                  _focusedDay.month,
                                  1,
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Dates list
                  SizedBox(
                    height: 64,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: _daysInMonth(_focusedDay).length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final day = _daysInMonth(_focusedDay)[index];
                        final isSelected = _d(day) == _d(selected);
                        final hasTask = _hasTask(day);

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDay = day;
                              _focusedDay = day;
                            });
                          },
                          child: Container(
                            width: 56,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blueAccent
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blueAccent
                                    : Colors.grey.shade300,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  [
                                    "Sun",
                                    "Mon",
                                    "Tue",
                                    "Wed",
                                    "Thu",
                                    "Fri",
                                    "Sat",
                                  ][day.weekday % 7],
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${day.day}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                if (hasTask)
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.orange,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

          // ======= TASKS LIST FOR SELECTED DAY (Widget list, no type error) =======
          Expanded(
            child: ListView(
              children: _tasksFor(selected).isNotEmpty
                  ? _tasksFor(selected).map<Widget>((task) {
                      return ListTile(
                        title: Text(task),
                        leading: const Icon(Icons.task),
                      );
                    }).toList()
                  : const [
                      Center(
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
