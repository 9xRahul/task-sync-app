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
