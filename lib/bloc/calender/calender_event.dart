import 'package:equatable/equatable.dart';

abstract class CalendarEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Load all tasks (API call can be here in bloc)
class LoadCalendarTasks extends CalendarEvent {}

// Select a specific day
class SelectDayEvent extends CalendarEvent {
  final DateTime selectedDay;

  SelectDayEvent(this.selectedDay);

  @override
  List<Object?> get props => [selectedDay];
}
