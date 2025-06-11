import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgressPieChart extends StatelessWidget {
  final double progress; // value between 0 and 1
  final Color color;

  const ProgressPieChart(
      {super.key, required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 30,
        sectionsSpace: 0,
        startDegreeOffset: -90,
        sections: [
          PieChartSectionData(
            value: progress * 100,
            color: color,
            radius: 40,
            title: '${(progress * 100).toStringAsFixed(0)}%',
            titleStyle: GoogleFonts.poppins(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            titlePositionPercentageOffset: 0.6,
          ),
          PieChartSectionData(
            value: (1 - progress) * 100,
            color: Colors.white.withOpacity(0.2),
            radius: 40,
            title: '',
          ),
        ],
      ),
    );
  }
}
