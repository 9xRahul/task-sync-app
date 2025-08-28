import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasksync/models/task_model.dart';
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
    on<GetTaskDetailsById>(_getTaskDetailsById);
    on<GetTaskDetailsToEdit>(_getIndividualtaskDetals);
    on<UpdateTaskDetails>(_updateTaskDetails);
  }

  void _updateTaskDetails(
    UpdateTaskDetails event,
    Emitter<AddTaskState> emit,
  ) async {
    emit(
      state.copyWith(
        error: false,
        loading: true,
        description: event.taskDescription,
        title: event.taskName,
      ),
    );
    try {
      var response = await TaskRepository().updateTaskStatus(
        categoryIndex: state.selectedcategoryIndex,
        isUpdateTask: true,
        sId: state.taskId,
        category: state.category,
        dueDate: state.date!,
        time: state.time!,
        description: event.taskDescription!,
        title: event.taskName!,
      );
      if (response['status'] == true) {
        emit(
          state.copyWith(
            error: false,
            loading: false,
            message: "Task Updated Successfully",
          ),
        );
      }
    } catch (e) {
      print(e);
      emit(state.copyWith(error: true, loading: false));
    }
  }

  void _getIndividualtaskDetals(
    GetTaskDetailsToEdit event,
    Emitter<AddTaskState> emit,
  ) {
    try {
      TimeOfDay? _parseTime(String? timeString) {
        if (timeString == null || timeString.trim().isEmpty) return null;

        try {
          // Try 24-hour format first
          final parsed24 = DateFormat("HH:mm").parseStrict(timeString);
          return TimeOfDay(hour: parsed24.hour, minute: parsed24.minute);
        } catch (_) {
          // If that fails, try 12-hour format (with AM/PM)
          try {
            final parsed12 = DateFormat("h:mm a").parseStrict(timeString);
            return TimeOfDay(hour: parsed12.hour, minute: parsed12.minute);
          } catch (e) {
            print("❌ Invalid time format: $timeString");
            return null;
          }
        }
      }

      DateTime? _parseDate(String? dateString) {
        if (dateString == null || dateString.isEmpty) return null;
        try {
          return DateTime.parse(dateString);
        } catch (e) {
          print("⚠️ Invalid date format: $dateString");
          return null;
        }
      }

      emit(
        state.copyWith(
          title: event.task.title,
          description: event.task.description,
          selectedcategoryIndex: event.task.categoryIndex,
          taskId: event.task.sId,
          date: _parseDate(event.task.dueDate),
          time: _parseTime(event.task.time),
        ),
      );
    } catch (e, stack) {
      print("⚠️ Error in _getIndividualtaskDetals: $e");
      print(stack);
      // you can also emit an error state if needed
      emit(state.copyWith(error: true, loading: false));
    }
  }

  void _getTaskDetailsById(
    GetTaskDetailsById event,
    Emitter<AddTaskState> emit,
  ) {}

  void _catchErrorEvent(CatchErrorEvent event, Emitter<AddTaskState> emit) {
    emit(state.copyWith(error: true));
  }

  void _getTaskDataToStore(
    GEtTaskDataToStoreEvent event,
    Emitter<AddTaskState> emit,
  ) async {
    emit(state.copyWith(error: false, loading: true, message: ""));

    try {
      print(state.category);
      Map<String, dynamic> taskDataResponse = await TaskRepository().addTask(
        title: event.taskName,
        description: event.taskDescription,
        dueDate: state.date!,
        time: state.time!,
        category: state.category,
        categoryIndex: state.selectedcategoryIndex,
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
    emit(
      state.copyWith(
        category: event.category,
        error: false,
        message: "",
        selectedcategoryIndex: event.categoryIndex,
      ),
    );
  }

  void _reasetValues(ResetAllEvent event, Emitter<AddTaskState> emit) {
    emit(AddTaskState.initial());
  }
}
