import 'package:chain_keeper/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'providers/habit_provider.dart';
import 'providers/theme_provider.dart';
import 'services/notification_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser les timezones pour les notifications
  tz.initializeTimeZones();
  
  // Initialiser les notifications
  await NotificationService().initialize();
  
  // Initialiser les formats de date
  await initializeDateFormatting();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitProvider()..loadHabits()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Chain Keeper',
            debugShowCheckedModeBanner: false,
            theme: ThemeProvider.lightTheme,
            darkTheme: ThemeProvider.darkTheme,
            themeMode: themeProvider.materialThemeMode,
            home: const SplashScreen(), // ← Change ici
          );
        },
      ),
    );
  }
}

// Écran de chargement qui vérifie si c'est la première fois
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    // Petit délai pour un effet de splash
    await Future.delayed(const Duration(milliseconds: 1000));
    
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('onboarding_completed') ?? false;

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => hasSeenOnboarding
              ? const HomeScreen()
              : const OnboardingScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0F0F1E),
                    const Color(0xFF1A1A2E),
                  ]
                : [
                    const Color(0xFFFAFAFA),
                    const Color(0xFFE8E8E8),
                  ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo avec gradient (comme ton logo)
              Container(
                height: 256,
                width: 256,
                child: Image.asset("assets/icon/app icon nobg.png"),
              ),
              const SizedBox(height: 30),
              
              // Nom de l'app
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF8B5CF6),
                    Color(0xFFEC4899),
                  ],
                ).createShader(bounds),
                child: const Text(
                  'Chain Keeper',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Loading indicator
              SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFF8B5CF6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



