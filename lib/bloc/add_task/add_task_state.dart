part of 'add_task_bloc.dart';

class AddTaskState extends Equatable {
  final String category;
  final DateTime? date; // store full date
  final TimeOfDay? time; // store only time

  const AddTaskState({required this.category, this.date, this.time});

  @override
  List<Object?> get props => [category, date, time];

  factory AddTaskState.initial() {
    return const AddTaskState(category: "All", date: null, time: null);
  }

  AddTaskState copyWith({String? category, DateTime? date, TimeOfDay? time}) {
    return AddTaskState(
      category: category ?? this.category,
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }
}
