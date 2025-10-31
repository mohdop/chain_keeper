import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/supabase_auth_provider.dart';
import 'supabase_login_screen.dart';
import 'home_screen.dart';

class SupabaseAuthWrapper extends StatelessWidget {
  const SupabaseAuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<SupabaseAuthProvider>(context);

    // Show loading screen while checking auth state
    if (authProvider.isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Chargement...',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    // If user is authenticated, show home screen
    // Otherwise show login screen
    return authProvider.isAuthenticated 
        ? const HomeScreen() 
        : const SupabaseLoginScreen();
  }
}