part of 'bottom_nav_bar_bloc.dart';

sealed class BottomNavBarEvent extends Equatable {
  const BottomNavBarEvent();

  @override
  List<Object> get props => [];
}

class BottomnavItemChangeEvent extends BottomNavBarEvent {
  final int index;

  BottomnavItemChangeEvent({required this.index});

  @override
  List<Object> get props => [index];
}
