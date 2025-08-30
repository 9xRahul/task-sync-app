import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:tasksync/views/helpers/empty_container.dart';
import 'package:tasksync/views/helpers/text_widget.dart';

class CategoryPieChart extends StatelessWidget {
  final Map<String, double> categoryData;

  const CategoryPieChart({super.key, required this.categoryData});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(
          text: "Pending task by category",
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
        EmptyContainer.verticalEmptyContainer(height: 20),
        PieChart(
          dataMap: categoryData,
          animationDuration: const Duration(milliseconds: 800),
          chartLegendSpacing: 20,
          chartRadius: MediaQuery.of(context).size.width / 3,
          colorList: const [
            Colors.blue,
            Colors.green,
            Colors.orange,
            Colors.purple,
            Colors.red,
            Colors.yellow,
            Colors.brown,
            Colors.pink,
          ],
          initialAngleInDegree: 0,
          chartType: ChartType.ring,
          ringStrokeWidth: 25,
          legendOptions: const LegendOptions(
            showLegendsInRow: true,
            showLegends: false,
            legendPosition: LegendPosition.bottom,
            legendTextStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          chartValuesOptions: const ChartValuesOptions(
            showChartValues: false,
            showChartValuesInPercentage: true,
            showChartValueBackground: false,
            decimalPlaces: 0,
          ),
        ),
        EmptyContainer.verticalEmptyContainer(height: 20),
        Align(
          alignment: Alignment.bottomLeft,
          child: Wrap(
            spacing: 10,
            children: categoryData.keys.map((key) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,

                    decoration: BoxDecoration(
                      color:
                          Colors.primaries[categoryData.keys.toList().indexOf(
                                key,
                              ) %
                              Colors.primaries.length],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    key,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
