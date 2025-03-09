import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatmap extends StatelessWidget {
  final DateTime? startDate;
  final Map<DateTime,int> datasets;
  const MyHeatmap({super.key,
  required this.startDate,
  required this.datasets});

  @override
  Widget build(BuildContext context) {
    return HeatMap(
      startDate: startDate,
      endDate: DateTime.now().add(Duration(days:30)),
      datasets: datasets,
      colorMode: ColorMode.color,
      defaultColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.inversePrimary,
      showColorTip: false,
      showText: true,
      scrollable: true,
      size: 40,
      
  colorsets: {
  1: Color(0xFFC8E6C9), // Very Light Green
  2: Color(0xFFA5D6A7), // Lighter Green
  3: Color(0xFF81C784), // Light Green
  4: Color(0xFF66BB6A), // Medium Light Green
  5: Color(0xFF4CAF50), // Primary Green
  6: Color(0xFF43A047), // Slightly Darker Green
  7: Color(0xFF388E3C), // Dark Green
  8: Color(0xFF2E7D32), // Deeper Green
  9: Color(0xFF1B5E20), // Very Dark Green
 10: Color(0xFF0D3B15), // Almost Black Green
},
);
}
}