// models/achievement.dart
import 'package:flutter/material.dart';

enum AchievementType {
  firstStep,        // Premier jour complété
  weekWarrior,      // 7 jours de suite
  monthMaster,      // 30 jours de suite
  centurion,        // 100 jours de suite
  dedicated,        // 365 jours de suite
  multiTasker,      // 3 habitudes actives
  collector,        // 5 habitudes créées
  perfectWeek,      // Toutes les habitudes complétées pendant 7 jours
  comeback,         // Repris après une pause
  earlyBird,        // Complété avant 8h du matin
}

class Achievement {
  final AchievementType type;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int targetValue;
  final DateTime? unlockedAt;

  Achievement({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.targetValue,
    this.unlockedAt,
  });

  bool get isUnlocked => unlockedAt != null;

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json, Achievement template) {
    return Achievement(
      type: template.type,
      title: template.title,
      description: template.description,
      icon: template.icon,
      color: template.color,
      targetValue: template.targetValue,
      unlockedAt: json['unlockedAt'] != null 
          ? DateTime.parse(json['unlockedAt']) 
          : null,
    );
  }

  Achievement copyWith({DateTime? unlockedAt}) {
    return Achievement(
      type: type,
      title: title,
      description: description,
      icon: icon,
      color: color,
      targetValue: targetValue,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}
