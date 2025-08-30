import 'package:flutter/material.dart';
import 'package:tasksync/bloc/summary/summary_bloc.dart';
import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/config/app_config/size_config.dart';
import 'package:tasksync/views/helpers/empty_container.dart';
import 'package:tasksync/views/helpers/text_widget.dart';
import 'package:tasksync/views/screens/overview_screen/widgets/percent_indicator.dart';
import 'package:tasksync/views/screens/overview_screen/widgets/task_count_card.dart';

Column summaryWidget(SummaryState state) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          width: SizeConfig.screenWidth, // you can adjust width
          height: SizeConfig.scaleHeight(160), // adjust height
          decoration: BoxDecoration(
            color: Colors.white, // background color
            borderRadius: BorderRadius.circular(20), // fully circular
            border: Border.all(
              color: Colors.transparent, // border color
              width: 2, // border thickness
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.3),
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 3), // subtle shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  textWidget(
                    text: "Task Progress",
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: ColorConfig.unSelectedCategoryItemColor,
                      ),
                      EmptyContainer.horizontalEmptyContainer(width: 15),

                      textWidget(
                        text:
                            "${state.doneCount}/${state.pendingCount + state.doneCount}",
                        color: ColorConfig.unSelectedCategoryItemColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      EmptyContainer.horizontalEmptyContainer(width: 15),
                      textWidget(
                        text: "Task",
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                  textWidget(
                    text: state.message,
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              TaskCompletionIndicator(
                totalTasks: state.allTasks.length,
                completedTasks: state.doneCount,
              ),
            ],
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          taskCountCard(message: "Completed Tasks", state: state, isDone: true),
          taskCountCard(message: "Pending Tasks", state: state, isDone: false),
        ],
      ),
    ],
  );
}
