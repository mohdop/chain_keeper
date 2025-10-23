import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          
          // Section Apparence
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'APPARENCE',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          
          // Sélecteur de thème
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return Column(
                children: [
                  _ThemeTile(
                    title: 'Thème clair',
                    subtitle: 'Interface lumineuse et claire',
                    icon: Icons.light_mode,
                    isSelected: themeProvider.themeMode == AppThemeMode.light,
                    onTap: () {
                      themeProvider.setThemeMode(AppThemeMode.light);
                    },
                  ),
                  _ThemeTile(
                    title: 'Thème sombre',
                    subtitle: 'Interface sombre et reposante',
                    icon: Icons.dark_mode,
                    isSelected: themeProvider.themeMode == AppThemeMode.dark,
                    onTap: () {
                      themeProvider.setThemeMode(AppThemeMode.dark);
                    },
                  ),
                  _ThemeTile(
                    title: 'Système',
                    subtitle: 'Suit les paramètres du système',
                    icon: Icons.brightness_auto,
                    isSelected: themeProvider.themeMode == AppThemeMode.system,
                    onTap: () {
                      themeProvider.setThemeMode(AppThemeMode.system);
                    },
                  ),
                ],
              );
            },
          ),
          
          const SizedBox(height: 20),
          
          // Section À propos
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'À PROPOS',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Version'),
            subtitle: const Text('1.0.0'),
            onTap: () {},
          ),
          
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('Code source'),
            subtitle: const Text('Voir sur GitHub'),
            trailing: const Icon(Icons.open_in_new, size: 20),
            onTap: () {
              // Ouvrir le lien GitHub
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: const Text('Développé avec ❤️'),
            subtitle: const Text('Par Mohamed'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected 
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                : Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).iconTheme.color,
            size: 28,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : null,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: isSelected 
            ? Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: onTap,
      ),
    );
  }
}