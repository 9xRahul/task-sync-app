part of 'summary_bloc.dart';

sealed class SummaryEvent extends Equatable {
  const SummaryEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends SummaryEvent {}
