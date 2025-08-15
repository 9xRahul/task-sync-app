part of 'bottom_nav_bar_bloc.dart';

class BottomNavBarState extends Equatable {
  final int bottomNavIndex;

  BottomNavBarState({required this.bottomNavIndex});

  @override
  List<Object> get props => [bottomNavIndex];
  BottomNavBarState copyWith({int? bottomNavIndex}) {
    return BottomNavBarState(
      bottomNavIndex: bottomNavIndex ?? this.bottomNavIndex,
    );
  }
}
