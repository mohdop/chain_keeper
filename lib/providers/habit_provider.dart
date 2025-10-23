import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import '../services/achievement_service.dart';
import '../models/achievement.dart';

class HabitProvider with ChangeNotifier {
  final NotificationService _notificationService = NotificationService();
  final AchievementService _achievementService = AchievementService();
  final DatabaseService _dbService = DatabaseService();
  
  List<Habit> _habits = [];
  List<Achievement> _achievements = [];
  bool _isLoading = false;

  List<Habit> get habits => _habits;
  List<Achievement> get achievements => _achievements;
  bool get isLoading => _isLoading;

  // Charger les habits au démarrage
  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();
    
    _habits = await _dbService.loadHabits();
    _achievements = await _achievementService.loadAchievements();
    
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
    
    // Vérifier les achievements (pour Collector, MultiTasker)
    await _checkAchievements();
  }

    // Compléter un habit
  Future<List<Achievement>?> completeHabit(String habitId) async {
    final habit = _habits.firstWhere((h) => h.id == habitId);
    
    DateTime today = _normalizeDate(DateTime.now());
    DateTime? lastCompleted = habit.lastCompletedDate != null 
        ? _normalizeDate(habit.lastCompletedDate!)
        : null;
    
    // Vérifier si déjà complété aujourd'hui
    if (lastCompleted != null && _isSameDay(lastCompleted, today)) {
      return null; // Déjà fait aujourd'hui
    }
    
    // Calculer le nouveau streak
    if (lastCompleted != null) {
      int daysDifference = today.difference(lastCompleted).inDays;
      
      if (daysDifference == 1) {
        // Continue la série - jour consécutif
        habit.currentStreak++;
      } else if (daysDifference > 1) {
        // Série cassée - redémarre à 1
        habit.currentStreak = 1;
      }
      // Note: daysDifference == 0 ne devrait jamais arriver ici car filtré plus haut
    } else {
      // Premier jour - démarre la série
      habit.currentStreak = 1;
    }
    
    // Mettre à jour le record
    if (habit.currentStreak > habit.longestStreak) {
      habit.longestStreak = habit.currentStreak;
    }
    
    // Enregistrer la complétion avec la date normalisée
    habit.lastCompletedDate = today;
    habit.completionHistory.add(today);
    
    await _dbService.saveHabit(habit);
    notifyListeners();
    
    // Vérifier les achievements
    final newAchievements = await _achievementService.checkAndUnlockAchievements(
      _achievements,
      _habits,
    );
    
    if (newAchievements.isNotEmpty) {
      _achievements = await _achievementService.loadAchievements();
      notifyListeners();
      return newAchievements;
    }
    
    return null;
  }

// Méthode helper pour normaliser les dates (enlever l'heure)
DateTime _normalizeDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

// Méthode helper pour comparer si deux dates sont le même jour
bool _isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
         date1.month == date2.month &&
         date1.day == date2.day;
}

// Vérifier si un habit est complété aujourd'hui (mise à jour aussi)
bool isCompletedToday(Habit habit) {
  if (habit.lastCompletedDate == null) return false;
  
  final today = DateTime.now();
  final lastCompleted = habit.lastCompletedDate!;
  
  return _isSameDay(lastCompleted, today);
}



  
  // Supprimer un habit
  Future<void> deleteHabit(String habitId) async {
    _habits.removeWhere((h) => h.id == habitId);
    await _dbService.deleteHabit(habitId);
    
    // Annuler la notification
    await _notificationService.cancelHabitReminder(habitId);
    
    notifyListeners();
  }

  // Mettre à jour un habit
  Future<void> updateHabit(Habit habit) async {
    final index = _habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      _habits[index] = habit;
      await _dbService.saveHabit(habit);
      
      // Reprogrammer la notification avec la nouvelle heure
      await _notificationService.cancelHabitReminder(habit.id);
      await _notificationService.scheduleHabitReminder(habit);
      
      notifyListeners();
    }
  }

  // Vérifier les achievements (méthode privée)
  Future<void> _checkAchievements() async {
    final newAchievements = await _achievementService.checkAndUnlockAchievements(
      _achievements,
      _habits,
    );
    
    if (newAchievements.isNotEmpty) {
      _achievements = await _achievementService.loadAchievements();
      notifyListeners();
    }
  }
}