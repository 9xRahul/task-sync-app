import 'package:equatable/equatable.dart';
import 'package:tasksync/models/task_model.dart';

class CalendarState extends Equatable {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final List<TaskModel> tasks;
  final bool isError;
  final bool isLoading;

  const CalendarState({
    required this.focusedDay,
    this.selectedDay,
    this.tasks = const [],
    this.isError = false,
    this.isLoading = false,
  });

  CalendarState copyWith({
    DateTime? focusedDay,
    DateTime? selectedDay,
    List<TaskModel>? tasks,
    bool? isLoading,
    bool? isError,
  }) {
    return CalendarState(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      tasks: tasks ?? this.tasks,
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    focusedDay,
    selectedDay,
    tasks,
    isError,
    isLoading,
  ];
}
