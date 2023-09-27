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
      Theme.of(context).colorScheme.primary.withOpacity(.5),
      Theme.of(context).colorScheme.tertiary.withOpacity(.5),
    ];

    final List<FlSpot> spots2 = [];

    final tc = BlocProvider.of<CountdownTimerCubit>(context);
    final List<CountdownReset> resets = tc.state?.resets ?? [];
    if (resets.isNotEmpty) {
      DateTime lastResume = resets[0].resetTime;
      for (final element in resets) {
        if (element.resumeTime == null) continue;
        final dur = element.resetTime.difference(lastResume);
        lastResume = element.resumeTime!;
        final since = element.resetTime.difference(DateTime.now());
        final value = FlSpot(since.inDays / 1, dur.inMinutes.abs() / 60);
        spots2.add(value);
      }
    }

    final maxY = spots2.reduce((final curr, final next) => curr.y > next.y ? curr : next).y;
    final minX = spots2.reduce((final curr, final next) => curr.x < next.x ? curr : next).x;

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
            maxY: maxY * 2,
            lineBarsData: [
              LineChartBarData(
                spots: spots2,
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
                    colors: gradientColors.map((final color) => color.withOpacity(0.2)).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
