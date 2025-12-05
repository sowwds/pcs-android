import 'package:flutter/material.dart';
import 'package:habit_tracker/core/constants/app_colors.dart';
import 'package:habit_tracker/features/auth/screens/login_screen.dart';
import 'package:habit_tracker/features/auth/services/auth_service.dart';
import 'package:habit_tracker/features/habits/models/habit.dart';
import 'package:habit_tracker/features/habits/screens/habit_details_screen.dart';
import 'package:habit_tracker/features/habits/screens/habit_form_screen.dart';
import 'package:habit_tracker/features/habits/services/habits_service.dart';
import 'package:habit_tracker/features/habits/widgets/habit_list_item.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final _habitsService = HabitsService();
  final _authService = AuthService();

  bool _isLoading = true;
  List<Habit> _habits = [];
  Map<int, int> _progressMap = {}; // habitId -> progress

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final habits = await _habitsService.getHabits();
      final completions =
          await _habitsService.getCompletionsForDate(DateTime.now());
      if (mounted) {
        setState(() {
          _habits = habits;
          _progressMap = {for (var c in completions) c.habitId: c.progress ?? 0};
        });
      }
    } catch (e) {
      _showError('Error loading data: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onHabitCompleted(Habit habit, bool isCompleted) async {
    try {
      if (isCompleted) {
        await _habitsService.addCompletion(habit.id, DateTime.now());
        setState(() => _progressMap[habit.id] = 1);
      } else {
        await _habitsService.removeCompletion(habit.id, DateTime.now());
        setState(() => _progressMap.remove(habit.id));
      }
    } catch (e) {
      _showError('Error updating habit: ${e.toString()}');
    }
  }

  void _incrementCounter(Habit habit) async {
    try {
      await _habitsService.incrementCounter(habit.id, habit.counterStep!, DateTime.now());
      setState(() {
        _progressMap[habit.id] = (_progressMap[habit.id] ?? 0) + habit.counterStep!;
      });
    } catch(e) {
      _showError('Error incrementing counter: ${e.toString()}');
    }
  }

  void _decrementCounter(Habit habit) async {
    if ((_progressMap[habit.id] ?? 0) <= 0) return;
     try {
      await _habitsService.decrementCounter(habit.id, habit.counterStep!, DateTime.now());
      setState(() {
        _progressMap[habit.id] = (_progressMap[habit.id] ?? 0) - habit.counterStep!;
         if((_progressMap[habit.id] ?? 0) < 0) _progressMap[habit.id] = 0;
      });
    } catch(e) {
      _showError('Error decrementing counter: ${e.toString()}');
    }
  }

  Future<void> _signOut() async {
    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    } catch (e) {
      _showError('Error signing out: ${e.toString()}');
    }
  }

  void _navigateAndRefresh({Habit? habit}) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => HabitFormScreen(habit: habit),
      ),
    );

    if (result == true && mounted) {
      _loadData();
    }
  }

  void _navigateToDetails(Habit habit) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => HabitDetailsScreen(habit: habit),
      ),
    );
    if (result == true && mounted) {
      _loadData();
    }
  }
  
  Future<void> _deleteHabit(Habit habit) async {
    final confirmed = await _showConfirmationDialog(
        'Delete Habit?', 'Do you want to delete "${habit.name}"?');
    if (confirmed == true && mounted) {
      try {
        await _habitsService.deleteHabit(habit.id);
        _loadData();
      } catch (e) {
        _showError('Failed to delete: ${e.toString()}');
      }
    }
  }

  void _showOptions(Habit habit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface1,
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: AppColors.text),
              title: const Text('Edit'),
              onTap: () {
                Navigator.of(context).pop();
                _navigateAndRefresh(habit: habit);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.red),
              title: const Text('Delete', style: TextStyle(color: AppColors.red)),
              onTap: () {
                Navigator.of(context).pop();
                _deleteHabit(habit);
              },
            ),
          ],
        );
      },
    );
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppColors.red),
      );
    }
  }

   Future<bool?> _showConfirmationDialog(String title, String content) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _habits.isEmpty
              ? const Center(
                  child: Text(
                    'No habits yet. Tap "+" to add one!',
                    style: TextStyle(color: AppColors.subtext0),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _habits.length,
                    itemBuilder: (context, index) {
                      final habit = _habits[index];
                      final isSimple = habit.habitType == HabitType.simple;
                      final progress = _progressMap[habit.id];

                      return GestureDetector(
                        onTap: () => _navigateToDetails(habit),
                        onLongPress: () => _showOptions(habit),
                        child: HabitListItem(
                          habit: habit,
                          progress: progress,
                          isCompleted: progress != null && progress > 0,
                          onCompleted: isSimple ? (value) => _onHabitCompleted(habit, value) : null,
                          onIncrement: !isSimple ? () => _incrementCounter(habit) : null,
                          onDecrement: !isSimple ? () => _decrementCounter(habit) : null,
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndRefresh(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
