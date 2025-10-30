import 'package:chain_keeper/screens/settings_screen.dart';
import 'package:chain_keeper/widgets/achievements_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_card.dart';
import 'add_habit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: const Text('Chain Keeper'),
      centerTitle: true,
      actions: [
         IconButton(
        icon: const Icon(Icons.emoji_events_outlined), // 🏆 Achievements
        onPressed: () {
          Navigator.push(
            context,
        MaterialPageRoute(
          builder: (context) => const AchievementsScreen(),
        ),
      );
    },
  ),
        // Bouton Settings
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          tooltip: 'Paramètres',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, child) {
          if (habitProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6C63FF),
              ),
            );
          }

          if (habitProvider.habits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 80,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Aucune habitude',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Appuie sur + pour commencer',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: habitProvider.habits.length,
            itemBuilder: (context, index) {
              final habit = habitProvider.habits[index];
              return HabitCard(habit: habit);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHabitScreen(),
            ),
          );
        },
        backgroundColor: const Color.fromARGB(255, 46, 42, 70),
        foregroundColor: const Color.fromARGB(255, 237, 236, 243),
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}