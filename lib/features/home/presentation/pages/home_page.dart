import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/utils/auth_helper.dart';
import '../../../profile/presentation/utils/profile_helper.dart';
import '../widgets/app_layout.dart';
import 'dashboard_content.dart';

/// Home page / Dashboard
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isCheckingProfile = true;

  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  Future<void> _checkProfile() async {
    // Check if user is logged in
    if (!AuthHelper.isLoggedIn()) {
      if (mounted) {
        context.go('/');
      }
      return;
    }

    // Check if user has profile
    final hasProfile = await ProfileHelper.hasProfile();
    if (mounted) {
      setState(() => _isCheckingProfile = false);
      if (!hasProfile) {
        // User doesn't have profile, redirect to onboarding
        context.go('/onboarding/goal');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingProfile) {
      return const Scaffold(
        backgroundColor: Color(0xFF0A0A0A),
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9333EA)),
          ),
        ),
      );
    }

    return AppLayout(
      currentRoute: '/app/home',
      child: const DashboardContent(),
    );
  }
}
