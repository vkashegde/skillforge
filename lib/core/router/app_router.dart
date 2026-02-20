import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';

/// Application router configuration
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      // TODO: Add more routes here
    ],
  );
}
