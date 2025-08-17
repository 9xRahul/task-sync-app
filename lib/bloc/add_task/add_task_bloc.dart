import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tasksync/repository/task_reposiytory.dart';

part 'add_task_event.dart';
part 'add_task_state.dart';

class AddTaskBloc extends Bloc<AddTaskEvent, AddTaskState> {
  final TaskRepository taskRepository;
  AddTaskBloc({required this.taskRepository})
    : super(
        AddTaskState(
          category: "All",
          date: null,
          time: null,
          description: "",
          title: "",
        ),
      ) {
    on<SelectCategoryEvent>(_selectCategory);
    on<SelectDateEvent>(_selectDate);
    on<SelectTimeEvent>(_selectTime);
    on<ResetAllEvent>(_reasetValues);
    on<GEtTaskDataToStoreEvent>(_getTaskDataToStore);
    on<CatchErrorEvent>(_catchErrorEvent);
  }

  void _catchErrorEvent(CatchErrorEvent event, Emitter<AddTaskState> emit) {
    emit(state.copyWith(error: true));
  }

  void _getTaskDataToStore(
    GEtTaskDataToStoreEvent event,
    Emitter<AddTaskState> emit,
  ) async {
    emit(state.copyWith(error: false, loading: true, message: ""));

    try {
      Map<String, dynamic> taskDataResponse = await TaskRepository().addTask(
        title: event.taskName,
        description: event.taskDescription,
        dueDate: state.date!,
        time: state.time!,
        category: state.category,
      );

      if (taskDataResponse['status'] == true &&
          taskDataResponse['data'] != null) {
        emit(
          state.copyWith(
            error: false,
            message: "Task added successfully",
            loading: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            error: true,
            message: taskDataResponse['message'],
            loading: false,
          ),
        );
      }
    } catch (e) {
      emit(state.copyWith(error: true, loading: false));
    }
  }

  void _selectDate(SelectDateEvent event, Emitter<AddTaskState> emit) {
    final now = DateTime.now();
    final selectedDate = event.date;

    // Compare only the date part (ignore time)
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    if (dateToCheck.isBefore(today)) {
      emit(
        state.copyWith(
          error: true,
          message: "Selected date cannot be in the past",
        ),
      );
    } else {
      emit(state.copyWith(date: selectedDate, error: false, message: ""));
    }
  }

  void _selectTime(SelectTimeEvent event, Emitter<AddTaskState> emit) {
    final now = DateTime.now();
    final selectedTime = event.time;

    if (state.date != null) {
      final today = DateTime(now.year, now.month, now.day);

      if (state.date!.year == today.year &&
          state.date!.month == today.month &&
          state.date!.day == today.day) {
        if (selectedTime.hour < now.hour ||
            (selectedTime.hour == now.hour &&
                selectedTime.minute < now.minute)) {
          print("Invalid time");
          emit(
            state.copyWith(
              error: true,
              message: "Selected time cannot be in the past",
            ),
          );
          return;
        }
      }
    }

    emit(state.copyWith(time: selectedTime, error: false, message: ""));
  }

  void _selectCategory(SelectCategoryEvent event, Emitter<AddTaskState> emit) {
    print(state.error);
    emit(state.copyWith(category: event.category, error: false, message: ""));
  }

  void _reasetValues(ResetAllEvent event, Emitter<AddTaskState> emit) {
    emit(AddTaskState.initial());
  }
}
