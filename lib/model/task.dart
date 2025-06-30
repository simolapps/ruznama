import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime selectedDay;
  final ValueChanged<DateTime> onSelectDay;
  final Map<DateTime, int> completedPrayers;
  final Map<DateTime, int> completedTasks;
  final Map<DateTime, int> totalTasks;

  const CalendarHeader({
    super.key,
    required this.selectedDay,
    required this.onSelectDay,
    required this.completedPrayers,
    required this.completedTasks,
    required this.totalTasks,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white),
            onPressed: () =>
                onSelectDay(selectedDay.subtract(const Duration(days: 1))),
          ),
          Expanded(
            child: Center(
              child: Text(
                DateFormat.yMMMd().format(selectedDay),
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Colors.white),
            onPressed: () =>
                onSelectDay(selectedDay.add(const Duration(days: 1))),
          ),
        ],
      ),
    );
  }
}