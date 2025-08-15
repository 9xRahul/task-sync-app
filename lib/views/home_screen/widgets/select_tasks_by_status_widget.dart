import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasksync/bloc/home_screen/home_screen_bloc.dart';
import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/config/app_config/enums.dart';
import 'package:tasksync/config/app_config/size_config.dart';

Padding SelectTasksByStatusWidget({required BuildContext context}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      width: SizeConfig.screenWidth,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(10),
        color: Colors.pink.withOpacity(.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          taskStatusWidget(
            context: context,
            taskStatus: TaskStatus.pending,
            taskStatusText: "Pending",
          ),
          taskStatusWidget(
            context: context,
            taskStatus: TaskStatus.done,
            taskStatusText: "Done",
          ),
        ],
      ),
    ),
  );
}

Padding taskStatusWidget({
  required BuildContext context,
  required TaskStatus taskStatus,
  required String taskStatusText,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
    child: GestureDetector(
      onTap: () {
        context.read<HomeScreenBloc>().add(
          SelectTasksWithItsStatusEvent(taskStatus: taskStatus),
        );
      },
      child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
        builder: (context, state) {
          return Container(
            width: SizeConfig.screenWidth / 2.3,
            decoration: BoxDecoration(
              color: state.taskStatus == taskStatus
                  ? ColorConfig.unSelectedCategoryItemColor
                  : Colors.transparent,
              border: Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: Text(
                taskStatusText,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: state.taskStatus == taskStatus
                      ? ColorConfig.selectedCategoryItemColor
                      : ColorConfig.unSelectedCategoryItemColor,
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
