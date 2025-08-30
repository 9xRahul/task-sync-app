import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasksync/config/app_config/enums.dart';
import 'package:tasksync/models/task_model.dart';
import 'package:tasksync/repository/task_reposiytory.dart';

part 'summary_event.dart';
part 'summary_state.dart';

class SummaryBloc extends Bloc<SummaryEvent, SummaryState> {
  TaskRepository taskRepository;
  SummaryBloc({required this.taskRepository})
    : super(
        SummaryState(
          allTasks: [],
          isLoading: false,
          error: false,
          message: "",
          doneCount: 0,
          pendingCount: 0,
          pendingList: {},
          isScrolled: false,
        ),
      ) {
    on<LoadTasks>(_getAllTasks);
    on<ScrollEvent>(_scrollTheScreen);
  }

  void _scrollTheScreen(ScrollEvent event, Emitter<SummaryState> emit) {
    emit(state.copyWith(isScrolled: true));
  }

  void _getAllTasks(LoadTasks event, Emitter<SummaryState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      String message = "";
      final response = await taskRepository.getAllTasks();
      List<TaskModel> taskData = response['data'] as List<TaskModel>;
      print("Task data length: ${taskData.length}");
      int pendingCount = taskData
          .where((task) => task.status == TaskStatus.pending.name)
          .length;

      int doneCount = taskData
          .where((task) => task.status == TaskStatus.done.name)
          .length;

      int totalCount = pendingCount + doneCount;

      Map<String, double> pendingMap = {};

      for (var task in taskData) {
        if (task.status == TaskStatus.pending.name) {
          pendingMap[task.category!] = (pendingMap[task.category] ?? 0) + 1;
        }
      }
      print(pendingMap);

      double completedPercent = totalCount == 0
          ? 0
          : (doneCount / totalCount) * 100;
      if (completedPercent == 0) {
        message = "Start your tasks";
      } else if (completedPercent >= 0 && completedPercent <= 25) {
        message = "Go Ahead";
      } else if (completedPercent >= 25 && completedPercent <= 50) {
        message = "Keep Going";
      } else if (completedPercent >= 50 && completedPercent <= 75) {
        message = "Your are on the track";
      } else if (completedPercent >= 75 && completedPercent <= 101) {
        message = "Welldone";
      }
      emit(
        state.copyWith(
          isLoading: false,
          allTasks: taskData,
          error: false,
          message: message,
          doneCount: doneCount,
          pendingCount: pendingCount,
          pendingList: pendingMap,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(error: true, isLoading: false, message: e.toString()),
      );
    }
  }
}
