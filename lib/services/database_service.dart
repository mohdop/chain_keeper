import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

class DatabaseService {
  static const String _habitsKey = 'habits';

  // Sauvegarder tous les habits
  Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = habits.map((h) => h.toJson()).toList();
    await prefs.setString(_habitsKey, jsonEncode(habitsJson));
  }

  // Charger tous les habits
  Future<List<Habit>> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsString = prefs.getString(_habitsKey);
    
    if (habitsString == null) {
      return [];
    }

    final List<dynamic> habitsJson = jsonDecode(habitsString);
    return habitsJson.map((json) => Habit.fromJson(json)).toList();
  }

  // Sauvegarder un habit
  Future<void> saveHabit(Habit habit) async {
    final habits = await loadHabits();
    final index = habits.indexWhere((h) => h.id == habit.id);
    
    if (index >= 0) {
      habits[index] = habit;
    } else {
      habits.add(habit);
    }
    
    await saveHabits(habits);
  }

  // Supprimer un habit
  Future<void> deleteHabit(String id) async {
    final habits = await loadHabits();
    habits.removeWhere((h) => h.id == id);
    await saveHabits(habits);
  }

  // Effacer tout
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_habitsKey);
  }
}