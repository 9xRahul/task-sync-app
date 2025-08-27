import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tasksync/bloc/add_task/add_task_bloc.dart';
import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/config/app_config/constants.dart';
import 'package:tasksync/config/app_config/image_config.dart';
import 'package:tasksync/config/app_config/size_config.dart';
import 'package:tasksync/models/task_model.dart';
import 'package:tasksync/views/helpers/text_widget.dart';
import 'package:tasksync/views/helpers/toast_messenger.dart';
import 'package:tasksync/views/screens/add_task_screen/widgets/category_date_time_picker_widget.dart';
import 'package:tasksync/views/screens/add_task_screen/widgets/text_field_for_task_description.dart';

class AddTaskScreen extends StatefulWidget {
  final bool isUpdate;
  final TaskModel? task;

  AddTaskScreen({super.key, this.isUpdate = false, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isUpdate == true) {
    } else {
      context.read<AddTaskBloc>().add(ResetAllEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<AddTaskBloc>().add(ResetAllEvent());
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            height: SizeConfig.screenHeight,
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
                TaskInputRow(isUpdate: widget.isUpdate),

                const SizedBox(height: 16),

                BlocBuilder<AddTaskBloc, AddTaskState>(
                  builder: (context, state) {
                    return CustomTextField(
                      controller: _titleController,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      hintText: "Title",
                      maxLines: 1,
                      isUpdate: widget.isUpdate,
                      maxLength: 10,
                      textToEdit: state.title!,
                      onChanged: (value) {
                        print(value);
                      },
                    );
                  },
                ),
                BlocBuilder<AddTaskBloc, AddTaskState>(
                  builder: (context, state) {
                    return CustomTextField(
                      isUpdate: widget.isUpdate,
                      controller: _descriptionController,
                      maxLines: 10,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      textToEdit: state.description!,
                      hintText: "Description",
                      maxLength: 1000,
                      onChanged: (value) {
                        print(value);
                      },
                    );
                  },
                ),

                // Description text box
              ],
            ),
          ),
        ),
        floatingActionButton: BlocListener<AddTaskBloc, AddTaskState>(
          listenWhen: (previous, current) {
            // Only listen when the state actually changes
            return previous.message != current.message ||
                previous.loading != current.loading ||
                previous.error != current.error ||
                previous.message != null;
          },
          listener: (context, state) {
            // Show toast when a new task is added successfully

            if (!state.loading &&
                state.error == false &&
                state.message!.isNotEmpty) {
              Navigator.pop(context, true);

              ToastHelper.show(
                state.message!,
                bgColor: Colors.green,
                textColor: Colors.white,
              );
            }

            // Show error toast if error occurs
            if (state.error == true && state.message!.isNotEmpty) {
              ToastHelper.show(
                state.message!,
                bgColor: Colors.red,
                textColor: Colors.white,
              );
            }
          },
          child: BlocBuilder<AddTaskBloc, AddTaskState>(
            builder: (context, state) {
              return FloatingActionButton(
                onPressed: () {
                  if (_descriptionController.text.isEmpty ||
                      _titleController.text.isEmpty ||
                      state.date == null ||
                      state.time == null) {
                    if (_descriptionController.text.isEmpty) {
                      ToastHelper.show(
                        bgColor: Colors.red,
                        textColor: Colors.white,
                        "Description cannot be empty",
                      );
                    } else if (_titleController.text.isEmpty) {
                      ToastHelper.show(
                        bgColor: Colors.red,
                        textColor: Colors.white,
                        "Task name cannot be empty",
                      );
                    } else if (state.date == null) {
                      ToastHelper.show(
                        bgColor: Colors.red,
                        textColor: Colors.white,
                        "Please select a date",
                      );
                    } else if (state.time == null) {
                      ToastHelper.show(
                        "Please select a time",
                        bgColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  } else {
                    if (widget.isUpdate) {
                      print(_descriptionController.text);
                      context.read<AddTaskBloc>().add(
                        UpdateTaskDetails(
                          taskDescription: _descriptionController.text,
                          taskName: _titleController.text,
                        ),
                      );
                    } else {
                      context.read<AddTaskBloc>().add(
                        GEtTaskDataToStoreEvent(
                          taskName: _titleController.text,
                          taskDescription: _descriptionController.text,
                        ),
                      );
                    }
                  }
                },
                backgroundColor:
                    Colors.transparent, // keep transparent so image is visible
                elevation: 0, // normal FAB elevation
                child: state.loading == true
                    ? Lottie.asset(
                        'assets/animations/loader.json',
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        repeat: true, // repeat animation
                      )
                    : Ink(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFE0218A),
                          // image: DecorationImage(
                          //   image: AssetImage(ImageConfig.splashBg),
                          //   fit: BoxFit.cover, // looks better than fill
                          // ),
                        ),
                        child: SizedBox(
                          width: 50, // standard FAB size
                          height: 50,
                          child: Icon(
                            Icons.check,
                            color: ColorConfig.appBArIconColor,
                          ),
                        ),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}
