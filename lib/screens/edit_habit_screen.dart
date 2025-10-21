import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';

class EditHabitScreen extends StatefulWidget {
  final Habit habit;

  const EditHabitScreen({Key? key, required this.habit}) : super(key: key);

  @override
  State<EditHabitScreen> createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  late TextEditingController _nameController;
  late String _selectedVisualType;
  late TimeOfDay _reminderTime;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.habit.name);
    _selectedVisualType = widget.habit.visualType;
    _reminderTime = TimeOfDay(
      hour: widget.habit.reminderHour,
      minute: widget.habit.reminderMinute,
    );

    _nameController.addListener(() {
      setState(() {
        _hasChanges = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_hasChanges) {
          return await _showDiscardDialog() ?? false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Modifier l\'habitude'),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            if (_hasChanges)
              TextButton(
                onPressed: _saveChanges,
                child: const Text(
                  'SAUVEGARDER',
                  style: TextStyle(
                    color: Color(0xFF6C63FF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nom de l'habitude
              const Text(
                'Nom de l\'habitude',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Ex: Faire du sport',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: const Color(0xFF2A2A3E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              
              const SizedBox(height: 30),

              // Thème visuel
              const Text(
                'Thème visuel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildVisualTypeButton('garden', Icons.local_florist, 'Jardin'),
                  _buildVisualTypeButton('bridge', Icons.architecture, 'Pont'),
                  _buildVisualTypeButton('constellation', Icons.auto_awesome, 'Étoiles'),
                ],
              ),
              
              const SizedBox(height: 30),

              // Heure de rappel
              const Text(
                'Heure de rappel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _selectTime,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A3E),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: Color(0xFF6C63FF)),
                      const SizedBox(width: 15),
                      Text(
                        '${_reminderTime.hour.toString().padLeft(2, '0')}:${_reminderTime.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Informations
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A3E).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.orange,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Changer le thème visuel réinitialisera l\'animation mais conservera votre streak !',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Bouton sauvegarder
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _hasChanges ? _saveChanges : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    disabledBackgroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Sauvegarder les modifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVisualTypeButton(String type, IconData icon, String label) {
    final isSelected = _selectedVisualType == type;
    final isOriginal = type == widget.habit.visualType;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedVisualType = type;
          _hasChanges = true;
        });
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF6C63FF).withOpacity(0.3) 
              : const Color(0xFF2A2A3E),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF6C63FF) 
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 40, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            if (isOriginal)
              Positioned(
                top: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00D9A5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF6C63FF),
              onPrimary: Colors.white,
              surface: Color(0xFF2A2A3E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _reminderTime) {
      setState(() {
        _reminderTime = picked;
        _hasChanges = true;
      });
    }
  }

  Future<bool?> _showDiscardDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A3E),
        title: const Text('Modifications non sauvegardées'),
        content: const Text(
          'Voulez-vous vraiment quitter sans sauvegarder vos modifications ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Quitter',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _saveChanges() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Le nom ne peut pas être vide')),
      );
      return;
    }

    // Mettre à jour l'habitude
    widget.habit.name = _nameController.text;
    widget.habit.visualType = _selectedVisualType;
    widget.habit.reminderHour = _reminderTime.hour;
    widget.habit.reminderMinute = _reminderTime.minute;

    // Sauvegarder dans le provider
    final habitProvider = Provider.of<HabitProvider>(context, listen: false);
    habitProvider.updateHabit(widget.habit);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Habitude modifiée avec succès !'),
        backgroundColor: Color(0xFF00D9A5),
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}