import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:tasksync/bloc/home_screen/home_screen_bloc.dart';
import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/config/app_config/image_config.dart';

import 'package:tasksync/views/helpers/empty_container.dart';
import 'package:tasksync/views/helpers/text_widget.dart' show textWidget;
import 'package:tasksync/views/helpers/toast_messenger.dart';

class TasksItems extends StatelessWidget {
  const TasksItems({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (context, state) {
        if (state.loading == true) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EmptyContainer.verticalEmptyContainer(height: 100),
              Lottie.asset(
                'assets/animations/searching.json',
                width: 300,
                height: 300,

                repeat: true, // repeat animation
              ),
            ],
          );
        }

        if (state.tasks.isNotEmpty && state.loading == false) {
          return Flexible(
            child: ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final item = state.tasks[index];

                final parsedDate = DateTime.parse(
                  item.dueDate!,
                ); // parse ISO string
                final formattedDate = DateFormat('dd-MM-yy').format(parsedDate);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      constraints: BoxConstraints(minHeight: 50),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: ColorConfig
                                .unSelectedCategoryItemColor, // Border color
                            width: 8.0, // Border width
                          ),
                        ),
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(ImageConfig.splashBg),
                          opacity: .01,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Checkbox(
                              value: item.status == "pending" ? false : true,
                              onChanged: (bool? value) {
                                context.read<HomeScreenBloc>().add(
                                  UpdateStatusEvent(
                                    taskStatus: value == true
                                        ? "done"
                                        : "pending",

                                    taskId: item.sId!,
                                  ),
                                );

                                if (item.status == "pending") {
                                  ToastHelper.show(
                                    "Marked as done",
                                    bgColor: Colors.green,
                                    textColor: Colors.white,
                                  );
                                } else {
                                  ToastHelper.show(
                                    "Moved to pending tasks",
                                    bgColor: Colors.green,
                                    textColor: Colors.white,
                                  );
                                }

                                context.read<HomeScreenBloc>().add(
                                  RemoveFromTaskList(taskId: item.sId!),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              // <-- Added Flexible here
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  textWidget(
                                    text: item.title!,
                                    color: ColorConfig.backTextColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  EmptyContainer.verticalEmptyContainer(
                                    height: 10,
                                  ),
                                  textWidget(
                                    text: item.description!,
                                    color:
                                        ColorConfig.unSelectedCategoryItemColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  EmptyContainer.verticalEmptyContainer(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.calendar_month, size: 15),
                                      EmptyContainer.horizontalEmptyContainer(
                                        width: 5,
                                      ),
                                      Flexible(
                                        // <-- Added Flexible here
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            color: ColorConfig
                                                .unSelectedCategoryItemColor,
                                          ),
                                          constraints: BoxConstraints(
                                            minWidth: 60,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: textWidget(
                                              text:
                                                  "$formattedDate ${item.time}",
                                              color: ColorConfig
                                                  .selectedCategoryItemColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                context.read<HomeScreenBloc>().add(
                                  DeleteTaskEvent(taskId: item.sId!),
                                );

                                context.read<HomeScreenBloc>().add(
                                  RemoveFromTaskList(taskId: item.sId!),
                                );
                              },
                              icon: Icon(
                                Icons.delete,
                                color: ColorConfig.unSelectedCategoryItemColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EmptyContainer.verticalEmptyContainer(height: 100),
                Image(
                  height: 300,
                  width: 300,
                  image: AssetImage('assets/images/notask.png'),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
