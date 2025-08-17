import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasksync/bloc/add_task/add_task_bloc.dart';
import 'package:tasksync/config/app_config/constants.dart';
import 'package:tasksync/config/app_config/image_config.dart';
import 'package:tasksync/views/helpers/toast_messenger.dart';

class TaskInputRow extends StatelessWidget {
  const TaskInputRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // left + right split
        children: [
          /// LEFT SIDE → Wallet + Dropdown + Extra Item
          Row(
            children: [
              const Icon(Icons.task_sharp),

              const SizedBox(width: 8),

              BlocBuilder<AddTaskBloc, AddTaskState>(
                builder: (context, state) {
                  return DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: const Text(
                        "Category",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      items: AppConstants.categoryList
                          .map(
                            (String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          )
                          .toList(),
                      value: state.category.isEmpty ? null : state.category,
                      // controlled by Bloc
                      onChanged: (String? value) {
                        if (value != null) {
                          context.read<AddTaskBloc>().add(
                            SelectCategoryEvent(category: value),
                          );
                        }
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 30,
                        width: 120,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            opacity: .01,
                            image: AssetImage(ImageConfig.splashBg),
                          ),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.transparent),
                        ),
                        elevation: 0,
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(Icons.arrow_drop_down, size: 30),
                        iconSize: 14,
                        iconEnabledColor: Colors.black,
                        iconDisabledColor: Colors.black,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 200,
                        width: 100,
                        padding: const EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            opacity: .01,
                            image: AssetImage(ImageConfig.splashBg),
                          ),
                          border: Border.all(color: Colors.black26),
                        ),
                        offset: const Offset(10, 0),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(40),
                          thickness: MaterialStateProperty.all<double>(6),
                          thumbVisibility: MaterialStateProperty.all<bool>(
                            true,
                          ),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 14),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          /// RIGHT SIDE → Calendar + Time
          Row(
            children: [
              BlocBuilder<AddTaskBloc, AddTaskState>(
                builder: (context, state) {
                  return IconButton(
                    icon: const Icon(Icons.calendar_month_rounded),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: state.date ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );

                      if (pickedDate != null) {
                        context.read<AddTaskBloc>().add(
                          SelectDateEvent(date: pickedDate),
                        );
                      }
                      if (state.error!) {
                        ToastHelper.show(
                          "Invalid Date",
                          bgColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    },
                  );
                },
              ),
              BlocBuilder<AddTaskBloc, AddTaskState>(
                builder: (context, state) {
                  return IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      DateTime? ensuredDate = state.date;

                      if (ensuredDate == null) {
                        ensuredDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );

                        if (ensuredDate != null) {
                          context.read<AddTaskBloc>().add(
                            SelectDateEvent(date: ensuredDate),
                          );
                        } else {
                          return;
                        }
                      }

                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: state.time ?? TimeOfDay.now(),
                      );

                      if (pickedTime != null) {
                        context.read<AddTaskBloc>().add(
                          SelectTimeEvent(time: pickedTime),
                        );

                        if (state.error!) {
                          ToastHelper.show(
                            "Invalid time",
                            bgColor: Colors.red,
                            textColor: Colors.white,
                          );
                        }
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
