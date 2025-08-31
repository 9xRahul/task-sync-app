import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tasksync/bloc/home_screen/home_screen_bloc.dart';
import 'package:tasksync/views/screens/add_task_screen/add_task_screen.dart';

FloatingActionButton FloattingSctionButton(BuildContext context) {
  return FloatingActionButton(
    backgroundColor: Colors.transparent, // Make FAB background transparent
    elevation: 0, // Remove shadow
    highlightElevation: 0,
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AddTaskScreen()),
      ).then((_) {
        context.read<HomeScreenBloc>().add(GetAllTasks());
      });
    },

    child: Lottie.asset(
      'assets/animations/add.json',
      width: 60,
      height: 60,
      fit: BoxFit.cover,
      repeat: true, // repeat animation
    ),
  );
}
