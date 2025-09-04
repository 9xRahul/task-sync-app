part of 'home_screen_bloc.dart';

sealed class HomeScreenEvent extends Equatable {
  const HomeScreenEvent();

  @override
  List<Object> get props => [];
}

class CategoryChangeEvent extends HomeScreenEvent {
  final int categoryItemIndex;

  CategoryChangeEvent({required this.categoryItemIndex});

  @override
  List<Object> get props => [categoryItemIndex];
}

class SelectTasksWithItsStatusEvent extends HomeScreenEvent {
  final TaskStatus taskStatus;

  SelectTasksWithItsStatusEvent({required this.taskStatus});
  @override
  List<Object> get props => [taskStatus];
}

class ChangeBottomNavItemEvent extends HomeScreenEvent {
  final int bottomNavItem;

  ChangeBottomNavItemEvent({required this.bottomNavItem});

  @override
  List<Object> get props => [bottomNavItem];
}

class GetTaskByStatus extends HomeScreenEvent {}

class GetAllTasks extends HomeScreenEvent {}

class UpdateStatusEvent extends HomeScreenEvent {
  final String taskStatus;
  final String taskId;

  UpdateStatusEvent({required this.taskStatus, required this.taskId});

  @override
  List<Object> get props => [taskStatus, taskId];
}

class RemoveFromTaskList extends HomeScreenEvent {
  final String taskId;

  RemoveFromTaskList({required this.taskId});

  @override
  List<Object> get props => [taskId];
}

class DeleteTaskEvent extends HomeScreenEvent {
  final String taskId;

  DeleteTaskEvent({required this.taskId});
  @override
  List<Object> get props => [taskId];
}

class SearchEvent extends HomeScreenEvent {
  final String query;

  SearchEvent({required this.query});
  @override
  List<Object> get props => [query];
}

class SetSearchStstusEvent extends HomeScreenEvent {
  final bool isSearch;

  SetSearchStstusEvent({required this.isSearch});
  @override
  List<Object> get props => [isSearch];
}

class SelectSortEvent extends HomeScreenEvent {
  final int sortIndex;

  SelectSortEvent({required this.sortIndex});
  @override
  List<Object> get props => [sortIndex];
}

class DoSortEvent extends HomeScreenEvent {}

class LogoutEvent extends HomeScreenEvent {}
