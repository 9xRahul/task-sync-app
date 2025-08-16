import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'add_task_event.dart';
part 'add_task_state.dart';

class AddTaskBloc extends Bloc<AddTaskEvent, AddTaskState> {
  AddTaskBloc() : super(AddTaskState(category: "All", date: null, time: null)) {
    on<SelectCategoryEvent>(_selectCategory);
    on<SelectDateEvent>(_selectDate);
    on<SelectTimeEvent>(_selectTime);
    on<ResetAllEvent>(_reasetValues);
  }

  void _selectDate(SelectDateEvent event, Emitter<AddTaskState> emit) {
    emit(state.copyWith(date: event.date));
  }

  void _selectTime(SelectTimeEvent event, Emitter<AddTaskState> emit) {
    emit(state.copyWith(time: event.time));
  }

  void _selectCategory(SelectCategoryEvent event, Emitter<AddTaskState> emit) {
    emit(state.copyWith(category: event.category));
  }

  void _reasetValues(ResetAllEvent event, Emitter<AddTaskState> emit) {
    emit(AddTaskState.initial());
  }
}
