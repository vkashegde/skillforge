import 'package:go_router/go_router.dart';
import '../../features/landing/presentation/pages/landing_page.dart';

/// Application router configuration
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'landing',
        builder: (context, state) => const LandingPage(),
      ),
      // TODO: Add more routes here
    ],
  );
}
