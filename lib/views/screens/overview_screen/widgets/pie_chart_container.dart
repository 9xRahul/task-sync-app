import 'package:flutter/material.dart';
import 'package:tasksync/bloc/summary/summary_bloc.dart';
import 'package:tasksync/config/app_config/size_config.dart';
import 'package:tasksync/views/screens/overview_screen/widgets/pi_chart.dart';

Padding pieChartContainer(SummaryState state) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      width: SizeConfig.screenWidth, // you can adjust width

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
      child: state.pendingList.isEmpty
          ? Image(image: AssetImage("assets/images/nopending.png"))
          : CategoryPieChart(categoryData: state.pendingList),
    ),
  );
}
