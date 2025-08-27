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
  final List<TaskModel> searchList;
  final bool isSearching;

  HomeScreenState({
    this.selectedCategoryIndex = 0,
    this.error = false,
    this.taskStatus = TaskStatus.pending,
    this.tasks = const [],
    this.message = '',
    this.loading = false,
    this.filteredTasks = const [],
    this.filteredByStstusList = const [],
    this.searchList = const [],
    this.isSearching = false,
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
    searchList,
    isSearching,
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
    List<TaskModel>? searchList,
    bool? isSearching,
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
      searchList: searchList ?? this.searchList,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}
