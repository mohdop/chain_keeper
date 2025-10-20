import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/habit.dart';

class HabitCalendar extends StatelessWidget {
  final Habit habit;

  const HabitCalendar({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Historique',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        
        // Calendrier du mois actuel
        _buildMonthCalendar(DateTime.now()),
        
        const SizedBox(height: 20),
        
        // Calendrier du mois précédent
        _buildMonthCalendar(
          DateTime(DateTime.now().year, DateTime.now().month - 1),
        ),
        
        const SizedBox(height: 20),
        
        // Légende
        _buildLegend(),
      ],
    );
  }

  Widget _buildMonthCalendar(DateTime month) {
    final monthName = DateFormat.yMMMM('fr_FR').format(month);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          monthName.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[400],
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A3E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // En-têtes des jours (L, M, M, J, V, S, D)
              _buildWeekdayHeaders(),
              const SizedBox(height: 10),
              
              // Grille des jours
              _buildDaysGrid(month),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeekdayHeaders() {
    final weekdays = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekdays.map((day) {
        return SizedBox(
          width: 36,
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDaysGrid(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final lastDayOfMonth = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    
    // Jour de la semaine du premier jour (1 = lundi, 7 = dimanche)
    int firstWeekday = firstDayOfMonth.weekday;
    
    // Créer une liste de tous les jours à afficher
    List<Widget> dayWidgets = [];
    
    // Ajouter des espaces vides pour les jours avant le début du mois
    for (int i = 1; i < firstWeekday; i++) {
      dayWidgets.add(_buildEmptyDay());
    }
    
    // Ajouter tous les jours du mois
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(month.year, month.month, day);
      dayWidgets.add(_buildDayCell(date));
    }
    
    // Organiser en lignes de 7 jours
    List<Widget> rows = [];
    for (int i = 0; i < dayWidgets.length; i += 7) {
      final end = (i + 7 < dayWidgets.length) ? i + 7 : dayWidgets.length;
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dayWidgets.sublist(i, end),
          ),
        ),
      );
    }
    
    return Column(children: rows);
  }

  Widget _buildEmptyDay() {
    return const SizedBox(
      width: 36,
      height: 36,
    );
  }

  Widget _buildDayCell(DateTime date) {
    final today = DateTime.now();
    final isToday = date.year == today.year && 
                    date.month == today.month && 
                    date.day == today.day;
    
    final isCompleted = _isDateCompleted(date);
    final isMissed = _isDateMissed(date);
    final isFuture = date.isAfter(today);
    final isBeforeCreation = date.isBefore(habit.createdDate);
    
    Color bgColor;
    Color textColor = Colors.white;
    Border? border;
    
    if (isBeforeCreation || isFuture) {
      // Jour avant la création de l'habitude ou dans le futur
      bgColor = Colors.transparent;
      textColor = Colors.grey[700]!;
    } else if (isCompleted) {
      // Jour complété
      bgColor = const Color(0xFF00D9A5);
      textColor = Colors.white;
    } else if (isMissed) {
      // Jour manqué
      bgColor = const Color(0xFFFF4757);
      textColor = Colors.white;
    } else {
      // Jour non applicable
      bgColor = Colors.transparent;
      textColor = Colors.grey[600]!;
    }
    
    // Bordure pour aujourd'hui
    if (isToday && !isFuture) {
      border = Border.all(
        color: const Color(0xFF6C63FF),
        width: 2,
      );
    }
    
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: border,
      ),
      child: Center(
        child: Text(
          '${date.day}',
          style: TextStyle(
            fontSize: 12,
            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            color: textColor,
          ),
        ),
      ),
    );
  }

  bool _isDateCompleted(DateTime date) {
    return habit.completionHistory.any((completedDate) =>
      completedDate.year == date.year &&
      completedDate.month == date.month &&
      completedDate.day == date.day
    );
  }

  bool _isDateMissed(DateTime date) {
    final today = DateTime.now();
    final createdDate = habit.createdDate;
    
    // Ne pas considérer comme manqué si :
    // - C'est aujourd'hui ou dans le futur
    // - C'est avant la création de l'habitude
    if (date.isAfter(today) || 
        date.isBefore(DateTime(createdDate.year, createdDate.month, createdDate.day))) {
      return false;
    }
    
    // C'est manqué si ce n'est pas dans l'historique
    return !_isDateCompleted(date);
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem(
            color: const Color(0xFF00D9A5),
            label: 'Complété',
          ),
          _buildLegendItem(
            color: const Color(0xFFFF4757),
            label: 'Manqué',
          ),
          _buildLegendItem(
            color: const Color(0xFF6C63FF),
            label: 'Aujourd\'hui',
            isBorder: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    bool isBorder = false,
  }) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: isBorder ? Colors.transparent : color,
            shape: BoxShape.circle,
            border: isBorder ? Border.all(color: color, width: 2) : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }
}