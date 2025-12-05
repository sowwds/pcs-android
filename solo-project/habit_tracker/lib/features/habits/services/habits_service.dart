import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:habit_tracker/core/services/supabase_service.dart';
import 'package:habit_tracker/features/habits/models/habit.dart';
import 'package:habit_tracker/features/habits/models/completion.dart';

/// Service class for handling habit-related database operations.
class HabitsService {
  final SupabaseClient _client = SupabaseService.instance;

  /// Fetches all habits for the current user.
  Future<List<Habit>> getHabits() async {
    try {
      final response = await _client
          .from('habits')
          .select()
          .order('created_at', ascending: true);
      return response.map((item) => Habit.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error getting habits: $e');
      rethrow;
    }
  }

  /// Creates a new habit for the current user.
  Future<void> createHabit(Habit habit) async {
    try {
      await _client.from('habits').insert(habit.toJson());
    } catch (e) {
      debugPrint('Error creating habit: $e');
      rethrow;
    }
  }

  /// Updates an existing habit.
  Future<void> updateHabit(Habit habit) async {
    try {
      // Supabase does not allow updating primary key, so remove it.
      final updates = habit.toJson()..remove('id');
      await _client.from('habits').update(updates).eq('id', habit.id);
    } catch (e) {
      debugPrint('Error updating habit: $e');
      rethrow;
    }
  }

  /// Deletes a habit by its ID.
  Future<void> deleteHabit(int habitId) async {
    try {
      await _client.from('habits').delete().eq('id', habitId);
    } catch (e) {
      debugPrint('Error deleting habit: $e');
      rethrow;
    }
  }

  /// Fetches completions for a specific habit.
  Future<List<Completion>> getCompletionsForHabit(int habitId) async {
    try {
      final response = await _client
          .from('completions')
          .select()
          .eq('habit_id', habitId)
          .order('completion_date', ascending: false);
      return response.map((item) => Completion.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error getting completions: $e');
      rethrow;
    }
  }

  /// Fetches completions for the current user for a specific date.
  Future<List<Completion>> getCompletionsForDate(DateTime date) async {
    try {
      final dateString =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      final response = await _client
          .from('completions')
          .select('*, habits!inner(user_id)')
          .eq('habits.user_id', _client.auth.currentUser!.id)
          .eq('completion_date', dateString);
      return response.map((item) => Completion.fromJson(item)).toList();
    } catch (e) {
      debugPrint('Error getting completions for date: $e');
      rethrow;
    }
  }

  /// Adds a completion for a simple habit.
  Future<void> addCompletion(int habitId, DateTime date) async {
    final completion = Completion(
      id: 0,
      habitId: habitId,
      completionDate: date,
      createdAt: DateTime.now(),
      progress: 1, // For simple habits, progress is just 1
    );
    try {
      await _client.from('completions').insert(completion.toJson());
    } catch (e) {
      debugPrint('Error adding completion: $e');
      rethrow;
    }
  }
  
    /// Removes a completion for a simple habit.
  Future<void> removeCompletion(int habitId, DateTime date) async {
    try {
      final dateString =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      await _client
          .from('completions')
          .delete()
          .eq('habit_id', habitId)
          .eq('completion_date', dateString);
    } catch (e) {
      debugPrint('Error removing completion: $e');
      rethrow;
    }
  }


  /// Increments the progress of a counter habit for a specific date.
  /// Uses a stored procedure in Supabase for atomicity.
  Future<void> incrementCounter(int habitId, int step, DateTime date) async {
     try {
       await _client.rpc('increment_habit_progress', params: {
        'p_habit_id': habitId,
        'p_completion_date': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        'p_increment_value': step,
      });
    } catch (e) {
      debugPrint('Error incrementing counter: $e');
      rethrow;
    }
  }

  /// Decrements the progress of a counter habit for a specific date.
  Future<void> decrementCounter(int habitId, int step, DateTime date) async {
     try {
       await _client.rpc('decrement_habit_progress', params: {
        'p_habit_id': habitId,
        'p_completion_date': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        'p_decrement_value': step,
      });
    } catch (e) {
      debugPrint('Error decrementing counter: $e');
      rethrow;
    }
  }
}
