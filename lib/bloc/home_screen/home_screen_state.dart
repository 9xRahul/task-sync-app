part of 'home_screen_bloc.dart';

class HomeScreenState extends Equatable {
  final int selectedCategoryIndex;
  final bool error;
  final TaskStatus taskStatus;
 

  HomeScreenState({
    this.selectedCategoryIndex = 0,
    this.error = false,
    this.taskStatus = TaskStatus.pending,

  });

  @override
  List<Object> get props => [selectedCategoryIndex, taskStatus,];

  HomeScreenState copyWith({
    int? selectedCategoryIndex,
    bool? error,
    TaskStatus? taskStatus,
    int? bottomNavIndex,
  }) {
    return HomeScreenState(
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
      error: error ?? this.error,
      taskStatus: taskStatus ?? this.taskStatus,

    );
  }
}
