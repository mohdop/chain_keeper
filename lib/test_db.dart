import 'services/database_service.dart';
import 'models/habit.dart';

void testDatabase() async {
  final db = DatabaseService();
  
  // Créer un habit de test
  final habit = Habit(
    id: '1',
    name: 'Test',
    visualType: 'garden',
    createdDate: DateTime.now(),
    reminderHour: 8,
    reminderMinute: 0,
  );
  
  // Sauvegarder
  await db.saveHabit(habit);
  print('Habit sauvegardé !');
  
  // Charger
  final habits = await db.loadHabits();
  print('Nombre de habits: ${habits.length}');
  print('Premier habit: ${habits.first.name}');
}