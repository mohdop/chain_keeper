import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';

class HabitProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  List<Habit> _habits = [];
  final DatabaseService _dbService = DatabaseService();
  bool _isLoading = false;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;

  // Charger les habits au démarrage
  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();
    
    _habits = await _dbService.loadHabits();
    
    _isLoading = false;
    notifyListeners();
  }

  // Ajouter un habit
  Future<void> addHabit(Habit habit) async {
  _habits.add(habit);
  await _dbService.saveHabit(habit);
  
  // Planifier la notification
  await _notificationService.scheduleHabitReminder(habit);
  
  notifyListeners();
}

  // Compléter un habit
  Future<void> completeHabit(String habitId) async {
    final habit = _habits.firstWhere((h) => h.id == habitId);
    
    DateTime today = DateTime.now();
    DateTime? lastCompleted = habit.lastCompletedDate;
    
    // Vérifier si déjà complété aujourd'hui
    if (lastCompleted != null && 
        lastCompleted.year == today.year && 
        lastCompleted.month == today.month && 
        lastCompleted.day == today.day) {
      return; // Déjà fait aujourd'hui
    }
    
    if (lastCompleted != null) {
      int daysDifference = today.difference(lastCompleted).inDays;
      
      if (daysDifference == 1) {
        // Continue la série
        habit.currentStreak++;
      } else if (daysDifference > 1) {
        // Série cassée
        habit.currentStreak = 1;
      }
    } else {
      // Premier jour
      habit.currentStreak = 1;
    }
    
    // Mettre à jour le record
    if (habit.currentStreak > habit.longestStreak) {
      habit.longestStreak = habit.currentStreak;
    }
    
    habit.lastCompletedDate = today;
    habit.completionHistory.add(today);
    
    await _dbService.saveHabit(habit);
    notifyListeners();
  }

  // Supprimer un habit
  Future<void> deleteHabit(String habitId) async {
  _habits.removeWhere((h) => h.id == habitId);
  await _dbService.deleteHabit(habitId);
  
  // Annuler la notification
  await _notificationService.cancelHabitReminder(habitId);
  
  notifyListeners();
}

  // Vérifier si un habit est complété aujourd'hui
  bool isCompletedToday(Habit habit) {
    if (habit.lastCompletedDate == null) return false;
    
    final today = DateTime.now();
    final lastCompleted = habit.lastCompletedDate!;
    
    return lastCompleted.year == today.year &&
           lastCompleted.month == today.month &&
           lastCompleted.day == today.day;
  }
}