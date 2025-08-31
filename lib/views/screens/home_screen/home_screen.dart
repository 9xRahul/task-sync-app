import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tasksync/bloc/app/app_bloc.dart';
import 'package:tasksync/bloc/bottom_nav/bottom_nav_bar_bloc.dart';

import 'package:tasksync/config/shared_preferences/auth_storage.dart';

import 'package:tasksync/views/screens/calender_screen.dart/calender_screen.dart';
import 'package:tasksync/views/screens/taks_screen/taks_screen.dart';

import 'package:tasksync/views/screens/overview_screen/overview_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _pages = [
    const HomeScreenTasks(),
    CalendarScreen(),
    const OverViewScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
        builder: (context, state) {
          return _pages[state.bottomNavIndex];
        },
      ),
      bottomNavigationBar: BlocBuilder<BottomNavBarBloc, BottomNavBarState>(
        builder: (context, state) {
          return BottomNavigationBar(
            currentIndex: state.bottomNavIndex,
            selectedItemColor: Colors.pink,
            unselectedItemColor: Colors.black,
            onTap: (index) {
              context.read<BottomNavBarBloc>().add(
                BottomnavItemChangeEvent(index: index),
              );
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.task_alt_outlined),
                label: 'Tasks',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                label: 'Calender',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.show_chart_outlined),
                label: 'Overview',
              ),
            ],
          );
        },
      ),
    );
  }
}
