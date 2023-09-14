import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/domain/notifiers/abstract/records_notifier.dart';
import 'package:flutter_application_1/domain/notifiers/hypertension_notifier/hypertension_model.dart';
import 'package:flutter_application_1/domain/notifiers/hypertension_notifier/hypertension_notifier.dart';
import 'package:provider/provider.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue,
  ];
  bool showAvg = false;
  //late UserStatusNotifier _statusNotifier;
  late List<HypertensionModel> _dataRecords;
  // ignore: avoid_void_async

  late HypertensionNotifier? userStatusNotifier;

  @override
  Widget build(BuildContext context) {
    userStatusNotifier =
        context.watch<HypertensionNotifier>(); // не хочет работать
    switch (userStatusNotifier?.value) {
      case RecordsNotifierData(data: final data):
        _dataRecords = data;
      default:
        _dataRecords = [];
        break;
    }
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              showAvg ? avgData() : mainData(),
            ),
          ),
        ),
        SizedBox(
          width: 60,
          height: 34,
          child: TextButton(
            onPressed: () {
              setState(() {
                showAvg = !showAvg;
              });
            },
            child: Text(
              'avg',
              style: TextStyle(
                fontSize: 12,
                color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = linePattirnWidget(0);
        break;
      case 2:
        text = text = linePattirnWidget(1);
        break;
      case 4:
        text = linePattirnWidget(2);
        break;
      case 6:
        text = linePattirnWidget(3);
        break;
      case 8:
        text = linePattirnWidget(4);
        break;
      case 10:
        text = linePattirnWidget(5);
        break;
      case 12:
        text = linePattirnWidget(6);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget linePattirnWidget(int idx) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    return Text(
        _dataRecords.length >= idx + 1
            ? _dataRecords[idx].timeOfRecord.hour.toString()
            : '0',
        style: style);
    ;
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 2:
        text = '60';
        break;
      case 4:
        text = '80';
        break;
      case 6:
        text = '100';
        break;
      case 8:
        text = '120';
        break;
      case 10:
        text = '140';
        break;
      case 12:
        text = '160';
        break;
      case 14:
        text = '180';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  List<LineTooltipItem> lineTooltipItem(List<LineBarSpot> touchedSpots) {
    return touchedSpots.map((LineBarSpot touchedSpot) {
      final textStyle = TextStyle(
        color: touchedSpot.bar.gradient?.colors.first ??
            touchedSpot.bar.color ??
            Colors.blueGrey,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
      // todo: настроить отображение y
      print(touchedSpot);
      return LineTooltipItem((60 + 10 * (touchedSpot.y - 2)).toString(), textStyle);
    }).toList();
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: lineTooltipItem,
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.green,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.green,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: 14,
      lineBarsData: [
        lineChart(
          context,
          makeFLSpots(_dataRecords, true),
        ),
        lineChart(
          context,
          makeFLSpots(_dataRecords, false),
        ),
      ],
    );
  }

  LineChartBarData lineChart(BuildContext context, List<FlSpot> spots) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      gradient: LinearGradient(
        colors: gradientColors,
      ),
      barWidth: 5,
      isStrokeCapRound: true,
      dotData: const FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors:
              gradientColors.map((color) => color.withOpacity(0.3)).toList(),
        ),
      ),
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<FlSpot> makeFLSpots(List<HypertensionModel> records, bool isSys) {
    List<FlSpot> spots = [];
    double index = 2;
    for (int i = 0; i < 7; i++) {
      if (isSys) {
        spots.add(FlSpot(index - 2, 2.0 + (records[i].sys! - 60.0) / 10.0));
      } else {
        spots.add(FlSpot(index - 2, 2.0 + (records[i].dia! - 60.0) / 10.0));
      }
      index += 2;
    }
    return spots;
  }
}
