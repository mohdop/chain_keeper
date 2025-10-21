import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement.dart';
import '../models/habit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class AchievementService {
  static const String _achievementsKey = 'achievements';

  // Liste de tous les achievements par défaut
  static final List<Achievement> defaultAchievements = [
    Achievement(
      id: 'first_step',
      title: 'Premier Pas',
      description: 'Complétez votre première journée',
      requiredDays: 1,
      icon: FontAwesomeIcons.shoePrints,
      color: const Color(0xFF00D9A5),
    ),
    Achievement(
      id: 'week_warrior',
      title: 'Guerrier de la Semaine',
      description: 'Maintenez une série de 7 jours',
      requiredDays: 7,
      icon: Icons.military_tech,
      color: const Color(0xFF6C63FF),
    ),
    Achievement(
      id: 'two_weeks',
      title: 'Deux Semaines',
      description: 'Maintenez une série de 14 jours',
      requiredDays: 14,
      icon: Icons.star,
      color: const Color(0xFF2196F3),
    ),
    Achievement(
      id: 'month_master',
      title: 'Maître du Mois',
      description: 'Maintenez une série de 30 jours',
      requiredDays: 30,
      icon: Icons.emoji_events,
      color: const Color(0xFFFDD835),
    ),
    Achievement(
      id: 'fifty_days',
      title: 'Demi-Centurion',
      description: 'Maintenez une série de 50 jours',
      requiredDays: 50,
      icon: Icons.stars,
      color: const Color(0xFFFF9800),
    ),
    Achievement(
      id: 'centurion',
      title: 'Centurion',
      description: 'Maintenez une série de 100 jours',
      requiredDays: 100,
      icon: Icons.workspace_premium,
      color: const Color(0xFFFF6B9D),
    ),
    Achievement(
      id: 'half_year',
      title: 'Six Mois',
      description: 'Maintenez une série de 180 jours',
      requiredDays: 180,
      icon: Icons.diamond,
      color: const Color(0xFF9C27B0),
    ),
    Achievement(
      id: 'dedicated',
      title: 'Dévouement Absolu',
      description: 'Maintenez une série de 365 jours',
      requiredDays: 365,
      icon: Icons.auto_awesome,
      color: const Color(0xFFFFD700),
    ),
    Achievement(
      id: 'multi_tasker',
      title: 'Multi-tâches',
      description: 'Ayez 3 habitudes actives',
      requiredDays: 0,
      icon: Icons.apps,
      color: const Color(0xFF4CAF50),
    ),
    Achievement(
      id: 'collector',
      title: 'Collectionneur',
      description: 'Créez 5 habitudes',
      requiredDays: 0,
      icon: Icons.collections,
      color: const Color(0xFFE91E63),
    ),
  ];

  // Sauvegarder les achievements
  Future<void> saveAchievements(List<Achievement> achievements) async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsJson = achievements.map((a) => a.toJson()).toList();
    await prefs.setString(_achievementsKey, jsonEncode(achievementsJson));
  }

  // Charger les achievements
  Future<List<Achievement>> loadAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final achievementsString = prefs.getString(_achievementsKey);

    if (achievementsString == null) {
      return List.from(defaultAchievements);
    }

    try {
      final List<dynamic> achievementsJson = jsonDecode(achievementsString);
      return achievementsJson.map((json) => Achievement.fromJson(json)).toList();
    } catch (e) {
      print('Error loading achievements: $e');
      return List.from(defaultAchievements);
    }
  }

  // Vérifier et débloquer les achievements
  Future<List<Achievement>> checkAndUnlockAchievements(
    List<Achievement> currentAchievements,
    List<Habit> habits,
  ) async {
    final updatedAchievements = List<Achievement>.from(currentAchievements);
    final newlyUnlocked = <Achievement>[];

    for (int i = 0; i < updatedAchievements.length; i++) {
      final achievement = updatedAchievements[i];
      
      if (achievement.isUnlocked) continue;

      bool shouldUnlock = false;

      switch (achievement.id) {
        case 'first_step':
          shouldUnlock = _checkFirstStep(habits);
          break;
        case 'week_warrior':
          shouldUnlock = _checkStreak(habits, 7);
          break;
        case 'two_weeks':
          shouldUnlock = _checkStreak(habits, 14);
          break;
        case 'month_master':
          shouldUnlock = _checkStreak(habits, 30);
          break;
        case 'fifty_days':
          shouldUnlock = _checkStreak(habits, 50);
          break;
        case 'centurion':
          shouldUnlock = _checkStreak(habits, 100);
          break;
        case 'half_year':
          shouldUnlock = _checkStreak(habits, 180);
          break;
        case 'dedicated':
          shouldUnlock = _checkStreak(habits, 365);
          break;
        case 'multi_tasker':
          shouldUnlock = habits.where((h) => h.isActive).length >= 3;
          break;
        case 'collector':
          shouldUnlock = habits.length >= 5;
          break;
      }

      if (shouldUnlock) {
        updatedAchievements[i] = achievement.copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.now(),
        );
        newlyUnlocked.add(updatedAchievements[i]);
      }
    }

    if (newlyUnlocked.isNotEmpty) {
      await saveAchievements(updatedAchievements);
    }

    return newlyUnlocked;
  }

  bool _checkFirstStep(List<Habit> habits) {
    return habits.any((h) => h.completionHistory.isNotEmpty);
  }

  bool _checkStreak(List<Habit> habits, int targetStreak) {
    return habits.any((h) => h.currentStreak >= targetStreak);
  }

  // Obtenir les statistiques d'achievements
  Map<String, dynamic> getAchievementStats(List<Achievement> achievements) {
    final unlocked = achievements.where((a) => a.isUnlocked).length;
    final total = achievements.length;
    final percentage = total > 0 ? ((unlocked / total) * 100).round() : 0;

    return {
      'unlocked': unlocked,
      'total': total,
      'percentage': percentage,
    };
  }

  // Obtenir le prochain achievement à débloquer
  Achievement? getNextAchievement(List<Achievement> achievements, List<Habit> habits) {
    final locked = achievements.where((a) => !a.isUnlocked).toList();
    
    if (locked.isEmpty) return null;

    // Trier par requiredDays
    locked.sort((a, b) => a.requiredDays.compareTo(b.requiredDays));

    // Trouver le plus proche d'être débloqué
    int maxStreak = habits.isEmpty ? 0 : habits.map((h) => h.currentStreak).reduce((a, b) => a > b ? a : b);
    
    for (final achievement in locked) {
      if (achievement.requiredDays > 0 && achievement.requiredDays > maxStreak) {
        return achievement;
      }
    }

    return locked.first;
  }
}