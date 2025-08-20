import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasksync/bloc/home_screen/home_screen_bloc.dart';
import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/config/app_config/constants.dart';
import 'package:tasksync/config/app_config/image_config.dart';

SizedBox categoryItemWidget({required BuildContext context}) {
  return SizedBox(
    height: 40,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: AppConstants.categoryList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              context.read<HomeScreenBloc>().add(
                CategoryChangeEvent(categoryItemIndex: index),
              );

              context.read<HomeScreenBloc>().add(
                GetAllTasks(
                
                ),
              );
            },
            child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
              builder: (context, state) {
                bool seletedItem = state.selectedCategoryIndex == index;
                return Container(
                  width: 60,

                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ImageConfig.splashBg), // your bg image
                      opacity: .1,
                      fit: BoxFit.cover,
                    ),
                    color: seletedItem
                        ? Colors.pink
                        : Colors.white, // 👈 background so shadow stays outside
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.pink),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3), // shadow color
                        blurRadius: 6, // soft shadow
                        spreadRadius: 0, // keep it from going inside
                        offset: Offset(2, 2), // position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: (Text(
                      AppConstants.categoryList[index],
                      style: TextStyle(
                        color: seletedItem
                            ? ColorConfig.selectedCategoryItemColor
                            : ColorConfig.unSelectedCategoryItemColor,
                      ),
                    )),
                  ),
                );
              },
            ),
          ),
        );
      },
    ),
  );
}
