import 'package:flutter/material.dart';
import 'package:tasksync/bloc/summary/summary_bloc.dart';
import 'package:tasksync/config/app_config/size_config.dart';
import 'package:tasksync/views/helpers/text_widget.dart';

Container taskCountCard({
  required SummaryState state,
  required message,
  required bool isDone,
}) {
  return Container(
    height: SizeConfig.scaleHeight(100),
    width: SizeConfig.screenWidth / 2.5,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDone ? Colors.green : Colors.red, // background color
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.3),
          spreadRadius: 2,
          blurRadius: 6,
          offset: const Offset(0, 3), // subtle shadow
        ),
      ], // rounded corners
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        textWidget(
          text: isDone ? "${state.doneCount}" : "${state.pendingCount}",
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 8), // space between texts
        textWidget(
          text: "$message",
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ],
    ),
  );
}
