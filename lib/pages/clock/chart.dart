import 'package:dependencecoping/provider/countdown/countdown.dart';
import 'package:dependencecoping/storage/reset_log.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetsChart extends StatelessWidget {
  const ResetsChart({super.key});

  @override
  Widget build(final BuildContext context) {
    final gradientColors = [
      Theme.of(context).colorScheme.primaryContainer.withOpacity(.8),
      Theme.of(context).colorScheme.primary.withOpacity(.8),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: BlocBuilder<CountdownTimerCubit, CountdownTimer?>(builder: (final context, final ct) {
        final List<FlSpot> data = [];

        final List<CountdownReset> resets = ct?.sortedCopy() ?? [];

        if (resets.isEmpty) {
          return const SizedBox(width: double.infinity);
        }

        for (final element in resets) {
          if (element.resumeTime == null) {
            data.add(FlSpot.zero);
            continue;
          }

          final dur = element.resetTime.difference(element.resumeTime!);
          final since = element.resumeTime!.difference(DateTime.now());
          final value = FlSpot(since.inMinutes / 60 / 24, dur.inMinutes.abs() / 60);
          data.add(value);
        }

        final maxY = data.reduce((final curr, final next) => curr.y > next.y ? curr : next).y;
        final minX = data.reduce((final curr, final next) => curr.x < next.x ? curr : next).x;

        return Stack(
          children: <Widget>[
            LineChart(
              LineChartData(
                gridData: const FlGridData(
                  show: false,
                ),
                titlesData: const FlTitlesData(
                  rightTitles: AxisTitles(),
                  topTitles: AxisTitles(),
                  bottomTitles: AxisTitles(),
                  leftTitles: AxisTitles(),
                ),
                borderData: FlBorderData(show: false),
                minX: minX,
                maxX: 0,
                minY: 0,
                maxY: maxY * 6,
                lineBarsData: [
                  LineChartBarData(
                    spots: data,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: gradientColors,
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(
                      show: false,
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: gradientColors.map((final color) => color.withOpacity(0.9)).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
