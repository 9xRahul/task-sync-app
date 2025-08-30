part of 'summary_bloc.dart';

class SummaryState extends Equatable {
  final bool isLoading;
  final List<TaskModel> allTasks;
  final bool error;
  final String message;
  final int doneCount;
  final int pendingCount;
  final Map<String, double> pendingList;
  final bool isScrolled;

  SummaryState({
    required this.isLoading,
    required this.allTasks,
    required this.error,
    required this.message,
    required this.doneCount,
    required this.pendingCount,
    required this.pendingList,
    required this.isScrolled,
  });

  SummaryState copyWith({
    bool? isLoading,
    List<TaskModel>? allTasks,
    bool? error,
    String? message,
    int? pendingCount,
    int? doneCount,
    Map<String, double>? pendingList,
    bool? isScrolled,
  }) {
    return SummaryState(
      allTasks: allTasks ?? this.allTasks,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      message: message ?? this.message,
      doneCount: doneCount ?? this.doneCount,
      pendingCount: pendingCount ?? this.pendingCount,
      pendingList: pendingList ?? this.pendingList,
      isScrolled: isScrolled ?? this.isScrolled,
    );
  }

  @override
  List<Object> get props => [
    isLoading,
    allTasks,
    pendingCount,
    doneCount,
    message,
    error,
    pendingList,
    isScrolled,
  ];
}
