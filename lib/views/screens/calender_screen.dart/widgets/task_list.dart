import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasksync/bloc/add_task/add_task_bloc.dart';
import 'package:tasksync/bloc/home_screen/home_screen_bloc.dart';
import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/config/app_config/enums.dart';
import 'package:tasksync/models/task_model.dart';
import 'package:tasksync/views/helpers/text_widget.dart';
import 'package:tasksync/views/screens/add_task_screen/add_task_screen.dart';

ListView taskList(List<TaskModel> filteredTasks, BuildContext context) {
  return ListView(
    children: filteredTasks.map((task) {
      final dueDate = task.dueDate != null
          ? DateTime.tryParse(task.dueDate!)
          : null;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.pink.withOpacity(.03),
            border: Border(
              left: BorderSide(
                color: task.status == TaskStatus.done.name
                    ? ColorConfig.success
                    : ColorConfig.error,
                width: 8.0,
              ),
            ),

            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: ListTile(
            leading: Icon(
              task.status == TaskStatus.done.name
                  ? Icons.check_circle
                  : Icons.pending,
              color: task.status == TaskStatus.done.name
                  ? Colors.green
                  : Colors.red,
            ),
            title: textWidget(
              text: task.title ?? "",
              color: ColorConfig.backTextColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.description != null && task.description!.isNotEmpty)
                  textWidget(
                    text: task.description!,
                    color: ColorConfig.backTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                if (dueDate != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: task.status == TaskStatus.done.name
                            ? ColorConfig.success
                            : ColorConfig.error,
                      ),
                      constraints: const BoxConstraints(minWidth: 60),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        child: textWidget(
                          text:
                              "${dueDate.day}-${dueDate.month}-${dueDate.year} ${task.time ?? ""}",
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            trailing: textWidget(
              text: task.status ?? "",
              color: ColorConfig.backTextColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            onTap: () {
              context.read<AddTaskBloc>().add(GetTaskDetailsToEdit(task: task));
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AddTaskScreen(isUpdate: true, task: task),
                ),
              ).then((_) {
                context.read<HomeScreenBloc>().add(GetAllTasks());
              });
            },
          ),
        ),
      );
    }).toList(),
  );
}
