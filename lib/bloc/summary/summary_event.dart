part of 'summary_bloc.dart';

sealed class SummaryEvent extends Equatable {
  const SummaryEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends SummaryEvent {}

class ScrollEvent extends SummaryEvent {
  final bool isScrolled;

  ScrollEvent({required this.isScrolled});

  @override
  List<Object> get props => [isScrolled];
}
