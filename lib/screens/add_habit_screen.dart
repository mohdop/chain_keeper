import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({Key? key}) : super(key: key);

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final _nameController = TextEditingController();
  String _selectedVisualType = 'garden';
  TimeOfDay _reminderTime = const TimeOfDay(hour: 8, minute: 0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = Theme.of(context).colorScheme.surface;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nouvelle habitude'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
        
          
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nom de l\'habitude',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nameController,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: 'Ex: Faire du sport',
                        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                        filled: true,
                        fillColor: surface,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text('Thème visuel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildVisualTypeButton(isDark, surface, 'garden', Icons.local_florist, 'Jardin'),
                        _buildVisualTypeButton(isDark, surface, 'bridge', Icons.architecture, 'Pont'),
                        _buildVisualTypeButton(isDark, surface, 'constellation', Icons.auto_awesome, 'Étoiles'),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text('Heure de rappel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: _selectTime,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, color: Color(0xFF6C63FF)),
                            const SizedBox(width: 15),
                            Text(
                              '${_reminderTime.hour.toString().padLeft(2, '0')}:${_reminderTime.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios, size: 16),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding:  EdgeInsets.only(top: MediaQuery.heightOf(context)* .32),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _saveHabit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: const Text('Créer', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      
    );
  }

  Widget _buildVisualTypeButton(bool isDark, Color surface, String type, IconData icon, String label) {
    final isSelected = _selectedVisualType == type;

    return GestureDetector(
      onTap: () => setState(() => _selectedVisualType = type),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6C63FF).withOpacity(0.2) : surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF6C63FF)
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).colorScheme.onSurface),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );

    if (picked != null && picked != _reminderTime) {
      setState(() => _reminderTime = picked);
    }
  }

  void _saveHabit() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un nom')),
      );
      return;
    }

    final habit = Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      visualType: _selectedVisualType,
      createdDate: DateTime.now(),
      reminderHour: _reminderTime.hour,
      reminderMinute: _reminderTime.minute,
    );

    Provider.of<HabitProvider>(context, listen: false).addHabit(habit);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
