import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import 'visualizations/garden_visual.dart';
import 'visualizations/bridge_visual.dart';
import 'visualizations/constellation_visual.dart';
import '../screens/habit_detail_screen.dart';

class HabitCard extends StatelessWidget {
  final Habit habit;

  const HabitCard({Key? key, required this.habit}) : super(key: key);

  IconData _getIconForVisualType(String visualType) {
    switch (visualType) {
      case 'garden':
        return Icons.local_florist;
      case 'bridge':
        return Icons.architecture;
      case 'constellation':
        return Icons.auto_awesome;
      default:
        return Icons.check_circle;
    }
  }
  Widget _buildVisualization(String visualType, int streak) {
  switch (visualType) {
    case 'garden':
      return GardenVisual(streak: streak, size: 80);
    case 'bridge':
      return BridgeVisual(streak: streak, size: 80);
    case 'constellation':
      return ConstellationVisual(streak: streak,);
    default:
      return Center(
        child: Icon(
          _getIconForVisualType(visualType),
          color: _getColorForVisualType(visualType),
          size: 40,
        ),
      );
  }
}

  Color _getColorForVisualType(String visualType) {
    switch (visualType) {
      case 'garden':
        return const Color(0xFF00D9A5);
      case 'bridge':
        return const Color(0xFFFFA500);
      case 'constellation':
        return const Color(0xFF6C63FF);
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final isCompletedToday = habitProvider.isCompletedToday(habit);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HabitDetailScreen(habit: habit),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color:Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            if (Theme.of(context).brightness == Brightness.light)
              BoxShadow(
                blurRadius: 12,
                offset: const Offset(0, 4),
                color: Colors.black.withOpacity(0.08), // very soft shadow, light mode only
              ),
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Visualisation au lieu de l'icône simple
              // Visualisation au lieu de l'icône simple
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: _getColorForVisualType(habit.visualType).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: _buildVisualization(habit.visualType, habit.currentStreak),
                ),
              ),
              
              // Nom et streak
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      habit.name,
                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),),

                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: habit.currentStreak > 0 
                              ? const Color(0xFFFF6B9D) 
                              : const Color.fromARGB(255, 70, 70, 70),
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${habit.currentStreak} jours',
                          style: TextStyle(
                            fontSize: 14,
                            color: const Color.fromARGB(255, 70, 70, 70),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Bouton de complétion
              GestureDetector(
                onTap: isCompletedToday 
                    ? null 
                    : () => habitProvider.completeHabit(habit.id),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: isCompletedToday 
                        ? const Color.fromARGB(255, 46, 42, 70) 
                        : Colors.grey[800],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCompletedToday ? Icons.check : Icons.check_circle_outline,
                    color: isCompletedToday ? Colors.white : Colors.grey[600],
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );  // ← Cette fermeture manquait
  }
}