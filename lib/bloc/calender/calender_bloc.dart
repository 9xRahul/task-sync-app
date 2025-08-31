import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasksync/bloc/calender/calender_event.dart';
import 'package:tasksync/bloc/calender/calender_state.dart';

import 'package:tasksync/models/task_model.dart';
import 'package:tasksync/repository/task_reposiytory.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  TaskRepository taskRepository;
  CalendarBloc({required this.taskRepository})
    : super(
        CalendarState(
          isError: false,
          isLoading: false,
          focusedDay: DateTime.now(),
          selectedDay: DateTime.now(), // ✅ default = today
        ),
      ) {
    on<LoadCalendarTasks>(_onLoadTasks);
    on<SelectDayEvent>(_onSelectDay);
  }

  Future<void> _onLoadTasks(
    LoadCalendarTasks event,
    Emitter<CalendarState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,
        focusedDay: DateTime.now(),
        selectedDay: DateTime.now(),
      ),
    );
    try {
      final response = await taskRepository.getAllTasks();
      List<TaskModel> taskData = response['data'] as List<TaskModel>;
      emit(state.copyWith(tasks: taskData, isLoading: false, isError: false));
    } catch (e) {}
  }

  void _onSelectDay(SelectDayEvent event, Emitter<CalendarState> emit) {
    emit(
      state.copyWith(
        selectedDay: event.selectedDay,
        focusedDay: event.selectedDay,
      ),
    );
  }
}
