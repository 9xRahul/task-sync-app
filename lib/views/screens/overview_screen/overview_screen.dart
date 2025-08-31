import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ needed for status bar color
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:tasksync/bloc/bottom_nav/bottom_nav_bar_bloc.dart';
import 'package:tasksync/bloc/summary/summary_bloc.dart';
import 'package:tasksync/config/app_config/color_config.dart';
import 'package:tasksync/config/app_config/image_config.dart';
import 'package:tasksync/config/app_config/size_config.dart';
import 'package:tasksync/views/helpers/empty_container.dart';
import 'package:tasksync/views/helpers/floatting_sction_button.dart';
import 'package:tasksync/views/helpers/text_widget.dart';
import 'package:tasksync/views/screens/overview_screen/widgets/pie_chart_container.dart';
import 'package:tasksync/views/screens/overview_screen/widgets/summary_widget.dart';

class OverViewScreen extends StatefulWidget {
  const OverViewScreen({super.key});

  @override
  State<OverViewScreen> createState() => _OverViewScreenState();
}

class _OverViewScreenState extends State<OverViewScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<SummaryBloc>().add(LoadTasks());

    _scrollController.addListener(() {
      final isScrolled = _scrollController.offset > 1;
      print(isScrolled);
      context.read<SummaryBloc>().add(ScrollEvent(isScrolled: isScrolled));
      _setStatusBarColor(isScrolled ? Colors.pink : Colors.white);
    });
  }

  void _setStatusBarColor(Color color) {
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // adjust icons color
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild overview");
    return BlocBuilder<SummaryBloc, SummaryState>(
      builder: (context, state) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.screenHeight,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConfig.splashBg),
                opacity: .1,
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
              controller: _scrollController, // ✅ attached
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
                            children: [
                              EmptyContainer.verticalEmptyContainer(
                                height: SizeConfig.screenHeight / 5,
                              ),
                              Lottie.asset(
                                'assets/animations/searching.json',
                                width: 300,
                                height: 300,
                                repeat: true,
                              ),
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            summaryWidget(state),
                            EmptyContainer.verticalEmptyContainer(height: 10),
                            !state.isLoading
                                ? pieChartContainer(state)
                                : Container(height: SizeConfig.screenHeight),
                          ],
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
