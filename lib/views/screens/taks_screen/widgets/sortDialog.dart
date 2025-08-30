import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasksync/bloc/home_screen/home_screen_bloc.dart';
import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/views/helpers/text_widget.dart';

Future<dynamic> sortDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        // use Dialog for full control
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              opacity: .01,
              image: AssetImage('assets/images/authbg.jpg'), // ✅ full bg
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  textWidget(
                    text: "Sort",
                    color: ColorConfig.unSelectedCategoryItemColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 10),

                  // Radio buttons
                  RadioListTile<int>(
                    title: textWidget(
                      text: "Alphabetically (A-Z)",
                      color: ColorConfig.unSelectedCategoryItemColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    value: 1,
                    groupValue: state.sortIndex,
                    onChanged: (val) {
                      context.read<HomeScreenBloc>().add(
                        SelectSortEvent(sortIndex: val!),
                      );
                    },
                  ),
                  RadioListTile<int>(
                    title: textWidget(
                      text: "Alphabetically (Z-A)",
                      color: ColorConfig.unSelectedCategoryItemColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    value: 2,
                    groupValue: state.sortIndex,
                    onChanged: (val) {
                      context.read<HomeScreenBloc>().add(
                        SelectSortEvent(sortIndex: val!),
                      );
                    },
                  ),
                  RadioListTile<int>(
                    title: textWidget(
                      text: "Due Date (Low-High)",
                      color: ColorConfig.unSelectedCategoryItemColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    value: 3,
                    groupValue: state.sortIndex,
                    onChanged: (val) {
                      context.read<HomeScreenBloc>().add(
                        SelectSortEvent(sortIndex: val!),
                      );
                    },
                  ),
                  RadioListTile<int>(
                    title: textWidget(
                      text: "Due Date (High-Low)",
                      color: ColorConfig.unSelectedCategoryItemColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    value: 4,
                    groupValue: state.sortIndex,
                    onChanged: (val) {
                      context.read<HomeScreenBloc>().add(
                        SelectSortEvent(sortIndex: val!),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: textWidget(
                          text: "Cancel",
                          color: ColorConfig.unSelectedCategoryItemColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          context.read<HomeScreenBloc>().add(DoSortEvent());
                        },
                        child: textWidget(
                          text: "Ok",
                          color: ColorConfig.unSelectedCategoryItemColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
}
