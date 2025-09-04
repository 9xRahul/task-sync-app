import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tasksync/config/app_config/constants.dart';
import 'package:tasksync/config/app_config/enums.dart';
import 'package:tasksync/models/task_model.dart';
import 'package:tasksync/repository/task_reposiytory.dart';
import 'package:tasksync/views/helpers/toast_messenger.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  TaskRepository taskRepository;
  HomeScreenBloc({required this.taskRepository})
    : super(
        HomeScreenState(selectedCategoryIndex: 0, tasks: [], filteredTasks: []),
      ) {
    on<CategoryChangeEvent>(_categoryChangeEvent);
    on<SelectTasksWithItsStatusEvent>(_selectTaskStstus);
    on<GetTaskByStatus>(_getTasksByStatus);
    on<GetAllTasks>(_getAllTasks);
    on<UpdateStatusEvent>(_updateStatus);
    on<RemoveFromTaskList>(_removeFromTaskList);
    on<DeleteTaskEvent>(_deleleteTask);
    on<SearchEvent>(_searchTask);
    on<SetSearchStstusEvent>(_setSearchStatus);
    on<SelectSortEvent>(_selectSort);
    on<DoSortEvent>(_sortEvent);
  }

  void _sortEvent(DoSortEvent event, Emitter<HomeScreenState> emit) {
    try {
      int sortIndex = state.sortIndex;
      List<TaskModel> sortedList = List.from(state.tasks);
      if (sortIndex == 1) {
        sortedList.sort((a, b) => a.title!.compareTo(b.title!));
      } else if (sortIndex == 2) {
        sortedList.sort((a, b) => b.title!.compareTo(a.title!));
      } else if (sortIndex == 3) {
        sortedList.sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
      } else if (sortIndex == 4) {
        sortedList.sort((a, b) => b.dueDate!.compareTo(a.dueDate!));
      }
      emit(state.copyWith(tasks: sortedList));
    } catch (e) {
      emit(state.copyWith());
    }
  }

  void _selectSort(SelectSortEvent event, Emitter<HomeScreenState> emit) {
    try {
      emit(state.copyWith(sortIndex: event.sortIndex));
    } catch (e) {}
  }

  void _setSearchStatus(
    SetSearchStstusEvent event,
    Emitter<HomeScreenState> emit,
  ) {
    emit(state.copyWith(isSearching: event.isSearch));
  }

  void _searchTask(SearchEvent event, Emitter<HomeScreenState> emit) async {
    print(event.query);
    try {
      emit(state.copyWith(error: false, loading: false));

      var response = {};

      if (event.query.isEmpty) {
        response = await TaskRepository().getTasks(
          category: state.selectedCategoryIndex == 0
              ? AppConstants.categoryList[0]
              : AppConstants.categoryList[state.selectedCategoryIndex],
          status: state.taskStatus.name.toString(),
        );
      } else {
        response = await TaskRepository().searchTasks(
          query: event.query,
          status: state.taskStatus.name,
        );
      }

      List<TaskModel> taskData = response['data'] as List<TaskModel>;

      print(taskData);
      emit(
        state.copyWith(
          error: false,
          loading: false,
          tasks: taskData,
          searchList: taskData,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: true, loading: false, message: e.toString()));
    }
  }

  void _deleleteTask(
    DeleteTaskEvent event,
    Emitter<HomeScreenState> emit,
  ) async {
    try {
      var response = await TaskRepository().deleteTask(sId: event.taskId);

      if (response['status'] == true) {
        emit(state.copyWith(error: false, loading: false));
      }
    } catch (e) {
      print("Error removing task: $e");
    }
  }

  void _removeFromTaskList(
    RemoveFromTaskList event,
    Emitter<HomeScreenState> emit,
  ) {
    try {
      List<TaskModel> updatedList = List.from(state.tasks);

      updatedList.removeWhere((task) => task.sId == event.taskId);

      emit(state.copyWith(tasks: updatedList));
    } catch (e) {
      print("Error removing task: $e");
    }
  }

  void _updateStatus(
    UpdateStatusEvent event,
    Emitter<HomeScreenState> emit,
  ) async {
    try {
      print("id in update ${event.taskId} ${event.taskStatus}");
      var response = await taskRepository.updateTaskStatus(
        sId: event.taskId,
        status: event.taskStatus,
      );
      if (response['status'] == true) {
        emit(state.copyWith(error: false, loading: false));
      }
    } catch (e) {
      emit(state.copyWith(error: true, loading: false));
    }
  }

  void _getAllTasks(GetAllTasks event, Emitter<HomeScreenState> emit) async {
    try {
      emit(state.copyWith(error: false, loading: true));

      print("${state.selectedCategoryIndex}");
      print(state.taskStatus.name);

      final response = await taskRepository.getTasks(
        category: state.selectedCategoryIndex == 0
            ? AppConstants.categoryList[0]
            : AppConstants.categoryList[state.selectedCategoryIndex],
        status: state.taskStatus.name.toString(),
      );

      print(response);

      List<TaskModel> taskData = response['data'] as List<TaskModel>;
      print("Task data length: ${taskData.length}");

      emit(
        state.copyWith(
          error: false,
          loading: false,
          tasks: taskData,
          filteredTasks: taskData,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: true, loading: false, message: e.toString()));
    }
  }

  void _getTasksByStatus(GetTaskByStatus event, Emitter<HomeScreenState> emit) {
    try {
      print(state.taskStatus);
      print(state.selectedCategoryIndex);
      emit(
        state.copyWith(
          error: false,
          selectedCategoryIndex: state.selectedCategoryIndex,
          taskStatus: state.taskStatus,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: true, message: e.toString()));
    }
  }

  void _categoryChangeEvent(
    CategoryChangeEvent event,
    Emitter<HomeScreenState> emit,
  ) {
    try {
      emit(
        state.copyWith(
          error: false,
          selectedCategoryIndex: event.categoryItemIndex,
        ),
      );
    } catch (e) {
      emit(state.copyWith(error: true));
    }
  }

  void _selectTaskStstus(
    SelectTasksWithItsStatusEvent event,
    Emitter<HomeScreenState> emit,
  ) {
    try {
      emit(state.copyWith(taskStatus: event.taskStatus));
    } catch (e) {
      emit(state.copyWith(error: true));
    }
  }
}
