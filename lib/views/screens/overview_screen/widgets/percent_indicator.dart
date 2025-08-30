import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/views/helpers/text_widget.dart';

class TaskCompletionIndicator extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;

  const TaskCompletionIndicator({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
  });

  @override
  Widget build(BuildContext context) {
    double percent = totalTasks == 0 ? 0 : completedTasks / totalTasks;

    return CircularPercentIndicator(
      radius: 50.0, // size of the circle
      lineWidth: 10.0, // thickness of the stroke
      animation: true,
      percent: percent.clamp(0.0, 1.0), // between 0 and 1
      center: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textWidget(
            text: "${(percent * 100).toStringAsFixed(1)}%",
            color: ColorConfig.unSelectedCategoryItemColor,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          textWidget(
            text: "Done",
            color: ColorConfig.unSelectedCategoryItemColor,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.green,
      backgroundColor: Colors.grey.shade300,
    );
  }
}
