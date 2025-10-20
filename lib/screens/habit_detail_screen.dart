import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../widgets/visualizations/garden_visual.dart';
import '../widgets/visualizations/bridge_visual.dart';
import '../widgets/visualizations/constellation_visual.dart';
import '../widgets/habit_calendar.dart';

class HabitDetailScreen extends StatelessWidget {
  final Habit habit;

  const HabitDetailScreen({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final habitProvider = Provider.of<HabitProvider>(context);
    final isCompletedToday = habitProvider.isCompletedToday(habit);

    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Grande visualisation
            Container(
              height: 300,
              width: double.infinity,
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A3E),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Center(
                  child: _buildVisualization(habit.visualType, habit.currentStreak),
                ),
              ),
            ),

            // Bouton de complétion
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: isCompletedToday
                      ? null
                      : () => habitProvider.completeHabit(habit.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCompletedToday
                        ? const Color(0xFF00D9A5)
                        : const Color(0xFF6C63FF),
                    disabledBackgroundColor: const Color(0xFF00D9A5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isCompletedToday ? Icons.check_circle : Icons.check_circle_outline,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        isCompletedToday ? 'Complété aujourd\'hui !' : 'Marquer comme fait',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Statistiques
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Statistiques',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Cartes de stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Série actuelle',
                          '${habit.currentStreak}',
                          Icons.local_fire_department,
                          const Color(0xFFFF6B9D),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildStatCard(
                          'Meilleur série',
                          '${habit.longestStreak}',
                          Icons.emoji_events,
                          const Color(0xFFFDD835),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total complétions',
                          '${habit.completionHistory.length}',
                          Icons.done_all,
                          const Color(0xFF00D9A5),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildStatCard(
                          'Taux de réussite',
                          '${_calculateSuccessRate(habit)}%',
                          Icons.trending_up,
                          const Color(0xFF6C63FF),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Informations
                  const Text(
                    'Informations',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),

                  _buildInfoRow(
                    'Date de création',
                    DateFormat('dd MMMM yyyy', 'fr_FR').format(habit.createdDate),
                    Icons.calendar_today,
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                    'Thème visuel',
                    _getVisualTypeName(habit.visualType),
                    _getVisualTypeIcon(habit.visualType),
                  ),
                  const SizedBox(height: 10),
                  _buildInfoRow(
                    'Dernière complétion',
                    habit.lastCompletedDate != null
                        ? DateFormat('dd MMMM yyyy', 'fr_FR').format(habit.lastCompletedDate!)
                        : 'Jamais',
                    Icons.event_available,
                  ),

                  const SizedBox(height: 30),

                  // CALENDRIER ICI ← La bonne position !
                  HabitCalendar(habit: habit),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualization(String visualType, int streak) {
    switch (visualType) {
      case 'garden':
        return GardenVisual(streak: streak, size: 250);
      case 'bridge':
        return BridgeVisual(streak: streak, size: 250);
      case 'constellation':
        return ConstellationVisual(streak: streak, size: 250);
      default:
        return const Icon(Icons.check_circle, size: 100);
    }
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6C63FF), size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateSuccessRate(Habit habit) {
    if (habit.completionHistory.isEmpty) return 0;

    final daysSinceCreation = DateTime.now().difference(habit.createdDate).inDays + 1;
    final completions = habit.completionHistory.length;

    return ((completions / daysSinceCreation) * 100).round();
  }

  String _getVisualTypeName(String visualType) {
    switch (visualType) {
      case 'garden':
        return 'Jardin 🌸';
      case 'bridge':
        return 'Pont 🌉';
      case 'constellation':
        return 'Constellation ✨';
      default:
        return 'Inconnu';
    }
  }

  IconData _getVisualTypeIcon(String visualType) {
    switch (visualType) {
      case 'garden':
        return Icons.local_florist;
      case 'bridge':
        return Icons.architecture;
      case 'constellation':
        return Icons.auto_awesome;
      default:
        return Icons.help;
    }
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A3E),
        title: const Text('Supprimer l\'habitude'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer "${habit.name}" ?\nCette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<HabitProvider>(context, listen: false)
                  .deleteHabit(habit.id);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Supprimer',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}