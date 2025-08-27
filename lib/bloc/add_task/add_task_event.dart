part of 'add_task_bloc.dart';

sealed class AddTaskEvent extends Equatable {
  const AddTaskEvent();

  @override
  List<Object> get props => [];
}

class SelectCategoryEvent extends AddTaskEvent {
  final String category;
  final int categoryIndex;

  SelectCategoryEvent({required this.category, required this.categoryIndex});

  @override
  List<Object> get props => [category, categoryIndex];
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

class GEtTaskDataToStoreEvent extends AddTaskEvent {
  final String taskName;
  final String taskDescription;

  const GEtTaskDataToStoreEvent({
    required this.taskName,
    required this.taskDescription,
  });
  @override
  List<Object> get props => [taskName, taskDescription];
}

class CatchErrorEvent extends AddTaskEvent {
  const CatchErrorEvent();
  @override
  List<Object> get props => [];
}

class GetTaskDetailsById extends AddTaskEvent {
  final String taskId;

  GetTaskDetailsById({required this.taskId});
  @override
  List<Object> get props => [taskId];
}

class GetTaskDetailsToEdit extends AddTaskEvent {
  final TaskModel task;

  GetTaskDetailsToEdit({required this.task});
  @override
  List<Object> get props => [task];
}

class UpdateTaskDetails extends AddTaskEvent {
  final String taskName;
  final String taskDescription;

  const UpdateTaskDetails({
    required this.taskName,
    required this.taskDescription,
  });
  @override
  List<Object> get props => [taskName, taskDescription];
}
