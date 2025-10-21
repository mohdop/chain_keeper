import 'package:chain_keeper/services/achievement_service.dart';
import 'package:flutter/material.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final int requiredDays;
  final IconData icon;
  final Color color;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.requiredDays,
    required this.icon,
    required this.color,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    int? requiredDays,
    IconData? icon,
    Color? color,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      requiredDays: requiredDays ?? this.requiredDays,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'requiredDays': requiredDays,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    // Get the default achievement to retrieve icon and color
    final defaultAchievement = AchievementService.defaultAchievements
        .firstWhere((a) => a.id == json['id']);
    
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      requiredDays: json['requiredDays'],
      icon: defaultAchievement.icon,
      color: defaultAchievement.color,
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
    );
  }
}