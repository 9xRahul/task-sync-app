part of 'add_task_bloc.dart';

sealed class AddTaskEvent extends Equatable {
  const AddTaskEvent();

  @override
  List<Object> get props => [];
}

class SelectCategoryEvent extends AddTaskEvent {
  final String category;

  SelectCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}

class SelectDateEvent extends AddTaskEvent {
  final DateTime date;

  SelectDateEvent({required this.date});
  @override
  List<Object> get props => [date];
}

class SelectTimeEvent extends AddTaskEvent {
  final TimeOfDay time;

  SelectTimeEvent({required this.time});
  @override
  List<Object> get props => [time];
}

class GetTaskDataEvent extends AddTaskEvent {
  @override
  List<Object> get props => [];
}

class ResetAllEvent extends AddTaskEvent {
  @override
  List<Object> get props => [];
}
