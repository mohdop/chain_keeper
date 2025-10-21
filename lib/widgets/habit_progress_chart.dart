import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/habit.dart';

class HabitProgressChart extends StatelessWidget {
  final Habit habit;

  const HabitProgressChart({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Progression',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        
        // Graphique en ligne
        Container(
          height: 250,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A3E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dernières 4 semaines',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _buildLineChart(),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Graphique en barres pour la semaine actuelle
        Container(
          height: 220,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A3E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cette semaine',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[400],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _buildBarChart(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLineChart() {
    final weeklyData = _getWeeklyCompletionData();
    
    if (weeklyData.isEmpty) {
      return Center(
        child: Text(
          'Pas encore de données',
          style: TextStyle(color: Colors.grey[600]),
        ),
      );
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[800]!,
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  '${value.toInt()}',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final weekLabels = ['S-3', 'S-2', 'S-1', 'S0'];
                if (value.toInt() >= 0 && value.toInt() < weekLabels.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      weekLabels[value.toInt()],
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 3,
        minY: 0,
        maxY: 7,
        lineBarsData: [
          LineChartBarData(
            spots: weeklyData,
            isCurved: true,
            color: const Color(0xFF6C63FF),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: Colors.white,
                  strokeWidth: 2,
                  strokeColor: const Color(0xFF6C63FF),
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF6C63FF).withOpacity(0.3),
                  const Color(0xFF6C63FF).withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final dailyData = _getDailyCompletionData();
    
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 1,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                if (value.toInt() >= 0 && value.toInt() < days.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      days[value.toInt()],
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: dailyData,
      ),
    );
  }

  List<FlSpot> _getWeeklyCompletionData() {
    final now = DateTime.now();
    final spots = <FlSpot>[];

    for (int weekOffset = 3; weekOffset >= 0; weekOffset--) {
      final weekStart = now.subtract(Duration(days: now.weekday - 1 + (weekOffset * 7)));
      final weekEnd = weekStart.add(const Duration(days: 6));
      
      int completionsInWeek = 0;
      
      for (final completion in habit.completionHistory) {
        if (completion.isAfter(weekStart.subtract(const Duration(days: 1))) &&
            completion.isBefore(weekEnd.add(const Duration(days: 1)))) {
          completionsInWeek++;
        }
      }
      
      spots.add(FlSpot((3 - weekOffset).toDouble(), completionsInWeek.toDouble()));
    }

    return spots;
  }

  List<BarChartGroupData> _getDailyCompletionData() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final barGroups = <BarChartGroupData>[];

    for (int i = 0; i < 7; i++) {
      final day = startOfWeek.add(Duration(days: i));
      final isCompleted = habit.completionHistory.any((completion) =>
        completion.year == day.year &&
        completion.month == day.month &&
        completion.day == day.day
      );

      final isToday = day.year == now.year &&
                     day.month == now.month &&
                     day.day == now.day;

      Color barColor;
      if (isCompleted) {
        barColor = const Color(0xFF00D9A5);
      } else if (isToday) {
        barColor = const Color(0xFF6C63FF);
      } else if (day.isAfter(now)) {
        barColor = Colors.grey[800]!;
      } else {
        barColor = const Color(0xFFFF4757);
      }

      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: isCompleted ? 1 : 0.3,
              color: barColor,
              width: 30,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(6),
              ),
            ),
          ],
        ),
      );
    }

    return barGroups;
  }
}