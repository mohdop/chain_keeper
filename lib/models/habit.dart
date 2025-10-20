import 'package:flutter/material.dart';

class Habit {
  String id;
  String name;
  String visualType;
  DateTime createdDate;
  int reminderHour;
  int reminderMinute;
  int currentStreak;
  int longestStreak;
  DateTime? lastCompletedDate;
  List<DateTime> completionHistory;
  int freezesUsedThisMonth;
  bool isActive;

  Habit({
    required this.id,
    required this.name,
    required this.visualType,
    required this.createdDate,
    required this.reminderHour,
    required this.reminderMinute,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastCompletedDate,
    List<DateTime>? completionHistory,
    this.freezesUsedThisMonth = 0,
    this.isActive = true,
  }) : completionHistory = completionHistory ?? [];

  // Convertir en Map pour sauvegarder
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'visualType': visualType,
      'createdDate': createdDate.toIso8601String(),
      'reminderHour': reminderHour,
      'reminderMinute': reminderMinute,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
      'completionHistory': completionHistory.map((d) => d.toIso8601String()).toList(),
      'freezesUsedThisMonth': freezesUsedThisMonth,
      'isActive': isActive,
    };
  }

  // Créer depuis Map
  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'],
      name: json['name'],
      visualType: json['visualType'],
      createdDate: DateTime.parse(json['createdDate']),
      reminderHour: json['reminderHour'],
      reminderMinute: json['reminderMinute'],
      currentStreak: json['currentStreak'] ?? 0,
      longestStreak: json['longestStreak'] ?? 0,
      lastCompletedDate: json['lastCompletedDate'] != null 
          ? DateTime.parse(json['lastCompletedDate']) 
          : null,
      completionHistory: (json['completionHistory'] as List<dynamic>?)
          ?.map((d) => DateTime.parse(d as String))
          .toList() ?? [],
      freezesUsedThisMonth: json['freezesUsedThisMonth'] ?? 0,
      isActive: json['isActive'] ?? true,
    );
  }

  TimeOfDay get reminderTime => TimeOfDay(hour: reminderHour, minute: reminderMinute);
  
  void setReminderTime(TimeOfDay time) {
    reminderHour = time.hour;
    reminderMinute = time.minute;
  }
}