import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasksync/bloc/add_task/add_task_bloc.dart';
import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/config/app_config/constants.dart';
import 'package:tasksync/config/app_config/image_config.dart';
import 'package:tasksync/views/helpers/text_widget.dart';
import 'package:tasksync/views/screens/add_task_screen/widgets/category_date_time_picker_widget.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<AddTaskBloc>().add(ResetAllEvent());
        return true;
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConfig.splashBg),
              fit: BoxFit.cover,
              opacity: .1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                ),
                height: kToolbarHeight + MediaQuery.of(context).padding.top,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImageConfig.splashBg),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: ColorConfig.appBArIconColor,
                      ),
                      onPressed: () {
                        context.read<AddTaskBloc>().add(ResetAllEvent());
                        Navigator.of(context).pop();
                      },
                    ),
                    textWidget(
                      color: ColorConfig.appBArIconColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      text: 'Add Task',
                    ),
                  ],
                ),
              ),

              // Row with dropdown + calendar + clock
              TaskInputRow(),

              BlocBuilder<AddTaskBloc, AddTaskState>(
                builder: (context, state) {
                  if (state.date != null && state.time != null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "${state.category}  Date: ${state.date!.day}-${state.date!.month}-${state.date!.year}"
                        " | Time: ${state.time!.format(context)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  } else if (state.date != null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "Date: ${state.date!.day}-${state.date!.month}-${state.date!.year}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  } else {
                    return const Text("Date and time not selected");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
