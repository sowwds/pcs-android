import 'package:flutter/material.dart';
import 'package:habit_tracker/core/constants/app_colors.dart';
import 'package:habit_tracker/features/habits/models/habit.dart';

class HabitListItem extends StatelessWidget {
  final Habit habit;
  final bool isCompleted;
  final int? progress;
  final ValueChanged<bool>? onCompleted;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  const HabitListItem({
    super.key,
    required this.habit,
    this.isCompleted = false,
    this.progress,
    this.onCompleted,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    bool isCounter = habit.habitType == HabitType.counter;
    bool isGoalReached = isCounter && (progress ?? 0) >= (habit.counterGoal ?? 0);

    Widget trailingWidget;
    if (isCounter) {
      trailingWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: onDecrement,
            color: AppColors.subtext0,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: onIncrement,
            color: AppColors.lavender,
          ),
        ],
      );
    } else {
      trailingWidget = Checkbox(
        value: isCompleted,
        onChanged: (bool? value) {
          if (value != null && onCompleted != null) {
            onCompleted!(value);
          }
        },
        activeColor: AppColors.green,
        checkColor: AppColors.base,
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: isGoalReached ? AppColors.green.withOpacity(0.1) : AppColors.surface0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isGoalReached
            ? BorderSide(color: AppColors.green, width: 1.5)
            : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        leading: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: habit.color,
            shape: BoxShape.circle,
          ),
        ),
        title: Text(
          habit.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                decoration: !isCounter && isCompleted ? TextDecoration.lineThrough : null,
                color: isCompleted ? AppColors.subtext0 : AppColors.text,
              ),
        ),
        subtitle: isCounter
            ? Text(
                '${progress ?? 0} / ${habit.counterGoal} ${habit.unitLabel}',
                style: TextStyle(color: AppColors.subtext1),
              )
            : null,
        trailing: trailingWidget,
      ),
    );
  }
}
