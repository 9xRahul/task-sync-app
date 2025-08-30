import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tasksync/bloc/bottom_nav/bottom_nav_bar_bloc.dart';
import 'package:tasksync/bloc/summary/summary_bloc.dart';
import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/config/app_config/image_config.dart';
import 'package:tasksync/config/app_config/size_config.dart';
import 'package:tasksync/views/helpers/empty_container.dart';
import 'package:tasksync/views/helpers/text_widget.dart';
import 'package:tasksync/views/screens/overview_screen/widgets/percent_indicator.dart';
import 'package:tasksync/views/screens/overview_screen/widgets/pi_chart.dart';
import 'package:tasksync/views/screens/overview_screen/widgets/pie_chart_container.dart';
import 'package:tasksync/views/screens/overview_screen/widgets/summary_widget.dart';
import 'package:tasksync/views/screens/overview_screen/widgets/task_count_card.dart';

class OverViewScreen extends StatefulWidget {
  const OverViewScreen({super.key});

  @override
  State<OverViewScreen> createState() => _OverViewScreenState();
}

class _OverViewScreenState extends State<OverViewScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<SummaryBloc>().add(LoadTasks());
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild overview");
    return BlocBuilder<SummaryBloc, SummaryState>(
      builder: (context, state) {
        return Container(
          width: SizeConfig.screenWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageConfig.splashBg), // your asset path
              opacity: .1,
              fit: BoxFit.cover, // make it fill the screen
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: ColorConfig.appBArIconColor,
                          size: SizeConfig().appBarIconSize,
                        ),
                        onPressed: () {
                          context.read<BottomNavBarBloc>().add(
                            BottomnavItemChangeEvent(index: 0),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 0,
                        ),
                        child: textWidget(
                          text: "Summary",
                          color: ColorConfig.appBArIconColor,
                          fontSize: SizeConfig().appBarFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                state.isLoading
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            EmptyContainer.verticalEmptyContainer(height: 50),
                            Lottie.asset(
                              'assets/animations/searching.json',
                              width: 300,
                              height: 300,
                              repeat: true,
                            ),
                          ],
                        ),
                      )
                    : summaryWidget(state),
                EmptyContainer.verticalEmptyContainer(height: 10),
                !state.isLoading
                    ? pieChartContainer(state)
                    : Container(height: SizeConfig.screenHeight),
              ],
            ),
          ),
        );
      },
    );
  }
}
