import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:habit_tracker/core/constants/app_colors.dart';
import 'package:habit_tracker/features/habits/models/habit.dart';

class CalendarView extends StatelessWidget {
  final Habit habit;
  final Set<DateTime> completedDays;

  const CalendarView({
    super.key,
    required this.habit,
    required this.completedDays,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: DateTime.now(),
      firstDay: habit.createdAt,
      lastDay: DateTime.now().add(const Duration(days: 365)),
      calendarFormat: CalendarFormat.month,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: const TextStyle(color: AppColors.text, fontSize: 18),
        leftChevronIcon: const Icon(Icons.chevron_left, color: AppColors.lavender),
        rightChevronIcon: const Icon(Icons.chevron_right, color: AppColors.lavender),
      ),
      calendarStyle: CalendarStyle(
        defaultTextStyle: const TextStyle(color: AppColors.text),
        weekendTextStyle: const TextStyle(color: AppColors.subtext1),
        outsideTextStyle: const TextStyle(color: AppColors.surface2),
        todayDecoration: BoxDecoration(
          color: AppColors.surface1,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: AppColors.lavender,
          shape: BoxShape.circle,
        ),
      ),
      eventLoader: (day) {
        // Normalize the day to ignore time part.
        final normalizedDay = DateTime(day.year, day.month, day.day);
        if (completedDays.contains(normalizedDay)) {
          return [habit]; // Return a list with an item to show the event marker
        }
        return [];
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            return Positioned(
              right: 1,
              bottom: 1,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: habit.color,
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
