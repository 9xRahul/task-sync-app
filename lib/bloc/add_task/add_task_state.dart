part of 'add_task_bloc.dart';

class AddTaskState extends Equatable {
  final String category;
  final DateTime? date; // store full date
  final TimeOfDay? time; // store only time
  final String? description;
  final String? title;
  final bool? error;
  final String? message;
  final bool loading;

  const AddTaskState({
    required this.category,
    this.date,
    this.time,
    required this.description,
    required this.title,
    this.error = false,
    this.message = "",
    this.loading = false,
  });

  @override
  List<Object?> get props => [category,
  date,
  time,
  description,
  title,
  error,
  message,
  loading, 
  ];

  factory AddTaskState.initial() {
    return const AddTaskState(
      category: "All",
      date: null,
      time: null,
      description: "",
      title: "",
      error: false,
      message: "",
      loading: false,
    );
  }

  AddTaskState copyWith({
    String? category,
    DateTime? date,
    TimeOfDay? time,
    String? description,
    String? title,
    bool? error,
    String? message,
    bool? loading,
  }) {
    return AddTaskState(
      category: category ?? this.category,
      date: date ?? this.date,
      time: time ?? this.time,
      description: description ?? this.description,
      title: title ?? this.title,
      error: error ?? this.error,
      message: message ?? this.message,
      loading: loading ?? this.loading,
    );
  }
}
