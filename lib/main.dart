import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/config/supabase_config.dart';
import 'core/di/injection_container.dart' as di;
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file (for local development only)
  // In production builds, use --dart-define flags instead
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    // .env file not found - this is OK if using --dart-define in production
    // AppConstants will use String.fromEnvironment values instead
    if (kDebugMode) {
      print('Warning: .env file not found. Using --dart-define values if available.');
    }
  }

  // Initialize Supabase
  await initializeSupabase();

  // Initialize dependency injection
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Skill Forge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: AppRouter.router,
    );
  }
}
