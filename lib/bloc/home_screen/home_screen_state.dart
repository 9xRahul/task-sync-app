part of 'home_screen_bloc.dart';

class HomeScreenState extends Equatable {
  final int selectedCategoryIndex;
  final bool error;
  final TaskStatus taskStatus;
  final List<TaskModel> tasks;
  final String message;
  final bool loading;
  final List<TaskModel> filteredTasks;
  final List<TaskModel> filteredByStstusList;

  HomeScreenState({
    this.selectedCategoryIndex = 0,
    this.error = false,
    this.taskStatus = TaskStatus.pending,
    this.tasks = const [],
    this.message = '',
    this.loading = false,
    this.filteredTasks = const [],
    this.filteredByStstusList = const [],
  });

  @override
  List<Object> get props => [
    selectedCategoryIndex,
    taskStatus,
    error,
    tasks,
    message,
    filteredTasks,
    loading,
    filteredByStstusList,
  ];

  HomeScreenState copyWith({
    int? selectedCategoryIndex,
    bool? error,
    TaskStatus? taskStatus,
    int? bottomNavIndex,
    List<TaskModel>? tasks,
    String? message,
    bool? loading,
    List<TaskModel>? filteredTasks,
    List<TaskModel>? filteredByStstusList,
  }) {
    return HomeScreenState(
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      error: error ?? this.error,
      taskStatus: taskStatus ?? this.taskStatus,
      tasks: tasks ?? this.tasks,
      message: message ?? this.message,
      loading: loading ?? this.loading,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      filteredByStstusList: filteredByStstusList ?? this.filteredByStstusList,
    );
  }
}
