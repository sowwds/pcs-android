import 'package:flutter/material.dart';
import 'package:habit_tracker/core/constants/app_colors.dart';
import 'package:habit_tracker/features/habits/models/completion.dart';
import 'package:habit_tracker/features/habits/models/habit.dart';
import 'package:habit_tracker/features/habits/screens/habit_form_screen.dart';
import 'package:habit_tracker/features/habits/services/habits_service.dart';
import 'package:habit_tracker/features/habits/widgets/calendar_view.dart';

class HabitDetailsScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailsScreen({super.key, required this.habit});

  @override
  State<HabitDetailsScreen> createState() => _HabitDetailsScreenState();
}

class _HabitDetailsScreenState extends State<HabitDetailsScreen> {
  final _habitsService = HabitsService();
  late Future<List<Completion>> _completionsLoader;

  Set<DateTime> _completedDays = {};
  int _currentStreak = 0;
  int _longestStreak = 0;

  @override
  void initState() {
    super.initState();
    _completionsLoader = _loadCompletions();
  }

  Future<List<Completion>> _loadCompletions() async {
    final completions =
        await _habitsService.getCompletionsForHabit(widget.habit.id);
    _completedDays = completions
        .map((c) => DateTime(
            c.completionDate.year, c.completionDate.month, c.completionDate.day))
        .toSet();
    _calculateStreaks(_completedDays);
    if (mounted) {
      setState(() {});
    }
    return completions;
  }

  void _calculateStreaks(Set<DateTime> completedDays) {
    if (completedDays.isEmpty) {
      _currentStreak = 0;
      _longestStreak = 0;
      return;
    }

    final sortedDays = completedDays.toList()..sort((a, b) => a.compareTo(b));

    int longest = 0;

    DateTime today = DateTime.now();
    DateTime normalizedToday = DateTime(today.year, today.month, today.day);

    bool todayCompleted = sortedDays.any((day) => isSameDay(day, normalizedToday));

    bool checkFromYesterday = !todayCompleted;

    DateTime lastDay = checkFromYesterday
        ? DateTime(today.year, today.month, today.day - 1)
        : normalizedToday;

    int tempCurrentStreak = 0;
    for (int i = sortedDays.length - 1; i >= 0; i--) {
      if (isSameDay(sortedDays[i], lastDay)) {
        tempCurrentStreak++;
        lastDay = lastDay.subtract(const Duration(days: 1));
      } else if (sortedDays[i].isBefore(lastDay)) {
        break;
      }
    }
    _currentStreak = tempCurrentStreak;

    if (sortedDays.length == 1) {
      longest = 1;
    } else {
      int localLongest = 1;
      for (int i = 1; i < sortedDays.length; i++) {
        final diff = sortedDays[i].difference(sortedDays[i - 1]).inDays;
        if (diff == 1) {
          localLongest++;
        } else {
          if (localLongest > longest) longest = localLongest;
          localLongest = 1;
        }
      }
      if (localLongest > longest) longest = localLongest;
    }
    _longestStreak = longest;
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _navigateToEdit() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => HabitFormScreen(habit: widget.habit),
      ),
    );
    if (result == true && mounted) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _deleteHabit() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await _habitsService.deleteHabit(widget.habit.id);
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Failed to delete: ${e.toString()}')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.name),
        backgroundColor: widget.habit.color.withOpacity(0.2),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _navigateToEdit,
            tooltip: 'Edit Habit',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _deleteHabit,
            tooltip: 'Delete Habit',
          ),
        ],
      ),
      body: FutureBuilder<List<Completion>>(
        future: _completionsLoader,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.habit.description != null &&
                    widget.habit.description!.isNotEmpty) ...[
                  Text(
                    widget.habit.description!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                ],
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        child: ListTile(
                          leading: const Icon(
                              Icons.local_fire_department_rounded,
                              color: AppColors.peach),
                          title: Text('$_currentStreak Days'),
                          subtitle: const Text('Current Streak'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        child: ListTile(
                          leading:
                              const Icon(Icons.star_rounded, color: AppColors.yellow),
                          title: Text('$_longestStreak Days'),
                          subtitle: const Text('Longest Streak'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Progress Calendar',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CalendarView(
                      habit: widget.habit,
                      completedDays: _completedDays,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
