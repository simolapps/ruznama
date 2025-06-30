import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatefulWidget {
  final DateTime selectedDay;
  final Function(DateTime) onSelectDay;
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
  State<CalendarHeader> createState() => _CalendarHeaderState();
}

class _CalendarHeaderState extends State<CalendarHeader> {
  bool _expanded = false;

@override
Widget build(BuildContext context) {
  final topPadding = MediaQuery.of(context).padding.top + 8;

  return Padding(
    padding: EdgeInsets.only(top: topPadding),
    child: GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! > 5) {
          setState(() => _expanded = true);
        } else if (details.primaryDelta != null && details.primaryDelta! < -5) {
          setState(() => _expanded = false);
        }
      },
      child: Column(
        children: [

          // ─── Кроссфейд календаря ───
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState:
                _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: _buildWeekView(context),
            secondChild: _buildMonthView(context),
          ),
                    // ─── Индикатор тянучки ───
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildWeekView(BuildContext context) {
    final now = DateTime.now();
    final startOfWeek = widget.selectedDay.subtract(const Duration(days: 3));
    final days = List.generate(7, (i) => startOfWeek.add(Duration(days: i)));

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (ctx, i) {
          final date = days[i];
          final isToday = _isSameDay(now, date);
          final isSelected = _isSameDay(widget.selectedDay, date);
          final prayerProgress = (widget.completedPrayers[date] ?? 0) / 5;
          final taskTotal = widget.totalTasks[date] ?? 1;
          final taskProgress = (widget.completedTasks[date] ?? 0) / taskTotal;

          return GestureDetector(
            onTap: () => widget.onSelectDay(date),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 42,
                        height: 42,
                        child: CircularProgressIndicator(
                          value: prayerProgress.clamp(0, 1),
                          strokeWidth: 3,
                          valueColor: const AlwaysStoppedAnimation(Colors.green),
                          backgroundColor: Colors.green.withOpacity(0.2),
                        ),
                      ),
                      SizedBox(
                        width: 34,
                        height: 34,
                        child: CircularProgressIndicator(
                          value: taskProgress.clamp(0, 1),
                          strokeWidth: 3,
                          valueColor:
                              const AlwaysStoppedAnimation(Colors.lightBlueAccent),
                          backgroundColor: Colors.blue.withOpacity(0.2),
                        ),
                      ),
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? Colors.white.withOpacity(0.3)
                              : Colors.transparent,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isToday ? Colors.amber : Colors.white,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.E('ru').format(date),
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthView(BuildContext context) {
    final now = DateTime.now();
    final monthStart = DateTime(widget.selectedDay.year, widget.selectedDay.month, 1);
    final nextMonth = DateTime(widget.selectedDay.year, widget.selectedDay.month + 1, 1);
    final daysInMonth = nextMonth.difference(monthStart).inDays;
    final days = List.generate(daysInMonth, (i) => monthStart.add(Duration(days: i)));

    final firstWeekday = monthStart.weekday;
    final paddedDays = [...List<DateTime?>.filled(firstWeekday - 1, null), ...days];

    const weekDays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

    return Column(
      children: [
        Text(
          DateFormat.yMMMM('ru').format(widget.selectedDay),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: weekDays.map((d) => Text(
            d,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          )).toList(),
        ),
        const SizedBox(height: 4),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: paddedDays.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
          ),
          itemBuilder: (ctx, i) {
            final date = paddedDays[i];
            if (date == null) return const SizedBox.shrink();

            final isToday = _isSameDay(now, date);
            final isSelected = _isSameDay(widget.selectedDay, date);
            final prayerProgress = (widget.completedPrayers[date] ?? 0) / 5;
            final taskTotal = widget.totalTasks[date] ?? 1;
            final taskProgress = (widget.completedTasks[date] ?? 0) / taskTotal;

            return GestureDetector(
              onTap: () => widget.onSelectDay(date),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 34,
                    height: 34,
                    child: CircularProgressIndicator(
                      value: prayerProgress.clamp(0, 1),
                      strokeWidth: 2,
                      valueColor: const AlwaysStoppedAnimation(Colors.green),
                      backgroundColor: Colors.green.withOpacity(0.2),
                    ),
                  ),
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      value: taskProgress.clamp(0, 1),
                      strokeWidth: 2,
                      valueColor: const AlwaysStoppedAnimation(Colors.lightBlueAccent),
                      backgroundColor: Colors.blue.withOpacity(0.2),
                    ),
                  ),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? Colors.white.withOpacity(0.3) : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 11,
                        color: isToday ? Colors.amber : Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
