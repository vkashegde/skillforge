import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/landing/presentation/pages/landing_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/home/presentation/pages/dashboard_content.dart';
import '../../features/home/presentation/widgets/app_layout.dart';
import '../../features/onboarding/presentation/pages/onboarding_goal_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_skill_level_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_time_commitment_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_summary_page.dart';
import '../../features/topics/presentation/pages/topic_content.dart';
import '../../features/auth/presentation/utils/auth_helper.dart';
import '../../features/practice_labs/presentation/pages/practice_labs_page.dart';

/// Application router configuration
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // Check if user is trying to access protected routes
      final isLoggedIn = AuthHelper.isLoggedIn();
      final isAppRoute = state.matchedLocation.startsWith('/app/');

      // If accessing app routes without being logged in, redirect to landing
      if (isAppRoute && !isLoggedIn) {
        return '/';
      }

      // Profile checks are done asynchronously in the pages themselves
      // because redirect is synchronous and can't await
      return null;
    },
    routes: [
      GoRoute(path: '/', name: 'landing', builder: (context, state) => const LandingPage()),
      GoRoute(path: '/login', name: 'login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/signup', name: 'signup', builder: (context, state) => const SignupPage()),
      // Legacy home route (redirects to /app/home)
      GoRoute(path: '/home', redirect: (context, state) => '/app/home'),
      // Onboarding routes
      GoRoute(
        path: '/onboarding/goal',
        name: 'onboarding-goal',
        builder: (context, state) => const OnboardingGoalPage(),
      ),
      GoRoute(
        path: '/onboarding/skill-level',
        name: 'onboarding-skill-level',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OnboardingSkillLevelPage(goal: extra?['goal'] as String?);
        },
      ),
      GoRoute(
        path: '/onboarding/time-commitment',
        name: 'onboarding-time-commitment',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OnboardingTimeCommitmentPage(
            goal: extra?['goal'] as String?,
            skillLevel: extra?['skillLevel'] as String?,
          );
        },
      ),
      GoRoute(
        path: '/onboarding/summary',
        name: 'onboarding-summary',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return OnboardingSummaryPage(
            goal: extra?['goal'] as String?,
            skillLevel: extra?['skillLevel'] as String?,
            timeCommitment: extra?['timeCommitment'] as String?,
          );
        },
      ),
      // Legacy theory route (redirects to /app/theory/:slug)
      GoRoute(
        path: '/theory/:slug',
        redirect: (context, state) {
          final slug = state.pathParameters['slug'] ?? '';
          return '/app/theory/$slug';
        },
      ),
      // App shell route with persistent sidebar
      ShellRoute(
        builder: (context, state, child) {
          final route = state.uri.path;
          
          return AppLayout(
            currentRoute: route,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/app/home',
            name: 'app-home',
            builder: (context, state) => const DashboardContent(),
          ),
          GoRoute(
            path: '/app/theory/:slug',
            name: 'app-theory',
            builder: (context, state) {
              final slug = state.pathParameters['slug'] ?? '';
              return TopicContent(
                key: ValueKey('topic-$slug'), // Force new widget when slug changes
                slug: slug,
              );
            },
          ),
          GoRoute(
            path: '/app/practice',
            name: 'app-practice',
            builder: (context, state) {
              return const PracticeLabsPage();
            },
            routes: [
              GoRoute(
                path: ':problemId',
                name: 'app-practice-problem',
                builder: (context, state) {
                  final problemId = state.pathParameters['problemId'];
                  return PracticeLabsPage(problemId: problemId);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
